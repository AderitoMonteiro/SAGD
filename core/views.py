import calendar
from datetime import date

from django.contrib import messages
from django.contrib.auth.decorators import login_required
from django.contrib.auth import get_user_model
from django.db.models import OuterRef, Subquery
from django.utils import timezone
from django.urls import reverse
from django.shortcuts import get_object_or_404, redirect, render

from .models import (AprovacaoTarefa, Cycle, Department, DepartmentObjective, Domain, Evaluation, FollowUp, IndividualObjective,
                    InstitutionalObjective, Objective, RegistoOcorrencia, UserDepartment, Validation)


PHASES = [
    ('01', 'Planejamento', 'Até 15 jan', 'Definição dos objetivos organizacionais e individuais'),
    ('02', 'Acompanhamento contínuo', 'Durante todo o ciclo', 'Registros, feedbacks e ajustes de rota'),
    ('03', 'Avaliação intercalar', 'Até 15 jul', 'Autoavaliação e reunião de alinhamento'),
    ('04', 'Avaliação final', 'Até 1ª semana jan', 'Consolidação dos resultados e competências'),
    ('05', 'Feedback e validação', 'Janeiro', 'Validação da chefia, RH e Conselho'),
    ('06', 'Encerramento', 'Até 15 jan', 'Arquivo do resultado e novo ciclo'),
]


def individual_objective_dates(request):
    """Valida e devolve o período informado para um objetivo individual."""
    start_value = request.POST.get('start_date', '').strip()
    end_value = request.POST.get('end_date', '').strip()
    if not start_value or not end_value:
        return None, None, 'Indique as datas de início e fim.'
    try:
        start_date = date.fromisoformat(start_value)
        end_date = date.fromisoformat(end_value)
    except ValueError:
        return None, None, 'Indique datas válidas.'
    if end_date < start_date:
        return None, None, 'A data de fim não pode ser anterior à data de início.'
    return start_date, end_date, None


def cycle_domain_for_type(domain_type):
    """Obtém o domínio do ciclo pelo seu type, nunca pelo id."""
    domain = Domain.objects.filter(type=domain_type).order_by('id').first()
    if domain:
        return domain
    labels = {
        1: ('Aberto', 'Ciclo aberto'),
        2: ('Concluído', 'Ciclo concluído'),
    }
    description, domain_description = labels[domain_type]
    return Domain.objects.create(
        description=description,
        type=domain_type,
        domain_description=domain_description,
    )


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
    return user.is_superuser or user.groups.filter(name__in=['Administrador', 'Gestor']).exists()


def is_council(user):
    return user.is_superuser or user.groups.filter(name='Conselho de Administração').exists()


def is_hr(user):
    return user.is_authenticated and not user.is_superuser and user.groups.filter(name='RH').exists()


def can_manage_institutional_objectives(user):
    return user.is_authenticated and (
        user.is_superuser
        or is_council(user)
        or user.groups.filter(name='Administrador').exists()
    )


def can_manage_cycles(user):
    return user.is_authenticated and (
        user.is_superuser
        or is_council(user)
        or user.groups.filter(name='Administrador').exists()
    )


def is_manager(user):
    return (
        user.is_authenticated
        and not user.is_superuser
        and not is_council(user)
        and user.groups.filter(name='Gestor').exists()
    )


def can_manage_operational_objectives(user):
    return user.is_authenticated and (
        user.is_superuser
        or is_council(user)
        or is_hr(user)
        or user.groups.filter(name__in=['Administrador', 'Gestor']).exists()
    )


def can_manage_department_objectives(user):
    return user.is_authenticated and (
        user.is_superuser
        or is_hr(user)
        or user.groups.filter(name__in=['Administrador', 'Gestor']).exists()
    )


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


def department_objectives_for_user(user, queryset=None):
    queryset = queryset if queryset is not None else DepartmentObjective.objects.all()
    if not is_hr(user):
        return queryset
    department = user_department(user)
    return queryset.filter(department=department) if department else queryset.none()


def approved_department_objectives_for_user(user, queryset=None):
    queryset = queryset if queryset is not None else DepartmentObjective.objects.all()
    latest_approval = AprovacaoTarefa.objects.filter(
        department_objective_id=OuterRef('pk')
    ).order_by('-date_created', '-id')
    return department_objectives_for_user(user, queryset).annotate(
        latest_approval_description=Subquery(
            latest_approval.values('domain__description')[:1]
        )
    ).filter(
        latest_approval_description__iexact='Aprovado',
    )


def individual_objectives_for_user(user, queryset=None):
    queryset = queryset if queryset is not None else IndividualObjective.objects.all()
    if is_council(user):
        return queryset.filter(user__groups__name='Gestor').distinct()
    if not is_hr(user):
        return queryset
    department = user_department(user)
    return queryset.filter(department_objective__department=department) if department else queryset.none()


def collaborators_for_user(user, queryset=None):
    queryset = queryset if queryset is not None else get_user_model().objects.filter(
        is_active=True, groups__name='Colaborador'
    )
    if not is_hr(user):
        return queryset
    department = user_department(user)
    return queryset.filter(department_profile__department=department) if department else queryset.none()


def individual_assignees_for_user(user):
    queryset = get_user_model().objects.filter(is_active=True).select_related(
        'department_profile__department'
    ).distinct().order_by('first_name', 'username')
    if is_council(user):
        return queryset.filter(groups__name='Gestor')
    return collaborators_for_user(
        user,
        queryset.filter(groups__name='Colaborador'),
    )


def can_receive_individual_objective(planner, assignee):
    expected_group = 'Gestor' if is_council(planner) else 'Colaborador'
    return assignee.groups.filter(name=expected_group).exists()


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


def get_current_cycle_monthly_progress(cycle, department=None):
    """Evolução mensal acumulada dos objetivos concluídos no ciclo atual."""
    if not cycle:
        return [], ''

    objectives_queryset = DepartmentObjective.objects.filter(
        institutional_objective__cycle=cycle
    )
    if department:
        objectives_queryset = objectives_queryset.filter(department=department)
    objectives = list(
        objectives_queryset.select_related('domain').only(
            'status', 'date_update', 'domain__type'
        )
    )
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
            objective.automatic_status == 'completed' and objective.date_update.date() <= reference_date
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


