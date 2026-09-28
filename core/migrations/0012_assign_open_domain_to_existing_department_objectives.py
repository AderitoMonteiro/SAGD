from django.db import migrations


def assign_open_domain(apps, schema_editor):
    Domain = apps.get_model('core', 'Domain')
    DepartmentObjective = apps.get_model('core', 'DepartmentObjective')

    open_domain = Domain.objects.filter(type=1).order_by('id').first()
    if open_domain is None:
        open_domain = Domain.objects.create(
            description='Aberto',
            type=1,
            domain_description='Objetivo aberto',
        )
    DepartmentObjective.objects.filter(domain__isnull=True).update(domain_id=open_domain.id)


class Migration(migrations.Migration):
    dependencies = [('core', '0011_assign_open_domain_to_existing_institutional_objectives')]

    operations = [migrations.RunPython(assign_open_domain, migrations.RunPython.noop)]
