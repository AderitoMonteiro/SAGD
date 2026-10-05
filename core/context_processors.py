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
    has_no_group_user = user.is_authenticated and not user.is_superuser and not user.groups.exists()
    return {
        'is_council_user': is_council_user,
        'is_manager_user': is_manager_user,
        'is_hr_user': is_hr_user,
        'is_collaborator_user': is_collaborator_user,
        'has_no_group_user': has_no_group_user,
    }
