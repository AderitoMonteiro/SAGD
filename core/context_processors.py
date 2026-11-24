def navigation_permissions(request):
    user = request.user
    is_council_user = (
        user.is_authenticated
        and (user.is_superuser or user.groups.filter(name='Conselho de Administração').exists())
    )
    is_manager_user = (
        user.is_authenticated
        and not is_council_user
        and user.groups.filter(name='Gestor').exists()
    )
    is_hr_user = (
        user.is_authenticated
        and not user.is_superuser
        and user.groups.filter(name='RH').exists()
    )
    is_collaborator_user = (
        user.is_authenticated
        and not user.is_superuser
        and user.groups.filter(name='Colaborador').exists()
    )
    is_admin_user = (
        user.is_authenticated
        and (user.is_superuser or user.groups.filter(name='Administrador').exists())
    )
    has_no_group_user = user.is_authenticated and not user.is_superuser and not user.groups.exists()
    system_notifications = []
    if is_council_user:
        from .notification_center import administration_notifications

        system_notifications = administration_notifications(user)

    return {
        'is_council_user': is_council_user,
        'is_manager_user': is_manager_user,
        'is_hr_user': is_hr_user,
        'is_collaborator_user': is_collaborator_user,
        'is_admin_user': is_admin_user,
        'has_no_group_user': has_no_group_user,
        'system_notifications': system_notifications[:8],
        'system_notification_count': len(system_notifications),
    }
