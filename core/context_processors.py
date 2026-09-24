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
    return {
        'is_council_user': is_council_user,
        'is_manager_user': is_manager_user,
    }
