import calendar
from datetime import date

from django.contrib import messages
from django.contrib.auth.decorators import login_required
from django.contrib.auth import get_user_model
from django.utils import timezone
from django.shortcuts import get_object_or_404, redirect, render

from .models import (Cycle, Department, DepartmentObjective, Evaluation, FollowUp, IndividualObjective,
                    InstitutionalObjective, Objective, UserDepartment, Validation)


PHASES = [
    ('01', 'Planejamento', 'Até 15 jan', 'Definição dos objetivos organizacionais e individuais'),
    ('02', 'Acompanhamento contínuo', 'Durante todo o ciclo', 'Registros, feedbacks e ajustes de rota'),
    ('03', 'Avaliação intercalar', 'Até 15 jul', 'Autoavaliação e reunião de alinhamento'),
    ('04', 'Avaliação final', 'Até 1ª semana jan', 'Consolidação dos resultados e competências'),
    ('05', 'Feedback e validação', 'Janeiro', 'Validação da chefia, RH e Conselho'),
    ('06', 'Encerramento', 'Até 15 jan', 'Arquivo do resultado e novo ciclo'),
]


def cycle_list_context(request):
    years = list(Cycle.objects.order_by('-year').values_list('year', flat=True).distinct())
    selected_year = request.GET.get('year', '').strip()
    cycles = Cycle.objects.all().order_by('-start_date', '-year')
    if selected_year.isdigit() and int(selected_year) in years:
        cycles = cycles.filter(year=int(selected_year))
    else:
        selected_year = ''
    return {'cycles': cycles, 'years': years, 'selected_year': selected_year}


def is_management(user):
    return user.is_superuser or user.groups.filter(name__in=['Administrador', 'RH', 'Gestor']).exists()


def is_council(user):
    return user.is_superuser or user.groups.filter(name='Conselho de Administração').exists()


def is_manager(user):
    return (
        user.is_authenticated
        and not user.is_superuser
        and not is_council(user)
        and user.groups.filter(name='Gestor').exists()
    )


def can_manage_operational_objectives(user):
    return user.is_authenticated and user.groups.filter(name='Gestor').exists()


def user_department(user):
    profile = UserDepartment.objects.select_related('department').filter(user=user).first()
    return profile.department if profile else None


def is_collaborator(user):
    return user.groups.filter(name='Colaborador').exists()


def objective_department_for_request(request, department_objective):
    """Completa objetivos antigos que ainda não tinham departamento gravado."""
    if department_objective.department_id:
        return department_objective.department
    department = user_department(request.user)
    if department:
        department_objective.department = department
        department_objective.save(update_fields=['department', 'date_update'])
    return department


def get_department_summaries():
    summaries = []
    departments = Department.objects.filter(is_active=True).prefetch_related(
        'users__user__groups', 'objectives__individual_objectives',
        'objectives__institutional_objective__cycle'
    )
    for department in departments:
        department_objectives = list(department.objectives.all())
        department_objective_count = len(department_objectives)
        completed_department_objective_count = sum(
            objective.automatic_status == 'completed' for objective in department_objectives
        )
        individual_objective_count = sum(
            objective.individual_objectives.count()
            for objective in department_objectives
        )
        collaborators = [
            profile.user for profile in department.users.all()
            if any(group.name == 'Colaborador' for group in profile.user.groups.all())
        ]
        if department_objective_count or collaborators:
            summaries.append({
                'department': department,
                'department_objective_count': department_objective_count,
                'completed_department_objective_count': completed_department_objective_count,
                'department_completion_percentage': (
                    round(completed_department_objective_count * 100 / department_objective_count)
                    if department_objective_count else 0
                ),
                'individual_objective_count': individual_objective_count,
                'collaborators': collaborators,
            })
    return summaries


def get_current_cycle_monthly_progress(cycle):
    """Evolução mensal acumulada dos objetivos concluídos no ciclo atual."""
    if not cycle:
        return [], ''

    objectives = list(DepartmentObjective.objects.filter(
        institutional_objective__cycle=cycle
    ).only('status', 'date_update'))
    total = len(objectives)
    today = timezone.localdate()
    last_date = min(today, cycle.end_date)
    if last_date < cycle.start_date:
        return [], ''

    month_names = ('Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez')
    cursor = date(cycle.start_date.year, cycle.start_date.month, 1)
    progress = []
    while cursor <= last_date:
        month_end = date(cursor.year, cursor.month, calendar.monthrange(cursor.year, cursor.month)[1])
        reference_date = min(month_end, last_date)
        completed = sum(
            objective.status == 'completed' and objective.date_update.date() <= reference_date
            for objective in objectives
        )
        progress.append({
            'label': f'{month_names[cursor.month - 1]} {cursor.year}',
            'month': month_names[cursor.month - 1],
            'total': total,
            'completed': completed,
            'percentage': round(completed * 100 / total) if total else 0,
        })
        cursor = date(cursor.year + (cursor.month == 12), (cursor.month % 12) + 1, 1)

    # Coordenadas para o gráfico SVG: margem horizontal de 48 a 760 e eixo Y de 172 a 42.
    count = len(progress)
    for index, item in enumerate(progress):
        item['svg_x'] = 404 if count == 1 else round(48 + index * 712 / (count - 1))
        item['svg_y'] = 172 - round(item['percentage'] * 1.3)
    points = ' '.join(f"{item['svg_x']},{item['svg_y']}" for item in progress)
    return progress, points


