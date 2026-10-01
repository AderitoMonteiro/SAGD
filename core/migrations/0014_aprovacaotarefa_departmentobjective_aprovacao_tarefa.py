from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0013_create_rh_group'),
    ]

    operations = [
        migrations.CreateModel(
            name='AprovacaoTarefa',
            fields=[
                (
                    'id',
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name='ID',
                    ),
                ),
                ('obs', models.CharField(max_length=200, verbose_name='observação')),
                (
                    'date_created',
                    models.DateTimeField(auto_now_add=True, verbose_name='data de criação'),
                ),
                (
                    'date_update',
                    models.DateTimeField(auto_now=True, verbose_name='data de atualização'),
                ),
                (
                    'domain',
                    models.ForeignKey(
                        blank=True,
                        null=True,
                        on_delete=django.db.models.deletion.SET_NULL,
                        related_name='aprovacoes_tarefas',
                        to='core.domain',
                        verbose_name='domínio',
                    ),
                ),
            ],
            options={
                'verbose_name': 'aprovação de tarefa',
                'verbose_name_plural': 'aprovações de tarefas',
                'db_table': 'aprovacao_tarefas',
                'ordering': ['-date_created'],
            },
        ),
        migrations.AddField(
            model_name='departmentobjective',
            name='aprovacao_tarefa',
            field=models.ForeignKey(
                blank=True,
                null=True,
                on_delete=django.db.models.deletion.SET_NULL,
                related_name='department_objectives',
                to='core.aprovacaotarefa',
                verbose_name='aprovação da tarefa',
            ),
        ),
    ]