def get_institutional_cycle_monthly_progress(cycle):
    """Evolução mensal acumulada dos objetivos institucionais concluídos."""
    if not cycle:
        return [], ''

    objectives = list(InstitutionalObjective.objects.filter(
        cycle=cycle
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


def get_manager_monthly_progress(cycle, department):
    """Evolução mensal dos objetivos individuais do departamento do gestor."""
    if not cycle or not department:
        return [], ''

    objectives = list(IndividualObjective.objects.filter(
        department_objective__department=department,
        department_objective__institutional_objective__cycle=cycle,
    ).select_related('domain').only('status', 'date_update', 'domain__type'))
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
            objective.automatic_status == 'completed' and objective.date_update.date() <= reference_date
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
    """Permite gerir objetivos departamentais e individuais aos perfis autorizados."""
    @login_required
    def wrapped(request, *args, **kwargs):
        if not can_manage_operational_objectives(request.user):
            messages.error(request, 'Acesso apenas de consulta a estes objetivos.')
            return redirect('menu_home')
        return view(request, *args, **kwargs)
    return wrapped


def department_objective_write_required(view):
    """Permite gerir objetivos departamentais aos perfis autorizados."""
    @login_required
    def wrapped(request, *args, **kwargs):
        if not can_manage_department_objectives(request.user):
            messages.error(request, 'Acesso apenas de consulta aos objetivos departamentais.')
            return redirect('menu_home')
        return view(request, *args, **kwargs)
    return wrapped


@login_required
def menu_home(request):
    if not request.user.is_superuser and not request.user.groups.exists():
        return render(request, 'access/no_group.html', status=403)

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

        department_objective_list = list(department_objectives)
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
                objective.automatic_status == 'completed'
                for objective in objectives_for_collaborator
            )
            collaborator_progress.append({
                'user': collaborator,
                'total': total,
                'completed': completed,
                'percentage': round(completed * 100 / total) if total else 0,
            })
        department_progress_total = len(department_objective_list)
        department_progress_completed = sum(
            objective.automatic_status == 'completed'
            for objective in department_objective_list
        )
        department_progress_percentage = round(
            department_progress_completed * 100 / department_progress_total
        ) if department_progress_total else 0
        progress_total = len(individual_objective_list)
        progress_completed = sum(
            objective.automatic_status == 'completed'
            for objective in individual_objective_list
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
            'department_total': len(department_objective_list),
            'individual_total': len(individual_objective_list),
            'active_department_total': sum(item.automatic_status == 'active' for item in department_objective_list),
            'active_individual_total': sum(item.automatic_status == 'active' for item in individual_objective_list),
            'department_objectives': department_objective_list[:3],
            'department_progress_total': department_progress_total,
            'department_progress_completed': department_progress_completed,
            'department_progress_pending': department_progress_total - department_progress_completed,
            'department_progress_percentage': department_progress_percentage,
            'individual_objectives': individual_objective_list[:5],
            'manager_department': manager_department,
            'collaborator_progress': collaborator_progress,
            'progress_total': progress_total,
            'progress_completed': progress_completed,
            'progress_pending': progress_total - progress_completed,
            'progress_percentage': progress_percentage,
            'monthly_manager_progress': monthly_manager_progress,
            'monthly_manager_points': monthly_manager_points,
        })

    if is_hr(request.user):
        rh_department = user_department(request.user)
        cycles = Cycle.objects.all()
        active_cycle = next((cycle for cycle in cycles if cycle.automatic_status == 'active'), None)
        rh_department_objectives = list(
            department_objectives_for_user(
                request.user,
                DepartmentObjective.objects.select_related(
                    'institutional_objective__cycle', 'department', 'domain'
                ).order_by('-date_created'),
            )
        )
        rh_individual_objectives = list(
            individual_objectives_for_user(
                request.user,
                IndividualObjective.objects.select_related(
                    'department_objective', 'user', 'domain'
                ).order_by('-date_created'),
            )
        )
        rh_collaborators = list(collaborators_for_user(request.user).order_by('first_name', 'username'))
        collaborator_progress = []
        for collaborator in rh_collaborators:
            collaborator_objectives = [
                objective for objective in rh_individual_objectives
                if objective.user_id == collaborator.id
            ]
            collaborator_total = len(collaborator_objectives)
            collaborator_completed = sum(
                objective.automatic_status == 'completed'
                for objective in collaborator_objectives
            )
            collaborator_progress.append({
                'user': collaborator,
                'total': collaborator_total,
                'completed': collaborator_completed,
                'percentage': round(collaborator_completed * 100 / collaborator_total)
                if collaborator_total else 0,
            })
        institutional_objective_list = list(
            InstitutionalObjective.objects.select_related('cycle', 'domain')
            .order_by('-date_created')
        )
        institutional_dashboard_objectives = institutional_objective_list[:3]
        institutional_active_count = sum(
            item.automatic_status == 'active'
            for item in institutional_objective_list
        )
        institutional_completed_count = sum(
            item.automatic_status == 'completed'
            for item in institutional_objective_list
        )
        institutional_total = len(institutional_objective_list)
        department_total = len(rh_department_objectives)
        department_completed = sum(
            item.automatic_status == 'completed' for item in rh_department_objectives
        )
        individual_total = len(rh_individual_objectives)
        individual_completed = sum(
            item.automatic_status == 'completed' for item in rh_individual_objectives
        )
        monthly_manager_progress, monthly_manager_points = (
            get_manager_monthly_progress(active_cycle, rh_department)
            if active_cycle and rh_department else ([], '')
        )
        return render(request, 'rh/dashboard.html', {
            'active_cycle': active_cycle,
            'cycles_count': cycles.count(),
            'department_total': department_total,
            'department_completed': department_completed,
            'department_pending': department_total - department_completed,
            'department_completion_percentage': round(
                department_completed * 100 / department_total
            ) if department_total else 0,
            'institutional_count': InstitutionalObjective.objects.count(),
            'individual_count': individual_total,
            'individual_total': individual_total,
            'active_department_total': sum(
                item.automatic_status == 'active' for item in rh_department_objectives
            ),
            'active_individual_total': sum(
                item.automatic_status == 'active' for item in rh_individual_objectives
            ),
            'department_objectives': rh_department_objectives[:3],
            'department_progress_total': department_total,
            'department_progress_completed': department_completed,
            'department_progress_pending': department_total - department_completed,
            'department_progress_percentage': round(
                department_completed * 100 / department_total
            ) if department_total else 0,
            'collaborator_progress': collaborator_progress,
            'progress_total': individual_total,
            'progress_completed': individual_completed,
            'progress_pending': individual_total - individual_completed,
            'progress_percentage': round(
                individual_completed * 100 / individual_total
            ) if individual_total else 0,
            'institutional_dashboard_objectives': institutional_dashboard_objectives,
            'institutional_total': institutional_total,
            'institutional_active_count': institutional_active_count,
            'institutional_completed_count': institutional_completed_count,
            'institutional_active_percentage': round(
                institutional_completed_count * 100 / institutional_total
            ) if institutional_total else 0,
            'monthly_manager_progress': monthly_manager_progress,
            'monthly_manager_points': monthly_manager_points,
        })

    if is_collaborator(request.user):
        collaborator_department = user_department(request.user)
        tasks = IndividualObjective.objects.select_related(
            'department_objective__institutional_objective__cycle',
            'department_objective__department',
        ).prefetch_related('occurrence_records').filter(user=request.user).order_by('end_date', '-date_created')
        if collaborator_department:
            tasks = tasks.filter(department_objective__department=collaborator_department)
        else:
            tasks = tasks.none()
        task_list = list(tasks)
        pending_tasks = [task for task in task_list if task.automatic_status != 'completed']
        completed_tasks = [task for task in task_list if task.automatic_status == 'completed']
        task_filter = request.GET.get('status', 'all')
        if task_filter not in {'all', 'active', 'completed'}:
            task_filter = 'all'
        if task_filter == 'active':
            filtered_tasks = pending_tasks
        elif task_filter == 'completed':
            filtered_tasks = completed_tasks
        else:
            filtered_tasks = task_list
        return render(request, 'colaborador/dashboard.html', {
            'collaborator_department': collaborator_department,
            'tasks': filtered_tasks,
            'task_filter': task_filter,
            'pending_total': len(pending_tasks),
            'completed_total': len(completed_tasks),
            'task_total': len(task_list),
        })

    cycles = Cycle.objects.all()
    active_cycle = next((cycle for cycle in cycles if cycle.automatic_status == 'active'), None)
    institutional_objectives = list(
        InstitutionalObjective.objects.select_related('cycle', 'domain').order_by('-date_created')
    )
    institutional_active_count = sum(
        item.automatic_status == 'active' for item in institutional_objectives
    )
    institutional_completed_count = sum(
        item.automatic_status == 'completed' for item in institutional_objectives
    )
    institutional_total = institutional_active_count + institutional_completed_count
    department_objectives = list(
        DepartmentObjective.objects.select_related('institutional_objective', 'domain')
    )
    active_objectives_count = sum(
        item.automatic_status == 'active' for item in department_objectives
    )
    completed_objectives_count = sum(
        item.automatic_status == 'completed' for item in department_objectives
    )
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
    manager_tasks = list(
        IndividualObjective.objects.filter(user__groups__name='Gestor')
        .select_related('user', 'department_objective__department')
        .distinct()
        .order_by('-date_created')
    ) if is_council(request.user) else []
    manager_task_total = len(manager_tasks)
    manager_task_completed = sum(
        task.automatic_status == 'completed' for task in manager_tasks
    )
    manager_task_active = manager_task_total - manager_task_completed
    manager_task_percentage = round(
        manager_task_completed * 100 / manager_task_total
    ) if manager_task_total else 0
    manager_task_distribution = []
    manager_ids = {task.user_id for task in manager_tasks}
    for manager in get_user_model().objects.filter(id__in=manager_ids).order_by('first_name', 'username'):
        assigned_tasks = [task for task in manager_tasks if task.user_id == manager.id]
        total = len(assigned_tasks)
        completed = sum(task.automatic_status == 'completed' for task in assigned_tasks)
        manager_task_distribution.append({
            'manager': manager,
            'total': total,
            'completed': completed,
            'percentage': round(total * 100 / manager_task_total) if manager_task_total else 0,
        })
    monthly_completion_progress, monthly_completion_points = (
        get_institutional_cycle_monthly_progress(active_cycle)
        if is_council(request.user) else ([], '')
    )
    context = {
        'cycles_count': cycles.count(),
        'active_cycle': active_cycle,
        'institutional_count': InstitutionalObjective.objects.count(),
        'institutional_dashboard_objectives': institutional_objectives[:3],
        'institutional_active_count': institutional_active_count,
        'institutional_completed_count': institutional_completed_count,
        'institutional_total': institutional_total,
        'institutional_active_percentage': round(
            institutional_active_count * 100 / institutional_total
        ) if institutional_total else 0,
        'institutional_completed_percentage': round(
            institutional_completed_count * 100 / institutional_total
        ) if institutional_total else 0,
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
        'manager_task_distribution': manager_task_distribution,
        'manager_task_total': manager_task_total,
        'manager_task_active': manager_task_active,
        'manager_task_completed': manager_task_completed,
        'manager_task_percentage': manager_task_percentage,
        'monthly_completion_progress': monthly_completion_progress,
        'monthly_completion_points': monthly_completion_points,
    }
    return render(request, 'administracao/dashboard.html', context)


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
    template_name = 'administracao/dashboard_legacy.html' if is_council(request.user) else 'shared/dashboard_legacy.html'
    return render(request, template_name, context)