def get_manager_monthly_progress(cycle, department):
    """Evolução mensal dos objetivos individuais do departamento do gestor."""
    if not cycle or not department:
        return [], ''

    objectives = list(IndividualObjective.objects.filter(
        department_objective__department=department,
        department_objective__institutional_objective__cycle=cycle,
    ).only('status', 'date_update'))
    total = len(objectives)
    today = timezone.localdate()
    last_date = min(today, cycle.end_date)
    if last_date < cycle.start_date:
        return [], ''

    month_names = ('Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez')
    cursor = date(cycle.start_date.year, cycle.start_date.month, 1)
    progress = []
    while cursor <= last_date:
        month_end = date(cursor.year, cursor.month, calendar.monthrange(cursor.year, cursor.month)[1])
        reference_date = min(month_end, last_date)
        completed = sum(
            objective.status == 'completed' and objective.date_update.date() <= reference_date
            for objective in objectives
        )
        progress.append({
            'label': f'{month_names[cursor.month - 1]} {cursor.year}',
            'month': month_names[cursor.month - 1],
            'total': total,
            'completed': completed,
            'percentage': round(completed * 100 / total) if total else 0,
        })
        cursor = date(cursor.year + (cursor.month == 12), (cursor.month % 12) + 1, 1)

    count = len(progress)
    for index, item in enumerate(progress):
        item['svg_x'] = 404 if count == 1 else round(48 + index * 712 / (count - 1))
        item['svg_y'] = 172 - round(item['percentage'] * 1.3)
    points = ' '.join(f"{item['svg_x']},{item['svg_y']}" for item in progress)
    return progress, points


def can_plan(user):
    return is_management(user) or is_council(user)


def management_required(view):
    @login_required
    def wrapped(request, *args, **kwargs):
        if not is_management(request.user):
            messages.error(request, 'Seu nível de acesso não permite criar ciclos.')
            return redirect('menu_home')
        return view(request, *args, **kwargs)
    return wrapped


def planning_required(view):
    @login_required
    def wrapped(request, *args, **kwargs):
        if not can_plan(request.user):
            messages.error(request, 'Seu nível de acesso não permite definir ciclos e objetivos organizacionais.')
            return redirect('menu_home')
        return view(request, *args, **kwargs)
    return wrapped


def objective_write_required(view):
    """Apenas gestores podem alterar objetivos departamentais e individuais."""
    @login_required
    def wrapped(request, *args, **kwargs):
        if not can_manage_operational_objectives(request.user):
            messages.error(request, 'Acesso apenas de consulta a estes objetivos.')
            return redirect('menu_home')
        return view(request, *args, **kwargs)
    return wrapped


