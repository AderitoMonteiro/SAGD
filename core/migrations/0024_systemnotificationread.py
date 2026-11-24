from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0023_alter_historicooperacao_acao'),
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.CreateModel(
            name='SystemNotificationRead',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('notification_key', models.CharField(max_length=200, verbose_name='chave da notificação')),
                ('read_at', models.DateTimeField(auto_now_add=True, verbose_name='visualizada em')),
                ('user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='read_system_notifications', to=settings.AUTH_USER_MODEL, verbose_name='utilizador')),
            ],
            options={
                'verbose_name': 'notificação visualizada',
                'verbose_name_plural': 'notificações visualizadas',
                'db_table': 'system_notification_reads',
                'ordering': ['-read_at'],
                'constraints': [models.UniqueConstraint(fields=('user', 'notification_key'), name='uniq_system_notification_read_user_key')],
            },
        ),
    ]