@login_required
def process_flow(request):
    return render(request, 'shared/process_flow.html', {'phases': PHASES})


@login_required
def planejamento_dashboard(request):
    cycles = Cycle.objects.all().order_by('-start_date')
    return render(request, 'shared/planejamento_dashboard.html', {'cycles': cycles})


@login_required
def planejamento_ciclo_detail(request, cycle_id):
    cycle = get_object_or_404(Cycle, pk=cycle_id)
    institucionais = InstitutionalObjective.objects.filter(cycle=cycle).order_by('-date_created')
    contexto = {
        'cycle': cycle,
        'institucionais': institucionais,
    }
    return render(request, 'shared/planejamento_ciclo_detail.html', contexto)


@login_required
def planejamento_ciclo_create(request):
    if request.method == 'POST' and not can_manage_cycles(request.user):
        messages.error(request, 'O seu perfil possui apenas acesso de consulta aos ciclos.')
        return redirect('planejamento_ciclo_create')
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
            domain=cycle_domain_for_type(1),
            status=request.POST.get('status', 'planned'),
        )
        messages.success(request, f'Ciclo {cycle} criado com sucesso.')
        return redirect('planejamento_ciclo_create')
    context = cycle_list_context(request)
    context.update({'editing': False, 'read_only': not can_manage_cycles(request.user)})
    return render(request, 'administracao/ciclo.html', context)


@login_required
def planejamento_ciclo_edit(request, cycle_id):
    if not can_manage_cycles(request.user):
        messages.error(request, 'O seu perfil possui apenas acesso de consulta aos ciclos.')
        return redirect('planejamento_ciclo_create')
    cycle = get_object_or_404(Cycle, pk=cycle_id)
    if not cycle.domain_id or cycle.domain.type != 1:
        messages.error(request, 'Apenas ciclos abertos podem ser editados.')
        return redirect('planejamento_ciclo_create')
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
    return render(request, 'administracao/ciclo.html', context)