@login_required
def menu_home(request):
    if is_manager(request.user):
        manager_department = user_department(request.user)
        department_objectives = DepartmentObjective.objects.select_related(
            'institutional_objective__cycle', 'department'
        ).order_by('-date_created')
        individual_objectives = IndividualObjective.objects.select_related(
            'department_objective__institutional_objective__cycle', 'user'
        ).order_by('-date_created')
        if manager_department:
            department_objectives = department_objectives.filter(department=manager_department)
            individual_objectives = individual_objectives.filter(
                department_objective__department=manager_department
            )
        else:
            department_objectives = department_objectives.none()
            individual_objectives = individual_objectives.none()

        individual_objective_list = list(individual_objectives)
        collaborators = get_user_model().objects.filter(
            is_active=True,
            groups__name='Colaborador',
            department_profile__department=manager_department,
        ).distinct().order_by('first_name', 'username') if manager_department else []
        collaborator_progress = []
        for collaborator in collaborators:
            objectives_for_collaborator = [
                objective for objective in individual_objective_list
                if objective.user_id == collaborator.id
            ]
            total = len(objectives_for_collaborator)
            completed = sum(
                objective.status == 'completed' for objective in objectives_for_collaborator
            )
            collaborator_progress.append({
                'user': collaborator,
                'total': total,
                'completed': completed,
                'percentage': round(completed * 100 / total) if total else 0,
            })
        progress_total = len(individual_objective_list)
        progress_completed = sum(
            objective.status == 'completed' for objective in individual_objective_list
        )
        progress_percentage = round(progress_completed * 100 / progress_total) if progress_total else 0
        active_cycle = Cycle.objects.filter(
            start_date__lte=timezone.localdate(), end_date__gte=timezone.localdate()
        ).order_by('-start_date').first()
        monthly_manager_progress, monthly_manager_points = get_manager_monthly_progress(
            active_cycle, manager_department
        )
        return render(request, 'gestor/dashboard.html', {
            'active_cycle': active_cycle,
            'department_total': department_objectives.count(),
            'individual_total': individual_objectives.count(),
            'active_department_total': sum(item.automatic_status == 'active' for item in department_objectives),
            'active_individual_total': sum(item.automatic_status == 'active' for item in individual_objectives),
            'department_objectives': department_objectives[:5],
            'individual_objectives': individual_objectives[:5],
            'department_summaries': get_department_summaries(),
            'manager_department': manager_department,
            'collaborator_progress': collaborator_progress,
            'progress_total': progress_total,
            'progress_completed': progress_completed,
            'progress_pending': progress_total - progress_completed,
            'progress_percentage': progress_percentage,
            'monthly_manager_progress': monthly_manager_progress,
            'monthly_manager_points': monthly_manager_points,
        })

    cycles = Cycle.objects.all()
    active_cycle = next((cycle for cycle in cycles if cycle.automatic_status == 'active'), None)
    active_objectives_count = sum(item.automatic_status == 'active' for item in InstitutionalObjective.objects.all()) + sum(item.automatic_status == 'active' for item in DepartmentObjective.objects.all()) + sum(item.automatic_status == 'active' for item in IndividualObjective.objects.all())
    completed_objectives_count = sum(item.automatic_status == 'completed' for item in InstitutionalObjective.objects.all()) + sum(item.automatic_status == 'completed' for item in DepartmentObjective.objects.all()) + sum(item.automatic_status == 'completed' for item in IndividualObjective.objects.all())
    objective_total = active_objectives_count + completed_objectives_count
    level_chart = [
        {'label': 'Institucionais', 'value': InstitutionalObjective.objects.count(), 'color': 'institutional'},
        {'label': 'Departamentais', 'value': DepartmentObjective.objects.count(), 'color': 'departmental'},
        {'label': 'Individuais', 'value': IndividualObjective.objects.count(), 'color': 'individual'},
    ]
    level_total = sum(item['value'] for item in level_chart)
    for item in level_chart:
        item['percentage'] = round(item['value'] * 100 / level_total) if level_total else 0
    department_chart = []
    for item in InstitutionalObjective.objects.all().prefetch_related('department_objectives'):
        total = item.department_objectives.count()
        if total:
            department_chart.append({'label': item.description, 'value': total, 'percentage': round(total * 100 / max(DepartmentObjective.objects.count(), 1))})
    department_chart.sort(key=lambda item: item['value'], reverse=True)
    council_department_summaries = get_department_summaries() if is_council(request.user) else []
    department_objective_total = sum(
        item['department_objective_count'] for item in council_department_summaries
    )
    department_distribution = [
        {
            'label': item['department'].name,
            'value': item['department_objective_count'],
            'percentage': round(item['department_objective_count'] * 100 / department_objective_total),
        }
        for item in council_department_summaries
        if item['department_objective_count']
    ]
    monthly_completion_progress, monthly_completion_points = (
        get_current_cycle_monthly_progress(active_cycle)
        if is_council(request.user) else ([], '')
    )
    context = {
        'cycles_count': cycles.count(),
        'active_cycle': active_cycle,
        'institutional_count': InstitutionalObjective.objects.count(),
        'departmental_count': DepartmentObjective.objects.count(),
        'individual_count': IndividualObjective.objects.count(),
        'user_count': get_user_model().objects.filter(is_active=True).count(),
        'active_objectives_count': active_objectives_count,
        'completed_objectives_count': completed_objectives_count,
        'objective_total': objective_total,
        'active_percentage': round(active_objectives_count * 100 / objective_total) if objective_total else 0,
        'completed_percentage': round(completed_objectives_count * 100 / objective_total) if objective_total else 0,
        'level_chart': level_chart,
        'level_total': level_total,
        'department_chart': department_chart[:6],
        'department_summaries': council_department_summaries,
        'department_distribution': department_distribution,
        'department_objective_total': department_objective_total,
        'monthly_completion_progress': monthly_completion_progress,
        'monthly_completion_points': monthly_completion_points,
    }
    return render(request, 'menu/home.html', context)


@login_required
def dashboard(request):
    cycle = Cycle.objects.filter(status='active').first()
    cycles = Cycle.objects.all()
    evaluations = Evaluation.objects.filter(cycle=cycle) if cycle else Evaluation.objects.none()
    objectives = Objective.objects.filter(cycle=cycle, category='organizational') if cycle else Objective.objects.none()
    if not is_management(request.user):
        evaluations = evaluations.filter(employee=request.user)
    context = {
        'cycle': cycle,
        'cycles': cycles,
        'phases': PHASES,
        'evaluations': evaluations.select_related('employee', 'evaluator')[:6],
        'objectives': objectives[:5],
        'objectives_count': objectives.count(),
        'total_evaluations': evaluations.count(),
        'pending_count': evaluations.filter(status='pending').count(),
        'submitted_count': evaluations.filter(status__in=['submitted', 'validated']).count(),
        'validated_count': evaluations.filter(status='validated').count(),
        'can_manage': is_management(request.user),
        'can_plan': can_plan(request.user),
    }
    template_name = 'CA/dashboard.html' if is_council(request.user) else 'core/dashboard.html'
    return render(request, template_name, context)


@login_required
def process_flow(request):
    return render(request, 'core/process_flow.html', {'phases': PHASES})


@login_required
def planejamento_dashboard(request):
    cycles = Cycle.objects.all().order_by('-start_date')
    return render(request, 'core/planejamento_dashboard.html', {'cycles': cycles})


