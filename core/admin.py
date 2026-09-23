from django.contrib import admin

from .models import Cycle, Evaluation


@admin.register(Cycle)
class CycleAdmin(admin.ModelAdmin):
    list_display = ('name', 'year', 'status', 'start_date', 'end_date')
    list_filter = ('status', 'year')


@admin.register(Evaluation)
class EvaluationAdmin(admin.ModelAdmin):
    list_display = ('employee', 'cycle', 'evaluation_type', 'status', 'display_score', 'updated_at')
    list_filter = ('status', 'evaluation_type', 'cycle')
    search_fields = ('employee__username', 'employee__first_name', 'employee__last_name')