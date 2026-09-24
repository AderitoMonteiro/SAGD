from django.contrib import admin
from django.contrib.auth import get_user_model
from django.contrib.auth.admin import UserAdmin

from .models import Cycle, Department, DepartmentObjective, Evaluation, InstitutionalObjective, UserDepartment


@admin.register(Cycle)
class CycleAdmin(admin.ModelAdmin):
    list_display = ('name', 'year', 'status', 'start_date', 'end_date')
    list_filter = ('status', 'year')


@admin.register(Evaluation)
class EvaluationAdmin(admin.ModelAdmin):
    list_display = ('employee', 'cycle', 'evaluation_type', 'status', 'display_score', 'updated_at')
    list_filter = ('status', 'evaluation_type', 'cycle')
    search_fields = ('employee__username', 'employee__first_name', 'employee__last_name')


@admin.register(Department)
class DepartmentAdmin(admin.ModelAdmin):
    list_display = ('name', 'code', 'is_active', 'date_update')
    list_filter = ('is_active',)
    search_fields = ('name', 'code')


class UserDepartmentInline(admin.StackedInline):
    model = UserDepartment
    extra = 0
    max_num = 1
    can_delete = False
    verbose_name = 'Departamento'
    verbose_name_plural = 'Departamento'


User = get_user_model()
admin.site.unregister(User)


@admin.register(User)
class SAGDUserAdmin(UserAdmin):
    inlines = (UserDepartmentInline,)
    list_display = UserAdmin.list_display + ('department_name',)

    @admin.display(description='Departamento')
    def department_name(self, user):
        profile = getattr(user, 'department_profile', None)
        return profile.department if profile and profile.department else '—'


@admin.register(InstitutionalObjective)
class InstitutionalObjectiveAdmin(admin.ModelAdmin):
    list_display = ('description', 'cycle', 'status', 'date_created')
    list_filter = ('status', 'cycle')
    search_fields = ('description', 'cycle__name')


@admin.register(DepartmentObjective)
class DepartmentObjectiveAdmin(admin.ModelAdmin):
    list_display = ('description', 'department', 'institutional_objective', 'status', 'date_created')
    list_filter = ('status', 'department', 'institutional_objective__cycle')
    search_fields = ('description', 'department__name', 'department__code', 'institutional_objective__description')
    autocomplete_fields = ('department', 'institutional_objective')