@login_required
def planejamento_ciclo_detail(request, cycle_id):
    cycle = get_object_or_404(Cycle, pk=cycle_id)
    institucionais = InstitutionalObjective.objects.filter(cycle=cycle).order_by('-date_created')
    contexto = {
        'cycle': cycle,
        'institucionais': institucionais,
    }
    return render(request, 'core/planejamento_ciclo_detail.html', contexto)


@login_required
def planejamento_ciclo_create(request):
    if request.method == 'POST':
        name = request.POST.get('name', '').strip()
        year = request.POST.get('year', '').strip()
        start_date = request.POST.get('start_date', '').strip()
        end_date = request.POST.get('end_date', '').strip()
        if not name or not year or not start_date or not end_date:
            messages.error(request, 'Preencha todos os campos do ciclo.')
            return redirect('planejamento_ciclo_create')
        cycle = Cycle.objects.create(
            name=name,
            year=int(year),
            start_date=start_date,
            end_date=end_date,
            status=request.POST.get('status', 'planned'),
        )
        messages.success(request, f'Ciclo {cycle} criado com sucesso.')
        return redirect('planejamento_ciclo_create')
    context = cycle_list_context(request)
    context['editing'] = False
    return render(request, 'ciclo/novo.html', context)


@login_required
def planejamento_ciclo_edit(request, cycle_id):
    cycle = get_object_or_404(Cycle, pk=cycle_id)
    if request.method == 'POST':
        cycle.name = request.POST.get('name', cycle.name).strip()
        cycle.year = request.POST.get('year', cycle.year)
        cycle.start_date = request.POST.get('start_date', cycle.start_date)
        cycle.end_date = request.POST.get('end_date', cycle.end_date)
        cycle.status = request.POST.get('status', cycle.status)
        cycle.save()
        messages.success(request, 'Ciclo atualizado com sucesso.')
        return redirect('planejamento_ciclo_create')
    context = cycle_list_context(request)
    context.update({'cycle': cycle, 'editing': True})
    return render(request, 'ciclo/novo.html', context)


@login_required
def planejamento_ciclo_delete(request, cycle_id):
    cycle = get_object_or_404(Cycle, pk=cycle_id)
    if request.method == 'POST':
        cycle.delete()
        messages.success(request, 'Ciclo removido com sucesso.')
        return redirect('planejamento_ciclo_create')
    return redirect('planejamento_ciclo_detail', cycle_id=cycle.id)


@login_required
def planejamento_objetivo_institucional_menu(request):
    cycles = list(Cycle.objects.all().order_by('-start_date', '-year'))
    current_cycle = next((cycle for cycle in cycles if cycle.automatic_status == 'active'), None)
    if current_cycle:
        cycles.remove(current_cycle)
        cycles.insert(0, current_cycle)
    if request.method == 'POST':
        description = request.POST.get('description', '').strip()
        if not description:
            messages.error(request, 'Descreva o objetivo institucional.')
            return redirect('planejamento_objetivo_institucional_menu')
        if not current_cycle:
            messages.error(request, 'Não existe um ciclo em andamento para associar o objetivo.')
            return redirect('planejamento_objetivo_institucional_menu')
        InstitutionalObjective.objects.create(cycle=current_cycle, description=description, status='active')
        messages.success(request, 'Objetivo institucional criado.')
        return redirect('planejamento_objetivo_institucional_menu')
    years = list(
        InstitutionalObjective.objects.order_by('-cycle__year')
        .values_list('cycle__year', flat=True)
        .distinct()
    )
    selected_year = request.GET.get('year', '').strip()
    objetivos = InstitutionalObjective.objects.select_related('cycle').order_by('-date_created')
    if selected_year.isdigit() and int(selected_year) in years:
        objetivos = objetivos.filter(cycle__year=int(selected_year))
    else:
        selected_year = ''
    return render(request, 'objetivo_institucional/novo.html', {
        'objetivos': objetivos,
        'cycles': cycles,
        'current_cycle': current_cycle,
        'years': years,
        'selected_year': selected_year,
    })


@login_required
def planejamento_objetivo_institucional_create(request, cycle_id):
    cycle = get_object_or_404(Cycle, pk=cycle_id)
    if request.method == 'POST':
        description = request.POST.get('description', '').strip()
        if not description:
            messages.error(request, 'Descreva o objetivo institucional.')
            return redirect('planejamento_ciclo_detail', cycle_id=cycle.id)
        InstitutionalObjective.objects.create(cycle=cycle, description=description, status=request.POST.get('status', 'draft'))
        messages.success(request, 'Objetivo institucional criado.')
        return redirect('planejamento_ciclo_detail', cycle_id=cycle.id)
    return render(request, 'core/planejamento_objetivo_form.html', {'cycle': cycle, 'kind': 'institucional', 'editing': False})