@login_required
def planejamento_ciclo_delete(request, cycle_id):
    if not can_manage_cycles(request.user):
        messages.error(request, 'O seu perfil possui apenas acesso de consulta aos ciclos.')
        return redirect('planejamento_ciclo_create')
    cycle = get_object_or_404(Cycle, pk=cycle_id)
    if not cycle.domain_id or cycle.domain.type != 1:
        messages.error(request, 'Apenas ciclos abertos podem ser eliminados.')
        return redirect('planejamento_ciclo_create')
    if request.method == 'POST':
        cycle.delete()
        messages.success(request, 'Ciclo removido com sucesso.')
        return redirect('planejamento_ciclo_create')
    return redirect('planejamento_ciclo_detail', cycle_id=cycle.id)


@planning_required
def planejamento_ciclo_toggle_status(request, cycle_id):
    if not can_manage_cycles(request.user):
        messages.error(request, 'O seu perfil possui apenas acesso de consulta aos ciclos.')
        return redirect('planejamento_ciclo_create')
    cycle = get_object_or_404(Cycle.objects.select_related('domain'), pk=cycle_id)
    if request.method != 'POST':
        return redirect('planejamento_ciclo_create')

    target_type = request.POST.get('target_type')
    if target_type not in {'1', '2'}:
        messages.error(request, 'Selecione o novo estado do ciclo.')
        return redirect('planejamento_ciclo_create')
    target_type = int(target_type)
    current_type = 1 if cycle.is_open else 2
    if target_type == current_type:
        messages.info(request, 'O ciclo já se encontra nesse estado.')
        return redirect('planejamento_ciclo_create')
    cycle.domain = cycle_domain_for_type(target_type)
    cycle.status = 'closed' if target_type == 2 else 'active'
    cycle.save(update_fields=['domain', 'status'])
    action = 'concluído' if target_type == 2 else 'reaberto'
    messages.success(request, f'Ciclo {action} com sucesso.')
    return redirect('planejamento_ciclo_create')


@login_required
def planejamento_objetivo_institucional_menu(request):
    cycles = list(Cycle.objects.all().order_by('-start_date', '-year'))
    current_cycle = next((cycle for cycle in cycles if cycle.automatic_status == 'active'), None)
    if current_cycle:
        cycles.remove(current_cycle)
        cycles.insert(0, current_cycle)
    read_only = not can_manage_institutional_objectives(request.user)
    if request.method == 'POST' and read_only:
        messages.error(request, 'O grupo Administração possui apenas acesso de consulta aos objetivos institucionais.')
        return redirect('planejamento_objetivo_institucional_menu')
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
    objetivos = InstitutionalObjective.objects.select_related('cycle', 'domain').order_by('-date_created')
    if selected_year.isdigit() and int(selected_year) in years:
        objetivos = objetivos.filter(cycle__year=int(selected_year))
    else:
        selected_year = ''
    return render(request, 'administracao/objetivo_institucional.html', {
        'objetivos': objetivos,
        'cycles': cycles,
        'current_cycle': current_cycle,
        'years': years,
        'selected_year': selected_year,
        'read_only': read_only,
    })


@login_required
def planejamento_objetivo_institucional_create(request, cycle_id):
    if not can_manage_institutional_objectives(request.user):
        messages.error(request, 'O grupo Administração possui apenas acesso de consulta aos objetivos institucionais.')
        return redirect('planejamento_objetivo_institucional_menu')
    cycle = get_object_or_404(Cycle, pk=cycle_id)
    if request.method == 'POST':
        description = request.POST.get('description', '').strip()
        if not description:
            messages.error(request, 'Descreva o objetivo institucional.')
            return redirect('planejamento_ciclo_detail', cycle_id=cycle.id)
        InstitutionalObjective.objects.create(cycle=cycle, description=description, status=request.POST.get('status', 'draft'))
        messages.success(request, 'Objetivo institucional criado.')
        return redirect('planejamento_ciclo_detail', cycle_id=cycle.id)
    return render(request, 'shared/planejamento_objetivo_form.html', {'cycle': cycle, 'kind': 'institucional', 'editing': False})


@login_required
def planejamento_objetivo_departamental_menu(request):
    institucionais = InstitutionalObjective.objects.select_related('cycle').order_by('-date_created')
    institucional = institucionais.filter(
        cycle__start_date__lte=timezone.localdate(),
        cycle__end_date__gte=timezone.localdate(),
    ).first()
    if request.method == 'POST' and not can_manage_department_objectives(request.user):
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
    objective_list = list(department_objectives_for_user(
        request.user,
        DepartmentObjective.objects.select_related(
            'institutional_objective__cycle', 'department', 'domain',
        ).prefetch_related('approval_history__domain').order_by('-date_created'),
    ))
    department_total = len(objective_list)
    department_completed_total = sum(
        objective.automatic_status == 'completed' for objective in objective_list
    )
    department_active_total = department_total - department_completed_total
    department_filter = request.GET.get('status', 'all') if is_manager(request.user) else 'all'
    if department_filter not in {'all', 'active', 'completed'}:
        department_filter = 'all'
    if department_filter == 'active':
        objetivos = [
            objective for objective in objective_list
            if objective.automatic_status != 'completed'
        ]
    elif department_filter == 'completed':
        objetivos = [
            objective for objective in objective_list
            if objective.automatic_status == 'completed'
        ]
    else:
        objetivos = objective_list
    return render(request, 'shared/objetivo_departamental.html', {
        'objetivos': objetivos,
        'department_filter': department_filter,
        'department_total': department_total,
        'department_active_total': department_active_total,
        'department_completed_total': department_completed_total,
        'institucional': institucional,
        'institucionais': institucionais,
        'read_only': not can_manage_department_objectives(request.user),
    })


@login_required
def planejamento_objetivo_institucional_edit(request, objetivo_id):
    if not can_manage_institutional_objectives(request.user):
        messages.error(request, 'O grupo Administração possui apenas acesso de consulta aos objetivos institucionais.')
        return redirect('planejamento_objetivo_institucional_menu')
    objetivo = get_object_or_404(InstitutionalObjective, pk=objetivo_id)
    if not objetivo.domain_id or objetivo.domain.type != 1:
        messages.error(request, 'Apenas objetivos abertos podem ser editados.')
        return redirect('planejamento_objetivo_institucional_menu')
    if request.method == 'POST':
        objetivo.description = request.POST.get('description', objetivo.description).strip()
        objetivo.status = request.POST.get('status', objetivo.status)
        objetivo.save()
        messages.success(request, 'Objetivo institucional atualizado.')
        if request.POST.get('next') == 'objective_menu':
            return redirect('planejamento_objetivo_institucional_menu')
        return redirect('planejamento_ciclo_detail', cycle_id=objetivo.cycle_id)
    return render(request, 'shared/planejamento_objetivo_form.html', {'cycle': objetivo.cycle, 'objetivo': objetivo, 'kind': 'institucional', 'editing': True})


