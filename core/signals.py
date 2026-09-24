from django.contrib.auth import get_user_model
from django.contrib.auth.models import Group
from django.db.models.signals import post_migrate, post_save
from django.dispatch import receiver

from .models import UserDepartment


@receiver(post_migrate)
def create_access_groups(sender, **kwargs):
    if sender.name != 'core':
        return
    for name in ['Administrador', 'RH', 'Gestor', 'Conselho de Administração', 'Colaborador']:
        Group.objects.get_or_create(name=name)


@receiver(post_save, sender=get_user_model())
def create_user_department(sender, instance, created, **kwargs):
    if created:
        UserDepartment.objects.get_or_create(user=instance)