@login_required
def planejamento_objetivo_departamental_menu(request):
    institucionais = InstitutionalObjective.objects.select_related('cycle').order_by('-date_created')
    institucional = institucionais.filter(
        cycle__start_date__lte=timezone.localdate(),
        cycle__end_date__gte=timezone.localdate(),
    ).first()
    if request.method == 'POST' and not can_manage_operational_objectives(request.user):
        messages.error(request, 'Acesso apenas de consulta a estes objetivos.')
        return redirect('planejamento_objetivo_departamental_menu')
    if request.method == 'POST':
        description = request.POST.get('description', '').strip()
        institutional_objective_id = request.POST.get('institutional_objective')
        department = user_department(request.user)
        if not description:
            messages.error(request, 'Descreva o objetivo departamental.')
            return redirect('planejamento_objetivo_departamental_menu')
        if not institutional_objective_id:
            messages.error(request, 'Selecione o objetivo institucional.')
            return redirect('planejamento_objetivo_departamental_menu')
        if not department:
            messages.error(request, 'Associe um departamento ao utilizador antes de criar o objetivo.')
            return redirect('planejamento_objetivo_departamental_menu')
        institucional = get_object_or_404(InstitutionalObjective, pk=institutional_objective_id)
        DepartmentObjective.objects.create(
            institutional_objective=institucional,
            department=department,
            description=description,
            status='active',
        )
        messages.success(request, 'Objetivo departamental criado.')
        return redirect('planejamento_objetivo_departamental_menu')
    objetivos = DepartmentObjective.objects.select_related(
        'institutional_objective__cycle', 'department'
    ).order_by('-date_created')
    return render(request, 'objetivo_departamental/novo.html', {
        'objetivos': objetivos,
        'institucional': institucional,
        'institucionais': institucionais,
        'read_only': not can_manage_operational_objectives(request.user),
    })


@login_required
def planejamento_objetivo_institucional_edit(request, objetivo_id):
    objetivo = get_object_or_404(InstitutionalObjective, pk=objetivo_id)
    if request.method == 'POST':
        objetivo.description = request.POST.get('description', objetivo.description).strip()
        objetivo.status = request.POST.get('status', objetivo.status)
        objetivo.save()
        messages.success(request, 'Objetivo institucional atualizado.')
        if request.POST.get('next') == 'objective_menu':
            return redirect('planejamento_objetivo_institucional_menu')
        return redirect('planejamento_ciclo_detail', cycle_id=objetivo.cycle_id)
    return render(request, 'core/planejamento_objetivo_form.html', {'cycle': objetivo.cycle, 'objetivo': objetivo, 'kind': 'institucional', 'editing': True})


@login_required
def planejamento_objetivo_institucional_delete(request, objetivo_id):
    objetivo = get_object_or_404(InstitutionalObjective, pk=objetivo_id)
    if request.method == 'POST':
        cycle_id = objetivo.cycle_id
        objetivo.delete()
        messages.success(request, 'Objetivo institucional removido.')
        if request.POST.get('next') == 'objective_menu':
            return redirect('planejamento_objetivo_institucional_menu')
        return redirect('planejamento_ciclo_detail', cycle_id=cycle_id)
    return redirect('planejamento_ciclo_detail', cycle_id=objetivo.cycle_id)


@objective_write_required
def planejamento_objetivo_departamental_create(request, objetivo_id):
    institucional = get_object_or_404(InstitutionalObjective, pk=objetivo_id)
    if request.method == 'POST':
        description = request.POST.get('description', '').strip()
        department = user_department(request.user)
        if not description:
            messages.error(request, 'Descreva o objetivo departamental.')
            return redirect('planejamento_ciclo_detail', cycle_id=institucional.cycle_id)
        if not department:
            messages.error(request, 'Associe um departamento ao utilizador antes de criar o objetivo.')
            return redirect('planejamento_ciclo_detail', cycle_id=institucional.cycle_id)
        DepartmentObjective.objects.create(
            institutional_objective=institucional,
            department=department,
            description=description,
            status=request.POST.get('status', 'draft'),
        )
        messages.success(request, 'Objetivo departamental criado.')
        return redirect('planejamento_ciclo_detail', cycle_id=institucional.cycle_id)
    return render(request, 'core/planejamento_objetivo_form.html', {'cycle': institucional.cycle, 'kind': 'departamental', 'parent': institucional, 'editing': False})


@objective_write_required
def planejamento_objetivo_departamental_edit(request, objetivo_id):
    objetivo = get_object_or_404(DepartmentObjective, pk=objetivo_id)
    if request.method == 'POST':
        objetivo.description = request.POST.get('description', objetivo.description).strip()
        institutional_objective_id = request.POST.get('institutional_objective')
        if institutional_objective_id:
            objetivo.institutional_objective = get_object_or_404(InstitutionalObjective, pk=institutional_objective_id)
        objetivo.status = request.POST.get('status', objetivo.status)
        objetivo.save()
        messages.success(request, 'Objetivo departamental atualizado.')
        if request.POST.get('next') == 'department_menu':
            return redirect('planejamento_objetivo_departamental_menu')
        return redirect('planejamento_ciclo_detail', cycle_id=objetivo.institutional_objective.cycle_id)
    return render(request, 'core/planejamento_objetivo_form.html', {'cycle': objetivo.institutional_objective.cycle, 'objetivo': objetivo, 'kind': 'departamental', 'parent': objetivo.institutional_objective, 'editing': True})


@objective_write_required
def planejamento_objetivo_departamental_delete(request, objetivo_id):
    objetivo = get_object_or_404(DepartmentObjective, pk=objetivo_id)
    if request.method == 'POST':
        cycle_id = objetivo.institutional_objective.cycle_id
        objetivo.delete()
        messages.success(request, 'Objetivo departamental removido.')
        if request.POST.get('next') == 'department_menu':
            return redirect('planejamento_objetivo_departamental_menu')
        return redirect('planejamento_ciclo_detail', cycle_id=cycle_id)
    return redirect('planejamento_ciclo_detail', cycle_id=objetivo.institutional_objective.cycle_id)


