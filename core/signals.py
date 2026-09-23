from django.contrib.auth.models import Group
from django.db.models.signals import post_migrate
from django.dispatch import receiver


@receiver(post_migrate)
def create_access_groups(sender, **kwargs):
    if sender.name != 'core':
        return
    for name in ['Administrador', 'RH', 'Gestor', 'Conselho de Administração', 'Colaborador']:
        Group.objects.get_or_create(name=name)