@login_required
def planejamento_objetivo_institucional_delete(request, objetivo_id):
    if not can_manage_institutional_objectives(request.user):
        messages.error(request, 'O grupo Administração possui apenas acesso de consulta aos objetivos institucionais.')
        return redirect('planejamento_objetivo_institucional_menu')
    objetivo = get_object_or_404(InstitutionalObjective, pk=objetivo_id)
    if not objetivo.domain_id or objetivo.domain.type != 1:
        messages.error(request, 'Apenas objetivos abertos podem ser eliminados.')
        return redirect('planejamento_objetivo_institucional_menu')
    if request.method == 'POST':
        cycle_id = objetivo.cycle_id
        objetivo.delete()
        messages.success(request, 'Objetivo institucional removido.')
        if request.POST.get('next') == 'objective_menu':
            return redirect('planejamento_objetivo_institucional_menu')
        return redirect('planejamento_ciclo_detail', cycle_id=cycle_id)
    return redirect('planejamento_ciclo_detail', cycle_id=objetivo.cycle_id)


@login_required
def planejamento_objetivo_institucional_toggle_status(request, objetivo_id):
    if not can_manage_institutional_objectives(request.user):
        messages.error(request, 'O grupo Administração possui apenas acesso de consulta aos objetivos institucionais.')
        return redirect('planejamento_objetivo_institucional_menu')
    objetivo = get_object_or_404(
        InstitutionalObjective.objects.select_related('domain'), pk=objetivo_id
    )
    if request.method != 'POST':
        return redirect('planejamento_objetivo_institucional_menu')

    target_type = request.POST.get('target_type')
    if target_type not in {'1', '2'}:
        messages.error(request, 'Selecione o novo estado do objetivo.')
        return redirect('planejamento_objetivo_institucional_menu')
    target_type = int(target_type)
    current_type = 1 if objetivo.is_open else 2
    if target_type == current_type:
        messages.info(request, 'O objetivo já se encontra nesse estado.')
        return redirect('planejamento_objetivo_institucional_menu')

    objetivo.domain = cycle_domain_for_type(target_type)
    objetivo.status = 'completed' if target_type == 2 else 'active'
    objetivo.save(update_fields=['domain', 'status', 'date_update'])
    action = 'concluído' if target_type == 2 else 'reaberto'
    messages.success(request, f'Objetivo institucional {action} com sucesso.')
    return redirect('planejamento_objetivo_institucional_menu')


@department_objective_write_required
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
    return render(request, 'shared/planejamento_objetivo_form.html', {'cycle': institucional.cycle, 'kind': 'departamental', 'parent': institucional, 'editing': False})


@department_objective_write_required
def planejamento_objetivo_departamental_edit(request, objetivo_id):
    objetivo = get_object_or_404(
        department_objectives_for_user(request.user).select_related('domain').prefetch_related(
            'approval_history__domain'
        ),
        pk=objetivo_id,
    )
    if not objetivo.can_be_edited:
        messages.error(request, 'Apenas objetivos em andamento ou rejeitados podem ser editados.')
        return redirect('planejamento_objetivo_departamental_menu')
    if request.method == 'POST':
        was_rejected = objetivo.approval_status == 'rejected'
        objetivo.description = request.POST.get('description', objetivo.description).strip()
        institutional_objective_id = request.POST.get('institutional_objective')
        if institutional_objective_id:
            objetivo.institutional_objective = get_object_or_404(InstitutionalObjective, pk=institutional_objective_id)
        objetivo.status = request.POST.get('status', objetivo.status)
        objetivo.save()
        if was_rejected:
            AprovacaoTarefa.objects.create(
                department_objective=objetivo,
                domain=None,
                obs='',
            )
            messages.success(request, 'Objetivo atualizado e reenviado para aprovação.')
        else:
            messages.success(request, 'Objetivo departamental atualizado.')
        if request.POST.get('next') == 'department_menu':
            return redirect('planejamento_objetivo_departamental_menu')
        return redirect('planejamento_ciclo_detail', cycle_id=objetivo.institutional_objective.cycle_id)
    return render(request, 'shared/planejamento_objetivo_form.html', {'cycle': objetivo.institutional_objective.cycle, 'objetivo': objetivo, 'kind': 'departamental', 'parent': objetivo.institutional_objective, 'editing': True})


@department_objective_write_required
def planejamento_objetivo_departamental_delete(request, objetivo_id):
    objetivo = get_object_or_404(
        department_objectives_for_user(request.user), pk=objetivo_id
    )
    if not objetivo.domain_id or objetivo.domain.type != 1:
        messages.error(request, 'Apenas objetivos abertos podem ser eliminados.')
        return redirect('planejamento_objetivo_departamental_menu')
    if request.method == 'POST':
        cycle_id = objetivo.institutional_objective.cycle_id
        objetivo.delete()
        messages.success(request, 'Objetivo departamental removido.')
        if request.POST.get('next') == 'department_menu':
            return redirect('planejamento_objetivo_departamental_menu')
        return redirect('planejamento_ciclo_detail', cycle_id=cycle_id)
    return redirect('planejamento_ciclo_detail', cycle_id=objetivo.institutional_objective.cycle_id)


@department_objective_write_required
def planejamento_objetivo_departamental_toggle_status(request, objetivo_id):
    objetivo = get_object_or_404(
        department_objectives_for_user(
            request.user,
            DepartmentObjective.objects.select_related('domain'),
        ),
        pk=objetivo_id,
    )
    if request.method != 'POST':
        return redirect('planejamento_objetivo_departamental_menu')

    target_type = request.POST.get('target_type')
    if target_type not in {'1', '2'}:
        messages.error(request, 'Selecione o novo estado do objetivo.')
        return redirect('planejamento_objetivo_departamental_menu')
    target_type = int(target_type)
    if target_type == 2 and not objetivo.is_approved:
        messages.error(request, 'O objetivo precisa ser aprovado antes de ser concluído.')
        return redirect('planejamento_objetivo_departamental_menu')
    current_type = 1 if objetivo.is_open else 2
    if target_type == current_type:
        messages.info(request, 'O objetivo já se encontra nesse estado.')
        return redirect('planejamento_objetivo_departamental_menu')

    objetivo.domain = cycle_domain_for_type(target_type)
    objetivo.status = 'completed' if target_type == 2 else 'active'
    objetivo.save(update_fields=['domain', 'status', 'date_update'])
    action = 'concluído' if target_type == 2 else 'reaberto'
    messages.success(request, f'Objetivo departamental {action} com sucesso.')
    return redirect('planejamento_objetivo_departamental_menu')