@objective_write_required
def planejamento_objetivo_individual_create(request, objetivo_id):
    departamental = get_object_or_404(DepartmentObjective, pk=objetivo_id)
    if request.method == 'POST':
        description = request.POST.get('description', '').strip()
        if not description:
            messages.error(request, 'Descreva o objetivo individual.')
            return redirect('planejamento_ciclo_detail', cycle_id=departamental.institutional_objective.cycle_id)
        user_id = request.POST.get('user')
        if not user_id:
            messages.error(request, 'Selecione o utilizador.')
            return redirect('planejamento_ciclo_detail', cycle_id=departamental.institutional_objective.cycle_id)
        user = get_object_or_404(get_user_model(), pk=user_id, is_active=True)
        department = objective_department_for_request(request, departamental)
        if not is_collaborator(user) or not department or user_department(user) != department:
            messages.error(request, 'Selecione um utilizador do mesmo departamento do objetivo.')
            return redirect('planejamento_ciclo_detail', cycle_id=departamental.institutional_objective.cycle_id)
        IndividualObjective.objects.create(department_objective=departamental, user=user, description=description, status=request.POST.get('status', 'draft'))
        messages.success(request, 'Objetivo individual criado.')
        return redirect('planejamento_ciclo_detail', cycle_id=departamental.institutional_objective.cycle_id)
    users = get_user_model().objects.filter(
        is_active=True, groups__name='Colaborador'
    ).select_related('department_profile__department').distinct().order_by('first_name', 'username')
    return render(request, 'core/planejamento_objetivo_form.html', {'cycle': departamental.institutional_objective.cycle, 'kind': 'individual', 'parent': departamental, 'users': users, 'editing': False})


@login_required
def planejamento_objetivo_individual_menu(request):
    departamentos = DepartmentObjective.objects.select_related('institutional_objective__cycle', 'department').order_by('-date_created')
    users = get_user_model().objects.filter(
        is_active=True, groups__name='Colaborador'
    ).select_related('department_profile__department').distinct().order_by('first_name', 'username')
    departamento_ativo = next((item for item in departamentos if item.automatic_status == 'active'), None)
    if request.method == 'POST' and not can_manage_operational_objectives(request.user):
        messages.error(request, 'Acesso apenas de consulta a estes objetivos.')
        return redirect('planejamento_objetivo_individual_menu')
    if request.method == 'POST':
        description = request.POST.get('description', '').strip()
        department_id = request.POST.get('department_objective')
        user_id = request.POST.get('user')
        if not description:
            messages.error(request, 'Descreva o objetivo individual.')
            return redirect('planejamento_objetivo_individual_menu')
        if not department_id or not user_id:
            messages.error(request, 'Selecione o objetivo departamental e o utilizador.')
            return redirect('planejamento_objetivo_individual_menu')
        department = get_object_or_404(DepartmentObjective, pk=department_id)
        user = get_object_or_404(get_user_model(), pk=user_id, is_active=True)
        objective_department = objective_department_for_request(request, department)
        if not is_collaborator(user) or not objective_department or user_department(user) != objective_department:
            messages.error(request, 'Selecione um utilizador do mesmo departamento do objetivo.')
            return redirect('planejamento_objetivo_individual_menu')
        IndividualObjective.objects.create(department_objective=department, user=user, description=description, status='active')
        messages.success(request, 'Objetivo individual criado.')
        return redirect('planejamento_objetivo_individual_menu')
    objetivos = IndividualObjective.objects.select_related(
        'department_objective__institutional_objective__cycle',
        'department_objective__department',
        'user',
    ).order_by('-date_created')
    return render(request, 'objetivo_individual/novo.html', {
        'objetivos': objetivos,
        'departamentos': departamentos,
        'users': users,
        'departamento_ativo': departamento_ativo,
        'read_only': not can_manage_operational_objectives(request.user),
    })


@objective_write_required
def planejamento_objetivo_individual_edit(request, objetivo_id):
    objetivo = get_object_or_404(IndividualObjective, pk=objetivo_id)
    if request.method == 'POST':
        objetivo.description = request.POST.get('description', objetivo.description).strip()
        department_id = request.POST.get('department_objective')
        if department_id:
            objetivo.department_objective = get_object_or_404(DepartmentObjective, pk=department_id)
        if request.POST.get('user'):
            user = get_object_or_404(get_user_model(), pk=request.POST.get('user'), is_active=True)
            objective_department = objective_department_for_request(request, objetivo.department_objective)
            if not is_collaborator(user) or not objective_department or user_department(user) != objective_department:
                messages.error(request, 'Selecione um utilizador do mesmo departamento do objetivo.')
                return redirect('planejamento_objetivo_individual_menu')
            objetivo.user = user
        objetivo.save()
        messages.success(request, 'Objetivo individual atualizado.')
        if request.POST.get('next') == 'individual_menu':
            return redirect('planejamento_objetivo_individual_menu')
        return redirect('planejamento_ciclo_detail', cycle_id=objetivo.department_objective.institutional_objective.cycle_id)
    users = get_user_model().objects.filter(
        is_active=True, groups__name='Colaborador'
    ).select_related('department_profile__department').distinct().order_by('first_name', 'username')
    return render(request, 'core/planejamento_objetivo_form.html', {'cycle': objetivo.department_objective.institutional_objective.cycle, 'objetivo': objetivo, 'kind': 'individual', 'parent': objetivo.department_objective, 'users': users, 'editing': True})


