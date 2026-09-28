from django.db import migrations


def assign_open_domain_to_existing_cycles(apps, schema_editor):
    Domain = apps.get_model('core', 'Domain')
    Cycle = apps.get_model('core', 'Cycle')
    open_domain = Domain.objects.filter(type=1).order_by('id').first()
    if not open_domain:
        open_domain = Domain.objects.create(
            description='Aberto',
            type=1,
            domain_description='Ciclo aberto',
        )
    Cycle.objects.filter(domain__isnull=True).update(domain_id=open_domain.id)


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0009_cycle_domain'),
    ]

    operations = [
        migrations.RunPython(assign_open_domain_to_existing_cycles, migrations.RunPython.noop),
    ]