@login_required
def planejamento_objetivo_departamental_aprovacao(request, objetivo_id):
    if not is_council(request.user):
        messages.error(request, 'Apenas o Conselho de Administração pode aprovar tarefas departamentais.')
        return redirect('planejamento_objetivo_departamental_menu')
    if request.method != 'POST':
        return redirect('planejamento_objetivo_departamental_menu')

    objetivo = get_object_or_404(
        DepartmentObjective.objects.prefetch_related('approval_history__domain'),
        pk=objetivo_id,
    )
    decision = request.POST.get('decision')
    if decision not in {'approve', 'reject'}:
        messages.error(request, 'Selecione Aprovar ou Rejeitar.')
        return redirect('planejamento_objetivo_departamental_menu')

    approval_status = objetivo.approval_status
    can_decide = (
        approval_status == 'pending_approval'
        or (approval_status == 'rejected' and decision == 'approve')
    )
    if not can_decide:
        messages.error(
            request,
            'Só é possível decidir objetivos por aprovar ou aprovar um objetivo rejeitado.',
        )
        return redirect('planejamento_objetivo_departamental_menu')

    approved = decision == 'approve'
    approval_description = 'Aprovado' if approved else 'Rejeitado'
    approval_domain = Domain.objects.filter(
        domain_description__iexact='pendente_aprovacao',
        description__iexact=approval_description,
    ).first()
    if not approval_domain:
        messages.error(
            request,
            f'O domínio de aprovação “{approval_description}” não está configurado.',
        )
        return redirect('planejamento_objetivo_departamental_menu')

    obs = request.POST.get('obs', '').strip()
    if not approved and not obs:
        messages.error(request, 'Indique o motivo da rejeição.')
        return redirect('planejamento_objetivo_departamental_menu')

    AprovacaoTarefa.objects.create(
        department_objective=objetivo,
        domain=approval_domain,
        obs=obs,
    )

    messages.success(
        request,
        'Objetivo departamental aprovado.' if approved else 'Objetivo departamental rejeitado.',
    )
    return redirect('planejamento_objetivo_departamental_menu')


@objective_write_required
def planejamento_objetivo_individual_create(request, objetivo_id):
    departamental = get_object_or_404(
        department_objectives_for_user(
            request.user,
            DepartmentObjective.objects.prefetch_related('approval_history__domain'),
        ),
        pk=objetivo_id,
    )
    if not departamental.is_approved:
        messages.error(
            request,
            'O objetivo departamental precisa ser aprovado antes de receber tarefas individuais.',
        )
        return redirect('planejamento_objetivo_individual_menu')
    if request.method == 'POST':
        description = request.POST.get('description', '').strip()
        if not description:
            messages.error(request, 'Descreva o objetivo individual.')
            return redirect('planejamento_ciclo_detail', cycle_id=departamental.institutional_objective.cycle_id)
        start_date, end_date, date_error = individual_objective_dates(request)
        if date_error:
            messages.error(request, date_error)
            return redirect('planejamento_ciclo_detail', cycle_id=departamental.institutional_objective.cycle_id)
        user_id = request.POST.get('user')
        if not user_id:
            messages.error(request, 'Selecione o utilizador.')
            return redirect('planejamento_ciclo_detail', cycle_id=departamental.institutional_objective.cycle_id)
        user = get_object_or_404(get_user_model(), pk=user_id, is_active=True)
        department = objective_department_for_request(request, departamental)
        if not can_receive_individual_objective(request.user, user) or not department or user_department(user) != department:
            messages.error(request, 'Selecione um responsável autorizado do mesmo departamento do objetivo.')
            return redirect('planejamento_ciclo_detail', cycle_id=departamental.institutional_objective.cycle_id)
        IndividualObjective.objects.create(
            department_objective=departamental,
            user=user,
            description=description,
            start_date=start_date,
            end_date=end_date,
            status=request.POST.get('status', 'draft'),
        )
        messages.success(request, 'Objetivo individual criado.')
        return redirect('planejamento_ciclo_detail', cycle_id=departamental.institutional_objective.cycle_id)
    users = individual_assignees_for_user(request.user)
    return render(request, 'shared/planejamento_objetivo_form.html', {'cycle': departamental.institutional_objective.cycle, 'kind': 'individual', 'parent': departamental, 'users': users, 'assignee_label': 'Gestor' if is_council(request.user) else 'Utilizador', 'editing': False})


@login_required
def planejamento_objetivo_individual_menu(request):
    departamentos = approved_department_objectives_for_user(
        request.user,
        DepartmentObjective.objects.select_related(
            'institutional_objective__cycle', 'department',
        ).prefetch_related('approval_history__domain').order_by('-date_created'),
    )
    users = individual_assignees_for_user(request.user)
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
        start_date, end_date, date_error = individual_objective_dates(request)
        if date_error:
            messages.error(request, date_error)
            return redirect('planejamento_objetivo_individual_menu')
        if not department_id or not user_id:
            messages.error(request, 'Selecione o objetivo departamental e o utilizador.')
            return redirect('planejamento_objetivo_individual_menu')
        department = get_object_or_404(departamentos, pk=department_id)
        if not department.is_approved:
            messages.error(request, 'Selecione um objetivo departamental aprovado.')
            return redirect('planejamento_objetivo_individual_menu')
        user = get_object_or_404(users, pk=user_id)
        objective_department = objective_department_for_request(request, department)
        if not can_receive_individual_objective(request.user, user) or not objective_department or user_department(user) != objective_department:
            messages.error(request, 'Selecione um responsável autorizado do mesmo departamento do objetivo.')
            return redirect('planejamento_objetivo_individual_menu')
        IndividualObjective.objects.create(
            department_objective=department,
            user=user,
            description=description,
            start_date=start_date,
            end_date=end_date,
            status='active',
        )
        messages.success(request, 'Objetivo individual criado.')
        return redirect('planejamento_objetivo_individual_menu')
    objective_list = list(individual_objectives_for_user(
        request.user,
        IndividualObjective.objects.select_related(
            'department_objective__institutional_objective__cycle',
            'department_objective__department',
            'user',
        ).prefetch_related('occurrence_records').order_by('-date_created'),
    ))
    individual_total = len(objective_list)
    individual_completed_total = sum(
        objective.automatic_status == 'completed' for objective in objective_list
    )
    individual_active_total = individual_total - individual_completed_total
    individual_filter = request.GET.get('status', 'all') if is_manager(request.user) else 'all'
    if individual_filter not in {'all', 'active', 'completed'}:
        individual_filter = 'all'
    if individual_filter == 'active':
        objetivos = [
            objective for objective in objective_list
            if objective.automatic_status != 'completed'
        ]
    elif individual_filter == 'completed':
        objetivos = [
            objective for objective in objective_list
            if objective.automatic_status == 'completed'
        ]
    else:
        objetivos = objective_list
    return render(request, 'shared/objetivo_individual.html', {
        'objetivos': objetivos,
        'individual_filter': individual_filter,
        'individual_total': individual_total,
        'individual_active_total': individual_active_total,
        'individual_completed_total': individual_completed_total,
        'departamentos': departamentos,
        'users': users,
        'assignee_label': 'Gestor' if is_council(request.user) else 'Responsável',
        'departamento_ativo': departamento_ativo,
        'read_only': not can_manage_operational_objectives(request.user),
    })