@objective_write_required
def planejamento_objetivo_individual_delete(request, objetivo_id):
    objetivo = get_object_or_404(IndividualObjective, pk=objetivo_id)
    if request.method == 'POST':
        cycle_id = objetivo.department_objective.institutional_objective.cycle_id
        objetivo.delete()
        messages.success(request, 'Objetivo individual removido.')
        if request.POST.get('next') == 'individual_menu':
            return redirect('planejamento_objetivo_individual_menu')
        return redirect('planejamento_ciclo_detail', cycle_id=cycle_id)
    return redirect('planejamento_ciclo_detail', cycle_id=objetivo.department_objective.institutional_objective.cycle_id)


@planning_required
def cycle_create(request):
    if request.method == 'POST':
        name = request.POST.get('name', '').strip()
        year = request.POST.get('year', '').strip()
        start_date = request.POST.get('start_date', '').strip()
        end_date = request.POST.get('end_date', '').strip()
        errors = []
        if not name:
            errors.append('Informe o nome do ciclo.')
        if not year.isdigit() or not 2000 <= int(year) <= 2100:
            errors.append('Informe um ano válido entre 2000 e 2100.')
        if not start_date or not end_date:
            errors.append('Informe as datas de início e fim.')
        if start_date and end_date and start_date > end_date:
            errors.append('A data de fim deve ser posterior ao início.')
        if errors:
            for error in errors:
                messages.error(request, error)
        else:
            cycle = Cycle.objects.create(
                name=name,
                year=int(year),
                start_date=start_date,
                end_date=end_date,
                status=request.POST.get('status', 'planned'),
            )
            messages.success(request, f'Ciclo {cycle} criado com sucesso.')
            if is_council(request.user):
                return redirect('planejamento_ciclo_detail', cycle_id=cycle.id)
            return redirect('cycle_detail', cycle_id=cycle.id)
    template_name = 'CA/cycle_create.html' if is_council(request.user) else 'core/cycle_create.html'
    return render(request, template_name)


@planning_required
def cycle_edit(request, cycle_id):
    cycle = get_object_or_404(Cycle, pk=cycle_id)
    if request.method == 'POST':
        cycle.name = request.POST.get('name', '').strip()
        cycle.year = request.POST.get('year', cycle.year)
        cycle.start_date = request.POST.get('start_date', cycle.start_date)
        cycle.end_date = request.POST.get('end_date', cycle.end_date)
        cycle.status = request.POST.get('status', cycle.status)
        cycle.save()
        messages.success(request, f'Ciclo {cycle} atualizado com sucesso.')
        return redirect('cycle_detail', cycle_id=cycle.id)
    return render(request, 'core/cycle_form.html', {'cycle': cycle, 'editing': True})


@planning_required
def cycle_delete(request, cycle_id):
    cycle = get_object_or_404(Cycle, pk=cycle_id)
    if request.method == 'POST':
        cycle.delete()
        messages.success(request, 'Ciclo removido com sucesso.')
        return redirect('menu_home')
    return render(request, 'core/confirm_delete.html', {'object': cycle, 'object_type': 'ciclo', 'cancel_url': 'cycle_detail', 'cancel_id': cycle.id})


@login_required
def cycle_detail(request, cycle_id):
    cycle = get_object_or_404(Cycle, pk=cycle_id)
    evaluations = cycle.evaluations.select_related('employee', 'evaluator')
    if not is_management(request.user):
        evaluations = evaluations.filter(employee=request.user)
    objectives = cycle.objectives.select_related('employee', 'created_by')
    follow_ups = cycle.follow_ups.select_related('employee', 'author')
    validations = cycle.validations.select_related('evaluation', 'validator')
    if not is_management(request.user):
        objectives = objectives.filter(employee=request.user)
        follow_ups = follow_ups.filter(employee=request.user)
    return render(request, 'core/cycle_detail.html', {'cycle': cycle, 'evaluations': evaluations, 'objectives': objectives, 'follow_ups': follow_ups, 'validations': validations, 'phases': PHASES, 'can_manage': is_management(request.user), 'can_plan': can_plan(request.user)})


@planning_required
def objective_create(request, cycle_id):
    cycle = get_object_or_404(Cycle, pk=cycle_id)
    users = get_user_model().objects.filter(is_active=True).order_by('first_name', 'username')
    if request.method == 'POST':
        category = request.POST.get('category', 'individual')
        if is_council(request.user):
            category = 'organizational'
        Objective.objects.create(cycle=cycle, created_by=request.user, employee_id=None if category == 'organizational' else request.POST.get('employee') or None, category=category, title=request.POST.get('title', '').strip(), description=request.POST.get('description', '').strip(), measure=request.POST.get('measure', '').strip(), status=request.POST.get('status', 'draft'))
        messages.success(request, 'Objetivo registrado no planejamento.')
        return redirect('cycle_detail', cycle_id=cycle.id)
    template_name = 'CA/objective_form.html' if is_council(request.user) else 'core/objective_form.html'
    return render(request, template_name, {'cycle': cycle, 'users': users, 'is_council': is_council(request.user)})


