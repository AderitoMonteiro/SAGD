"""Agregadores de notificações exibidas no cabeçalho do sistema.

Cada produtor devolve itens no mesmo formato. Para adicionar um novo tipo de
alerta (prazo, tarefa, ciclo, etc.), basta criar outro produtor e acrescentá-lo
a ``administration_notifications``.
"""

from django.urls import reverse

from .models import DepartmentObjective, SystemNotificationRead, UserDepartment


def _only_unread(user, notifications):
    read_keys = set(
        SystemNotificationRead.objects.filter(user=user).values_list(
            'notification_key', flat=True
        )
    )
    return [item for item in notifications if item['key'] not in read_keys]


def _pending_department_approvals():
    candidates = DepartmentObjective.objects.select_related(
        'department',
        'institutional_objective__cycle',
    ).prefetch_related('approval_history__domain').order_by('-date_created')

    return [
        {
            'key': (
                f'department-approval-{objective.pk}-'
                f'{objective.latest_approval.pk if objective.latest_approval else "new"}'
            ),
            'category': 'approval',
            'icon': '!',
            'title': 'Objetivo por aprovar',
            'message': (
                f'{objective.department.name if objective.department else "Sem departamento"}'
                f' · {objective.description}'
            ),
            'url': reverse('planejamento_objetivo_departamental_menu'),
            'created_at': objective.date_created,
        }
        for objective in candidates
        if objective.approval_status == 'pending_approval'
    ]


def administration_notifications(user):
    """Reúne todos os alertas destinados ao perfil Administração."""
    if not user.is_authenticated:
        return []

    notifications = []
    notifications.extend(_pending_department_approvals())

    # Produtores futuros devem ser acrescentados aqui, por exemplo:
    # notifications.extend(_cycle_deadline_notifications())
    # notifications.extend(_overdue_task_notifications())
    return _only_unread(user, sorted(
        notifications,
        key=lambda item: item.get('created_at'),
        reverse=True,
    ))


def department_notifications(user):
    """Informa Gestor/RH sobre decisões dos objetivos do seu departamento."""
    profile = UserDepartment.objects.select_related('department').filter(user=user).first()
    if not profile or not profile.department_id:
        return []

    objectives = DepartmentObjective.objects.filter(
        department_id=profile.department_id,
    ).select_related(
        'department',
        'institutional_objective__cycle',
    ).prefetch_related('approval_history__domain').order_by('-date_update')

    notifications = []
    for objective in objectives:
        status = objective.approval_status
        if status not in {'approved', 'rejected'}:
            continue

        approval = objective.latest_approval
        approved = status == 'approved'
        notifications.append({
            'key': f'department-decision-{objective.pk}-{approval.pk}',
            'category': 'approval-approved' if approved else 'approval-rejected',
            'icon': '✓' if approved else '×',
            'title': 'Objetivo aprovado' if approved else 'Objetivo rejeitado',
            'message': objective.description,
            'url': reverse('planejamento_objetivo_departamental_menu'),
            'created_at': approval.date_created,
        })

    return _only_unread(user, sorted(
        notifications,
        key=lambda item: item.get('created_at'),
        reverse=True,
    ))
