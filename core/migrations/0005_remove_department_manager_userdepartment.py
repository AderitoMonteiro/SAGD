# Generated manually for the user-to-department association.

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


def create_user_department_profiles(apps, schema_editor):
    app_label, model_name = settings.AUTH_USER_MODEL.split('.')
    User = apps.get_model(app_label, model_name)
    UserDepartment = apps.get_model('core', 'UserDepartment')
    for user in User.objects.all().iterator():
        UserDepartment.objects.get_or_create(user_id=user.pk)


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0004_department_departmentobjective_department'),
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.RemoveField(
            model_name='department',
            name='manager',
        ),
        migrations.CreateModel(
            name='UserDepartment',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('department', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='users', to='core.department', verbose_name='departamento')),
                ('user', models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, related_name='department_profile', to=settings.AUTH_USER_MODEL, verbose_name='utilizador')),
            ],
            options={
                'verbose_name': 'departamento do utilizador',
                'verbose_name_plural': 'departamentos dos utilizadores',
            },
        ),
        migrations.RunPython(create_user_department_profiles, migrations.RunPython.noop),
    ]
