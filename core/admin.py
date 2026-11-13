from django.contrib import admin
from django.contrib.auth import get_user_model
from django.contrib.auth.admin import UserAdmin

from .models import Cycle, Department, DepartmentObjective, Domain, Evaluation, HistoricoOperacao, InstitutionalObjective, UserDepartment


@admin.register(Cycle)
class CycleAdmin(admin.ModelAdmin):
    list_display = ('name', 'year', 'domain', 'status', 'start_date', 'end_date')
    list_filter = ('status', 'domain', 'year')


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
    list_display = ('description', 'domain', 'cycle', 'status', 'date_created')
    list_filter = ('status', 'domain', 'cycle')
    search_fields = ('description', 'cycle__name')


@admin.register(DepartmentObjective)
class DepartmentObjectiveAdmin(admin.ModelAdmin):
    list_display = ('description', 'department', 'percentagem', 'domain', 'institutional_objective', 'status', 'date_created')
    list_filter = ('status', 'department', 'domain', 'institutional_objective__cycle')
    search_fields = ('description', 'department__name', 'department__code', 'institutional_objective__description')
    autocomplete_fields = ('department', 'institutional_objective')


@admin.register(Domain)
class DomainAdmin(admin.ModelAdmin):
    list_display = ('description', 'type', 'domain_description', 'date_update')
    list_filter = ('type',)
    search_fields = ('description', 'domain_description')


@admin.register(HistoricoOperacao)
class HistoricoOperacaoAdmin(admin.ModelAdmin):
    list_display = ('data_criacao', 'utilizador', 'acao', 'modelo', 'objeto_id', 'endereco_ip')
    list_filter = ('acao', 'modelo', 'data_criacao')
    search_fields = ('utilizador__username', 'descricao_objeto', 'descricao', 'objeto_id', 'endereco_ip')
    readonly_fields = (
        'utilizador', 'acao', 'modelo', 'objeto_id', 'descricao_objeto',
        'dados_anteriores', 'dados_novos', 'descricao', 'endereco_ip',
        'user_agent', 'rota', 'metodo_http', 'data_criacao',
    )
    date_hierarchy = 'data_criacao'
    ordering = ('-data_criacao',)

    def has_add_permission(self, request):
        return False

    def has_change_permission(self, request, obj=None):
        return False

    def has_delete_permission(self, request, obj=None):
        return False
