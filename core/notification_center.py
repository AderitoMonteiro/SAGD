"""Agregadores de notificações exibidas no cabeçalho do sistema.

Cada produtor devolve itens no mesmo formato. Para adicionar um novo tipo de
alerta (prazo, tarefa, ciclo, etc.), basta criar outro produtor e acrescentá-lo
a ``administration_notifications``.
"""

from django.urls import reverse

from .models import DepartmentObjective


def _pending_department_approvals():
    candidates = DepartmentObjective.objects.select_related(
        'department',
        'institutional_objective__cycle',
    ).prefetch_related('approval_history__domain').order_by('-date_created')

    return [
        {
            'key': f'department-approval-{objective.pk}',
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
    return sorted(
        notifications,
        key=lambda item: item.get('created_at'),
        reverse=True,
    )