@objective_write_required
def planejamento_objetivo_individual_edit(request, objetivo_id):
    objetivo = get_object_or_404(
        individual_objectives_for_user(request.user), pk=objetivo_id
    )
    if request.method == 'POST':
        objetivo.description = request.POST.get('description', objetivo.description).strip()
        start_date, end_date, date_error = individual_objective_dates(request)
        if date_error:
            messages.error(request, date_error)
            if request.POST.get('next') == 'individual_menu':
                return redirect('planejamento_objetivo_individual_menu')
            return redirect('planejamento_ciclo_detail', cycle_id=objetivo.department_objective.institutional_objective.cycle_id)
        objetivo.start_date = start_date
        objetivo.end_date = end_date
        department_id = request.POST.get('department_objective')
        if department_id:
            objetivo.department_objective = get_object_or_404(
                approved_department_objectives_for_user(request.user),
                pk=department_id,
            )
        if request.POST.get('user'):
            user = get_object_or_404(
                individual_assignees_for_user(request.user), pk=request.POST.get('user')
            )
            objective_department = objective_department_for_request(request, objetivo.department_objective)
            if not can_receive_individual_objective(request.user, user) or not objective_department or user_department(user) != objective_department:
                messages.error(request, 'Selecione um responsável autorizado do mesmo departamento do objetivo.')
                return redirect('planejamento_objetivo_individual_menu')
            objetivo.user = user
        objetivo.save()
        messages.success(request, 'Objetivo individual atualizado.')
        if request.POST.get('next') == 'individual_menu':
            return redirect('planejamento_objetivo_individual_menu')
        return redirect('planejamento_ciclo_detail', cycle_id=objetivo.department_objective.institutional_objective.cycle_id)
    users = individual_assignees_for_user(request.user)
    return render(request, 'shared/planejamento_objetivo_form.html', {'cycle': objetivo.department_objective.institutional_objective.cycle, 'objetivo': objetivo, 'kind': 'individual', 'parent': objetivo.department_objective, 'users': users, 'assignee_label': 'Gestor' if is_council(request.user) else 'Utilizador', 'editing': True})


@objective_write_required
def planejamento_objetivo_individual_delete(request, objetivo_id):
    objetivo = get_object_or_404(
        individual_objectives_for_user(request.user), pk=objetivo_id
    )
    if request.method == 'POST':
        cycle_id = objetivo.department_objective.institutional_objective.cycle_id
        objetivo.delete()
        messages.success(request, 'Objetivo individual removido.')
        if request.POST.get('next') == 'individual_menu':
            return redirect('planejamento_objetivo_individual_menu')
        return redirect('planejamento_ciclo_detail', cycle_id=cycle_id)
    return redirect('planejamento_ciclo_detail', cycle_id=objetivo.department_objective.institutional_objective.cycle_id)


@login_required
def colaborador_tarefa_atualizar(request, objetivo_id):
    if not is_collaborator(request.user):
        messages.error(request, 'Apenas colaboradores podem atualizar as tarefas atribuídas.')
        return redirect('menu_home')
    if request.method != 'POST':
        return redirect('menu_home')

    department = user_department(request.user)
    tasks = IndividualObjective.objects.select_related(
        'department_objective__institutional_objective__cycle',
        'department_objective__department',
    ).filter(user=request.user)
    if department:
        tasks = tasks.filter(department_objective__department=department)
    else:
        tasks = tasks.none()
    task = get_object_or_404(tasks, pk=objetivo_id)

    if task.department_objective.institutional_objective.cycle.automatic_status == 'closed':
        messages.error(request, 'Não é possível atualizar uma tarefa de um ciclo encerrado.')
        return redirect('menu_home')

    action = request.POST.get('action')
    if action == 'start' and task.status == 'draft':
        task.status = 'active'
        task.save(update_fields=['status', 'date_update'])
        messages.success(request, 'Tarefa iniciada com sucesso.')
    elif action == 'complete' and task.status != 'completed':
        task.status = 'completed'
        task.save(update_fields=['status', 'date_update'])
        messages.success(request, 'Tarefa concluída com sucesso.')
    else:
        messages.error(request, 'A tarefa já foi atualizada ou a ação não é válida.')
    return redirect('menu_home')


@login_required
def colaborador_ocorrencia_criar(request, objetivo_id):
    if not is_collaborator(request.user):
        messages.error(request, 'Apenas colaboradores podem registar ocorrências nas suas tarefas.')
        return redirect('menu_home')
    if request.method != 'POST':
        return redirect('menu_home')

    department = user_department(request.user)
    tasks = IndividualObjective.objects.select_related(
        'department_objective__institutional_objective__cycle',
        'department_objective__department',
    ).filter(user=request.user)
    if department:
        tasks = tasks.filter(department_objective__department=department)
    else:
        tasks = tasks.none()
    task = get_object_or_404(tasks, pk=objetivo_id)

    if not task.can_register_occurrence:
        messages.error(
            request,
            'Só é possível registar ocorrências em tarefas em andamento e dentro do prazo definido.',
        )
        return redirect(f'{reverse("menu_home")}?status=active')

    description = request.POST.get('description', '').strip()
    if not description:
        messages.error(request, 'Descreva a ocorrência antes de guardar.')
    elif len(description) > 200:
        messages.error(request, 'A ocorrência não pode ultrapassar 200 caracteres.')
    else:
        RegistoOcorrencia.objects.create(
            individual_objective=task,
            description=description,
        )
        messages.success(request, 'Ocorrência registada com sucesso.')
    return redirect(f'{reverse("menu_home")}?status=active')