@login_required
def follow_up_create(request, cycle_id):
    cycle = get_object_or_404(Cycle, pk=cycle_id)
    if request.method == 'POST':
        employee_id = request.POST.get('employee') if is_management(request.user) else request.user.id
        FollowUp.objects.create(cycle=cycle, employee_id=employee_id, author=request.user, entry_type=request.POST.get('entry_type', 'evidence'), title=request.POST.get('title', '').strip(), content=request.POST.get('content', '').strip(), next_step=request.POST.get('next_step', '').strip())
        messages.success(request, 'Acompanhamento registrado com sucesso.')
        return redirect('cycle_detail', cycle_id=cycle.id)
    users = get_user_model().objects.filter(is_active=True).order_by('first_name', 'username') if is_management(request.user) else []
    return render(request, 'core/follow_up_form.html', {'cycle': cycle, 'users': users, 'can_manage': is_management(request.user)})


@management_required
def validation_create(request, cycle_id):
    cycle = get_object_or_404(Cycle, pk=cycle_id)
    evaluations = cycle.evaluations.select_related('employee')
    users = get_user_model().objects.filter(is_active=True).order_by('first_name', 'username')
    if request.method == 'POST':
        Validation.objects.create(cycle=cycle, evaluation_id=request.POST.get('evaluation'), validator_id=request.POST.get('validator') or request.user.id, role=request.POST.get('role', 'manager'), status='pending')
        messages.success(request, 'Validação adicionada ao fluxo.')
        return redirect('cycle_detail', cycle_id=cycle.id)
    return render(request, 'core/validation_form.html', {'cycle': cycle, 'evaluations': evaluations, 'users': users})


@management_required
def validation_update(request, validation_id):
    validation = get_object_or_404(Validation, pk=validation_id)
    if request.method == 'POST':
        validation.status = request.POST.get('status', validation.status)
        validation.comment = request.POST.get('comment', '').strip()
        validation.validator = request.user
        validation.validated_at = timezone.now() if validation.status != 'pending' else None
        validation.save()
        messages.success(request, 'Validação atualizada.')
    return redirect('cycle_detail', cycle_id=validation.cycle_id)


@login_required
def evaluation_detail(request, evaluation_id):
    evaluation = get_object_or_404(Evaluation.objects.select_related('cycle', 'employee', 'evaluator'), pk=evaluation_id)
    if not is_management(request.user) and evaluation.employee_id != request.user.id:
        return get_object_or_404(Evaluation, pk=-1)
    return render(request, 'core/evaluation_detail.html', {'evaluation': evaluation, 'can_manage': is_management(request.user)})


@management_required
def evaluation_create(request, cycle_id):
    cycle = get_object_or_404(Cycle, pk=cycle_id)
    users = get_user_model().objects.filter(is_active=True).order_by('first_name', 'username')
    if request.method == 'POST':
        Evaluation.objects.create(
            cycle=cycle,
            employee_id=request.POST.get('employee'),
            evaluator_id=request.POST.get('evaluator') or None,
            evaluation_type=request.POST.get('evaluation_type', 'final'),
            status=request.POST.get('status', 'pending'),
        )
        messages.success(request, 'Avaliação cadastrada com sucesso.')
        return redirect('cycle_detail', cycle_id=cycle.id)
    return render(request, 'core/evaluation_form.html', {'cycle': cycle, 'users': users, 'editing': False})


@login_required
def evaluation_edit(request, evaluation_id):
    evaluation = get_object_or_404(Evaluation, pk=evaluation_id)
    if not is_management(request.user) and evaluation.employee_id != request.user.id:
        return get_object_or_404(Evaluation, pk=-1)
    if request.method == 'POST':
        evaluation.self_score = request.POST.get('self_score') or None
        evaluation.feedback = request.POST.get('feedback', '').strip()
        if is_management(request.user):
            evaluation.manager_score = request.POST.get('manager_score') or None
            evaluation.status = request.POST.get('status', evaluation.status)
        elif evaluation.status == 'pending':
            evaluation.status = 'draft'
        evaluation.save()
        messages.success(request, 'Avaliação atualizada com sucesso.')
        return redirect('evaluation_detail', evaluation_id=evaluation.id)
    return render(request, 'core/evaluation_edit.html', {'evaluation': evaluation, 'can_manage': is_management(request.user)})


@management_required
def evaluation_delete(request, evaluation_id):
    evaluation = get_object_or_404(Evaluation, pk=evaluation_id)
    if request.method == 'POST':
        cycle_id = evaluation.cycle_id
        evaluation.delete()
        messages.success(request, 'Avaliação removida com sucesso.')
        return redirect('cycle_detail', cycle_id=cycle_id)
    return render(request, 'core/confirm_delete.html', {'object': evaluation, 'object_type': 'avaliação', 'cancel_url': 'evaluation_detail', 'cancel_id': evaluation.id})
