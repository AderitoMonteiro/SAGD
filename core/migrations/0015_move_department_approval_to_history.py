from django.db import migrations, models
import django.db.models.deletion


def link_existing_approvals(apps, schema_editor):
    DepartmentObjective = apps.get_model('core', 'DepartmentObjective')
    AprovacaoTarefa = apps.get_model('core', 'AprovacaoTarefa')

    for objective in DepartmentObjective.objects.exclude(
        aprovacao_tarefa_id__isnull=True
    ).iterator():
        AprovacaoTarefa.objects.filter(
            pk=objective.aprovacao_tarefa_id
        ).update(department_objective_id=objective.pk)


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0014_aprovacaotarefa_departmentobjective_aprovacao_tarefa'),
    ]

    operations = [
        migrations.AddField(
            model_name='aprovacaotarefa',
            name='department_objective',
            field=models.ForeignKey(
                blank=True,
                db_column='objetivo_departtamento_id',
                null=True,
                on_delete=django.db.models.deletion.CASCADE,
                related_name='approval_history',
                to='core.departmentobjective',
                verbose_name='objetivo departamental',
            ),
        ),
        migrations.RunPython(link_existing_approvals, migrations.RunPython.noop),
        migrations.RemoveField(
            model_name='departmentobjective',
            name='aprovacao_tarefa',
        ),
        migrations.AlterModelOptions(
            name='aprovacaotarefa',
            options={
                'ordering': ['-date_created', '-id'],
                'verbose_name': 'aprovação de tarefa',
                'verbose_name_plural': 'aprovações de tarefas',
            },
        ),
    ]
