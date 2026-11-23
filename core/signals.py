import json

from django.contrib.auth import get_user_model
from django.contrib.auth.models import Group
from django.contrib.auth.signals import user_logged_in, user_logged_out, user_login_failed
from django.core.serializers.json import DjangoJSONEncoder
from django.db.models.signals import post_migrate, post_save, pre_save
from django.dispatch import receiver

from .audit import request_metadata
from .models import HistoricoOperacao, UserDepartment


SENSITIVE_FIELDS = {'password', 'token', 'secret', 'cookie', 'session_key', 'csrfmiddlewaretoken'}


def serialize_instance(instance):
    data = {}
    for field in instance._meta.concrete_fields:
        name = field.name
        if any(sensitive in name.lower() for sensitive in SENSITIVE_FIELDS):
            continue
        data[name] = field.value_from_object(instance)
    return json.loads(json.dumps(data, cls=DjangoJSONEncoder))


def audit_description(action, instance):
    return f'{action.capitalize()} {instance._meta.verbose_name}: {str(instance)[:180]}'


def create_audit_entry(*, action, instance=None, description='', before=None, after=None, request=None, **extra):
    metadata = request_metadata(request)
    metadata.update(extra)
    HistoricoOperacao.objects.create(
        acao=action,
        modelo=instance._meta.label if instance else metadata.pop('modelo', ''),
        objeto_id=str(instance.pk) if instance and instance.pk is not None else metadata.pop('objeto_id', ''),
        descricao_objeto=str(instance)[:255] if instance else metadata.pop('descricao_objeto', ''),
        dados_anteriores=before,
        dados_novos=after,
        descricao=description,
        **metadata,
    )


@receiver(pre_save)
def capture_previous_state(sender, instance, raw=False, **kwargs):
    if raw or sender._meta.app_label not in {'core', 'auth'} or sender is HistoricoOperacao or not instance.pk:
        return
    manager = getattr(sender, 'all_objects', sender._default_manager)
    previous = manager.filter(pk=instance.pk).first()
    instance._audit_previous_state = serialize_instance(previous) if previous else None
    instance._audit_sensitive_changed = bool(previous) and any(
        getattr(previous, field.name, None) != getattr(instance, field.name, None)
        for field in instance._meta.concrete_fields
        if any(sensitive in field.name.lower() for sensitive in SENSITIVE_FIELDS)
    )


@receiver(post_save)
def record_model_operation(sender, instance, created=False, raw=False, **kwargs):
    if raw or sender._meta.app_label not in {'core', 'auth'} or sender is HistoricoOperacao:
        return
    after = serialize_instance(instance)
    before = getattr(instance, '_audit_previous_state', None)
    if created:
        action = 'criar'
    elif before == after and not getattr(instance, '_audit_sensitive_changed', False):
        return
    elif before and before.get('is_active') is True and after.get('is_active') is False:
        action = 'eliminar'
    elif before and before.get('is_active') is False and after.get('is_active') is True:
        action = 'restaurar'
    else:
        action = 'editar'
    if created and sender.__name__ == 'AprovacaoTarefa' and getattr(instance, 'domain_id', None):
        decision = (instance.domain.description or '').lower()
        if 'aprov' in decision:
            action = 'aprovar'
        elif 'rejeit' in decision:
            action = 'rejeitar'
    elif not created and before:
        old_status = before.get('status')
        new_status = after.get('status')
        old_domain = before.get('domain')
        new_domain = after.get('domain')
        domain_type = getattr(getattr(instance, 'domain', None), 'type', None)
        if old_status != new_status and new_status in {'completed', 'closed'}:
            action = 'concluir'
        elif old_status != new_status and old_status in {'completed', 'closed'}:
            action = 'reabrir'
        elif old_domain != new_domain and domain_type == 2:
            action = 'concluir'
        elif old_domain != new_domain and domain_type == 1:
            action = 'reabrir'
    create_audit_entry(
        action=action,
        instance=instance,
        before=before,
        after=after,
        description=getattr(instance, '_audit_description', audit_description(action, instance)),
    )


@receiver(user_logged_in)
def record_login(sender, request, user, **kwargs):
    create_audit_entry(
        action='login', request=request, modelo='auth.User', objeto_id=str(user.pk),
        descricao_objeto=user.get_username(), description='Utilizador iniciou sessão.',
    )


@receiver(user_logged_out)
def record_logout(sender, request, user, **kwargs):
    create_audit_entry(
        action='logout', request=request, modelo='auth.User',
        objeto_id=str(user.pk) if user else '',
        descricao_objeto=user.get_username() if user else '',
        description='Utilizador terminou a sessão.',
        utilizador=user,
    )


@receiver(user_login_failed)
def record_failed_login(sender, credentials, request, **kwargs):
    username = credentials.get('username', '')
    create_audit_entry(
        action='login_falhou', request=request, modelo='auth.User',
        descricao_objeto=str(username)[:255], description='Tentativa de autenticação sem sucesso.',
    )


@receiver(post_migrate)
def create_access_groups(sender, **kwargs):
    if sender.name != 'core':
        return
    for name in ['Administrador', 'RH', 'Gestor', 'Conselho de Administração', 'Colaborador']:
        Group.objects.get_or_create(name=name)


@receiver(post_save, sender=get_user_model())
def create_user_department(sender, instance, created, raw=False, **kwargs):
    if created and not raw:
        UserDepartment.objects.get_or_create(user=instance)
