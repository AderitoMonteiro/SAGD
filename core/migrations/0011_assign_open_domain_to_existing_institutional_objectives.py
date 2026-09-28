from django.db import migrations


def assign_open_domain_to_existing_institutional_objectives(apps, schema_editor):
    Domain = apps.get_model('core', 'Domain')
    InstitutionalObjective = apps.get_model('core', 'InstitutionalObjective')
    open_domain = Domain.objects.filter(type=1).order_by('id').first()
    if not open_domain:
        open_domain = Domain.objects.create(
            description='Aberto',
            type=1,
            domain_description='Objetivo aberto',
        )
    InstitutionalObjective.objects.filter(domain__isnull=True).update(domain_id=open_domain.id)


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0010_assign_open_domain_to_existing_cycles'),
    ]

    operations = [
        migrations.RunPython(
            assign_open_domain_to_existing_institutional_objectives,
            migrations.RunPython.noop,
        ),
    ]
