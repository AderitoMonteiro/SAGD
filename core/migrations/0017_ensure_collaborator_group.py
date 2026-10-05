from django.db import migrations


def create_collaborator_group(apps, schema_editor):
    Group = apps.get_model('auth', 'Group')
    Group.objects.get_or_create(name='Colaborador')


def remove_collaborator_group(apps, schema_editor):
    Group = apps.get_model('auth', 'Group')
    Group.objects.filter(name='Colaborador').delete()


class Migration(migrations.Migration):
    dependencies = [
        ('core', '0016_individualobjective_end_date_and_more'),
    ]

    operations = [
        migrations.RunPython(create_collaborator_group, remove_collaborator_group),
    ]