@login_required
def gestor_minhas_tarefas(request):
    if not is_manager(request.user):
        messages.error(request, 'Esta área está disponível apenas para o grupo Gestor.')
        return redirect('menu_home')

    department = user_department(request.user)
    tasks = IndividualObjective.objects.select_related(
        'department_objective__institutional_objective__cycle',
        'department_objective__department',
    ).prefetch_related('occurrence_records').filter(user=request.user)
    if department:
        tasks = tasks.filter(department_objective__department=department)
    else:
        tasks = tasks.none()
    task_list = list(tasks.order_by('end_date', '-date_created'))
    active_tasks = [task for task in task_list if task.automatic_status != 'completed']
    completed_tasks = [task for task in task_list if task.automatic_status == 'completed']
    task_filter = request.GET.get('status', 'all')
    if task_filter not in {'all', 'active', 'completed'}:
        task_filter = 'all'
    if task_filter == 'active':
        filtered_tasks = active_tasks
    elif task_filter == 'completed':
        filtered_tasks = completed_tasks
    else:
        filtered_tasks = task_list
    return render(request, 'gestor/tarefas.html', {
        'tasks': filtered_tasks,
        'task_filter': task_filter,
        'task_total': len(task_list),
        'active_total': len(active_tasks),
        'completed_total': len(completed_tasks),
        'manager_department': department,
    })


@login_required
def gestor_ocorrencia_criar(request, objetivo_id):
    if not is_manager(request.user):
        messages.error(request, 'Apenas o Gestor responsável pode registar ocorrências nesta tarefa.')
        return redirect('menu_home')
    if request.method != 'POST':
        return redirect('gestor_minhas_tarefas')

    department = user_department(request.user)
    tasks = IndividualObjective.objects.select_related(
        'department_objective__institutional_objective__cycle',
        'department_objective__department',
    ).filter(user=request.user)
    if department:
        tasks = tasks.filter(department_objective__department=department)
    else:
        tasks = tasks.none()
    task = get_object_or_404(tasks, pk=objetivo_id)

    if not task.can_register_occurrence:
        messages.error(
            request,
            'Só é possível registar ocorrências em tarefas em andamento e dentro do prazo definido.',
        )
        return redirect(f'{reverse("gestor_minhas_tarefas")}?status=active')

    description = request.POST.get('description', '').strip()
    if not description:
        messages.error(request, 'Descreva a ocorrência antes de guardar.')
    elif len(description) > 200:
        messages.error(request, 'A ocorrência não pode ultrapassar 200 caracteres.')
    else:
        RegistoOcorrencia.objects.create(
            individual_objective=task,
            description=description,
        )
        messages.success(request, 'Ocorrência registada com sucesso.')
    return redirect(f'{reverse("gestor_minhas_tarefas")}?status=active')


@login_required
def gestor_tarefa_concluir(request, objetivo_id):
    if not is_manager(request.user):
        messages.error(request, 'Apenas o Gestor responsável pode concluir esta tarefa.')
        return redirect('menu_home')
    if request.method != 'POST':
        return redirect('gestor_minhas_tarefas')

    department = user_department(request.user)
    tasks = IndividualObjective.objects.select_related(
        'department_objective__institutional_objective__cycle',
        'department_objective__department',
    ).filter(user=request.user)
    if department:
        tasks = tasks.filter(department_objective__department=department)
    else:
        tasks = tasks.none()
    task = get_object_or_404(tasks, pk=objetivo_id)

    if task.department_objective.institutional_objective.cycle.automatic_status == 'closed':
        messages.error(request, 'Não é possível concluir uma tarefa de um ciclo encerrado.')
    elif task.status == 'completed':
        messages.error(request, 'Esta tarefa já se encontra concluída.')
    else:
        task.status = 'completed'
        task.save(update_fields=['status', 'date_update'])
        messages.success(request, 'Tarefa concluída com sucesso.')
    return redirect(f'{reverse("gestor_minhas_tarefas")}?status=active')


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
    template_name = 'administracao/cycle_create.html' if is_council(request.user) else 'shared/cycle_create.html'
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
    return render(request, 'shared/cycle_form.html', {'cycle': cycle, 'editing': True})


@planning_required
def cycle_delete(request, cycle_id):
    cycle = get_object_or_404(Cycle, pk=cycle_id)
    if request.method == 'POST':
        cycle.delete()
        messages.success(request, 'Ciclo removido com sucesso.')
        return redirect('menu_home')
    return render(request, 'shared/confirm_delete.html', {'object': cycle, 'object_type': 'ciclo', 'cancel_url': 'cycle_detail', 'cancel_id': cycle.id})


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
    return render(request, 'shared/cycle_detail.html', {'cycle': cycle, 'evaluations': evaluations, 'objectives': objectives, 'follow_ups': follow_ups, 'validations': validations, 'phases': PHASES, 'can_manage': is_management(request.user), 'can_plan': can_plan(request.user)})


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
    template_name = 'administracao/objective_form.html' if is_council(request.user) else 'shared/objective_form.html'
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
    return render(request, 'shared/follow_up_form.html', {'cycle': cycle, 'users': users, 'can_manage': is_management(request.user)})


@management_required
def validation_create(request, cycle_id):
    cycle = get_object_or_404(Cycle, pk=cycle_id)
    evaluations = cycle.evaluations.select_related('employee')
    users = get_user_model().objects.filter(is_active=True).order_by('first_name', 'username')
    if request.method == 'POST':
        Validation.objects.create(cycle=cycle, evaluation_id=request.POST.get('evaluation'), validator_id=request.POST.get('validator') or request.user.id, role=request.POST.get('role', 'manager'), status='pending')
        messages.success(request, 'Validação adicionada ao fluxo.')
        return redirect('cycle_detail', cycle_id=cycle.id)
    return render(request, 'shared/validation_form.html', {'cycle': cycle, 'evaluations': evaluations, 'users': users})


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
    return render(request, 'shared/evaluation_detail.html', {'evaluation': evaluation, 'can_manage': is_management(request.user)})


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
    return render(request, 'shared/evaluation_form.html', {'cycle': cycle, 'users': users, 'editing': False})


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
    return render(request, 'shared/evaluation_edit.html', {'evaluation': evaluation, 'can_manage': is_management(request.user)})


@management_required
def evaluation_delete(request, evaluation_id):
    evaluation = get_object_or_404(Evaluation, pk=evaluation_id)
    if request.method == 'POST':
        cycle_id = evaluation.cycle_id
        evaluation.delete()
        messages.success(request, 'Avaliação removida com sucesso.')
        return redirect('cycle_detail', cycle_id=cycle_id)
    return render(request, 'shared/confirm_delete.html', {'object': evaluation, 'object_type': 'avaliação', 'cancel_url': 'evaluation_detail', 'cancel_id': evaluation.id})
