from django.contrib.auth.models import Group
from django.db import migrations


def create_rh_group(apps, schema_editor):
    Group = apps.get_model('auth', 'Group')
    Group.objects.get_or_create(name='RH')


class Migration(migrations.Migration):
    dependencies = [('core', '0012_assign_open_domain_to_existing_department_objectives')]

    operations = [migrations.RunPython(create_rh_group, migrations.RunPython.noop)]
