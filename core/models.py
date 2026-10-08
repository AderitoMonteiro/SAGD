from django.conf import settings
from django.core.validators import MaxValueValidator, MinValueValidator
from django.db import models
from django.utils import timezone


class ActiveRecordQuerySet(models.QuerySet):
    def delete(self):
        count = 0
        details = {}
        for instance in self.iterator():
            instance.delete()
            count += 1
            label = instance._meta.label
            details[label] = details.get(label, 0) + 1
        return count, details

    def hard_delete(self):
        return super().delete()


class ActiveRecordManager(models.Manager.from_queryset(ActiveRecordQuerySet)):
    def get_queryset(self):
        return super().get_queryset().filter(is_active=True)


class ActiveRecord(models.Model):
    is_active = models.BooleanField('ativo', default=True, db_index=True)

    objects = ActiveRecordManager()
    all_objects = models.Manager()

    class Meta:
        abstract = True

    def delete(self, using=None, keep_parents=False):
        self.is_active = False
        self.save(using=using, update_fields=['is_active'])

    def restore(self, using=None):
        self.is_active = True
        self.save(using=using, update_fields=['is_active'])


class Cycle(ActiveRecord):
    STATUS_CHOICES = [('active', 'Em andamento'), ('closed', 'Encerrado'), ('planned', 'Planejado')]
    name = models.CharField('nome', max_length=120)
    year = models.PositiveIntegerField('ano')
    start_date = models.DateField('início')
    end_date = models.DateField('fim')
    domain = models.ForeignKey('Domain', on_delete=models.SET_NULL, null=True, blank=True, related_name='cycles', verbose_name='domínio')
    status = models.CharField('status', max_length=20, choices=STATUS_CHOICES, default='active')

    class Meta:
        ordering = ['-year', '-start_date']
        verbose_name = 'ciclo'
        verbose_name_plural = 'ciclos'

    def __str__(self):
        return f'{self.name} {self.year}'

    def save(self, *args, **kwargs):
        if not self.domain_id:
            open_domain = Domain.objects.filter(type=1).order_by('id').first()
            if not open_domain:
                open_domain = Domain.objects.create(
                    description='Aberto',
                    type=1,
                    domain_description='Ciclo aberto',
                )
            self.domain = open_domain
        super().save(*args, **kwargs)

    def delete(self, using=None, keep_parents=False):
        institutional_ids = InstitutionalObjective.all_objects.filter(cycle=self).values_list('id', flat=True)
        department_ids = DepartmentObjective.all_objects.filter(
            institutional_objective_id__in=institutional_ids
        ).values_list('id', flat=True)
        individual_ids = IndividualObjective.all_objects.filter(
            department_objective_id__in=department_ids
        ).values_list('id', flat=True)
        RegistoOcorrencia.all_objects.filter(individual_objective_id__in=individual_ids).update(is_active=False)
        IndividualObjective.all_objects.filter(id__in=individual_ids).update(is_active=False)
        AprovacaoTarefa.all_objects.filter(department_objective_id__in=department_ids).update(is_active=False)
        DepartmentObjective.all_objects.filter(id__in=department_ids).update(is_active=False)
        InstitutionalObjective.all_objects.filter(id__in=institutional_ids).update(is_active=False)
        Validation.all_objects.filter(evaluation__cycle=self).update(is_active=False)
        Evaluation.all_objects.filter(cycle=self).update(is_active=False)
        Objective.all_objects.filter(cycle=self).update(is_active=False)
        FollowUp.all_objects.filter(cycle=self).update(is_active=False)
        super().delete(using=using, keep_parents=keep_parents)

    @property
    def automatic_status(self):
        if self.domain_id and self.domain.type == 2:
            return 'closed'
        if self.domain_id and self.domain.type == 1:
            return 'active'
        today = timezone.localdate()
        if today < self.start_date:
            return 'planned'
        if today <= self.end_date:
            return 'active'
        return 'closed'

    @property
    def is_open(self):
        return self.automatic_status != 'closed'

    @property
    def automatic_status_display(self):
        return dict(self.STATUS_CHOICES)[self.automatic_status]

    @property
    def schedule_flag(self):
        today = timezone.localdate()
        if today > self.end_date:
            return 'overdue'
        if today < self.start_date:
            return 'upcoming'
        return 'warning' if (self.end_date - today).days <= 7 else 'adequate'

    @property
    def schedule_flag_display(self):
        today = timezone.localdate()
        if self.schedule_flag == 'overdue':
            days = (today - self.end_date).days
            return f'Data limite ultrapassada há {days} dia{"s" if days != 1 else ""}'
        if self.schedule_flag == 'upcoming':
            days = (self.start_date - today).days
            return f'Inicia em {days} dia{"s" if days != 1 else ""}'
        days = (self.end_date - today).days
        if days == 0:
            return 'Data limite: hoje'
        if self.schedule_flag == 'warning':
            return f'Alerta: faltam {days} dia{"s" if days != 1 else ""}'
        return f'{days} dias restantes'

class Evaluation(ActiveRecord):
    TYPE_CHOICES = [('mid', 'Intercalar'), ('final', 'Final')]
    STATUS_CHOICES = [('pending', 'Pendente'), ('draft', 'Em preenchimento'), ('submitted', 'Enviada'), ('validated', 'Validada')]
    cycle = models.ForeignKey(Cycle, on_delete=models.CASCADE, related_name='evaluations')
    employee = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='evaluations_received')
    evaluator = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.SET_NULL, null=True, blank=True, related_name='evaluations_made')
    evaluation_type = models.CharField('tipo', max_length=10, choices=TYPE_CHOICES)
    status = models.CharField('status', max_length=15, choices=STATUS_CHOICES, default='pending')
    self_score = models.DecimalField('nota de autoavaliação', max_digits=4, decimal_places=1, null=True, blank=True)
    manager_score = models.DecimalField('nota da chefia', max_digits=4, decimal_places=1, null=True, blank=True)
    feedback = models.TextField('feedback', blank=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['-updated_at']
        verbose_name = 'avaliação'
        verbose_name_plural = 'avaliações'

    @property
    def display_score(self):
        return self.manager_score or self.self_score

    def delete(self, using=None, keep_parents=False):
        Validation.all_objects.filter(evaluation=self).update(is_active=False)
        super().delete(using=using, keep_parents=keep_parents)


class Objective(ActiveRecord):
    CATEGORY_CHOICES = [('organizational', 'Organizacional'), ('departmental', 'Departamental'), ('individual', 'Individual')]
    STATUS_CHOICES = [('draft', 'Rascunho'), ('active', 'Em andamento'), ('completed', 'Concluído')]
    cycle = models.ForeignKey(Cycle, on_delete=models.CASCADE, related_name='objectives')
    employee = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='objectives', null=True, blank=True)
    created_by = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.SET_NULL, null=True, related_name='objectives_created')
    category = models.CharField('nível', max_length=20, choices=CATEGORY_CHOICES)
    title = models.CharField('título', max_length=160)
    description = models.TextField('descrição')
    measure = models.CharField('indicador de sucesso', max_length=220, blank=True)
    status = models.CharField('status', max_length=15, choices=STATUS_CHOICES, default='draft')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['category', '-updated_at']
        verbose_name = 'objetivo'
        verbose_name_plural = 'objetivos'

    def __str__(self):
        return self.title


class FollowUp(ActiveRecord):
    TYPE_CHOICES = [('evidence', 'Evidência'), ('feedback', 'Feedback'), ('adjustment', 'Ajuste de rota')]
    cycle = models.ForeignKey(Cycle, on_delete=models.CASCADE, related_name='follow_ups')
    employee = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='follow_ups')
    author = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.SET_NULL, null=True, related_name='follow_ups_authored')
    entry_type = models.CharField('tipo', max_length=15, choices=TYPE_CHOICES)
    title = models.CharField('título', max_length=160)
    content = models.TextField('registro')
    next_step = models.CharField('próximo passo', max_length=220, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['-created_at']
        verbose_name = 'acompanhamento'
        verbose_name_plural = 'acompanhamentos'


class Validation(ActiveRecord):
    STATUS_CHOICES = [('pending', 'Pendente'), ('approved', 'Aprovada'), ('returned', 'Devolvida')]
    ROLE_CHOICES = [('manager', 'Chefia imediata'), ('hr', 'Recursos Humanos'), ('council', 'Conselho de Administração')]
    cycle = models.ForeignKey(Cycle, on_delete=models.CASCADE, related_name='validations')
    evaluation = models.ForeignKey(Evaluation, on_delete=models.CASCADE, related_name='validations')
    validator = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.SET_NULL, null=True, related_name='validations_made')
    role = models.CharField('papel', max_length=15, choices=ROLE_CHOICES)
    status = models.CharField('status', max_length=15, choices=STATUS_CHOICES, default='pending')
    comment = models.TextField('comentário', blank=True)
    validated_at = models.DateTimeField(null=True, blank=True)

    class Meta:
        ordering = ['status', 'role']
        verbose_name = 'validação'
        verbose_name_plural = 'validações'


class InstitutionalObjective(ActiveRecord):
    STATUS_CHOICES = [('draft', 'Rascunho'), ('active', 'Em andamento'), ('completed', 'Concluído')]
    cycle = models.ForeignKey(Cycle, on_delete=models.CASCADE, related_name='institutional_objectives')
    domain = models.ForeignKey('Domain', on_delete=models.SET_NULL, null=True, blank=True, related_name='institutional_objectives', verbose_name='domínio')
    description = models.CharField('descrição', max_length=200)
    status = models.CharField('status', max_length=15, choices=STATUS_CHOICES, default='draft')
    date_created = models.DateTimeField('data de criação', auto_now_add=True)
    date_update = models.DateTimeField('data de atualização', auto_now=True)

    class Meta:
        ordering = ['-date_created']
        verbose_name = 'objetivo institucional'
        verbose_name_plural = 'objetivos institucionais'

    def __str__(self):
        return self.description

    def save(self, *args, **kwargs):
        if not self.domain_id:
            open_domain = Domain.objects.filter(type=1).order_by('id').first()
            if not open_domain:
                open_domain = Domain.objects.create(
                    description='Aberto',
                    type=1,
                    domain_description='Objetivo aberto',
                )
            self.domain = open_domain
        super().save(*args, **kwargs)

    def delete(self, using=None, keep_parents=False):
        department_ids = DepartmentObjective.all_objects.filter(
            institutional_objective=self
        ).values_list('id', flat=True)
        individual_ids = IndividualObjective.all_objects.filter(
            department_objective_id__in=department_ids
        ).values_list('id', flat=True)
        RegistoOcorrencia.all_objects.filter(individual_objective_id__in=individual_ids).update(is_active=False)
        IndividualObjective.all_objects.filter(id__in=individual_ids).update(is_active=False)
        AprovacaoTarefa.all_objects.filter(department_objective_id__in=department_ids).update(is_active=False)
        DepartmentObjective.all_objects.filter(id__in=department_ids).update(is_active=False)
        super().delete(using=using, keep_parents=keep_parents)

    @property
    def automatic_status(self):
        if self.domain_id and self.domain.type == 2:
            return 'completed'
        if self.domain_id and self.domain.type == 1:
            return 'active'
        return 'completed' if self.cycle.automatic_status == 'closed' else 'active'

    @property
    def is_open(self):
        return self.automatic_status != 'completed'

    @property
    def automatic_status_display(self):
        return dict(self.STATUS_CHOICES)[self.automatic_status]

class Department(ActiveRecord):
    name = models.CharField('nome', max_length=120, unique=True)
    code = models.CharField('código', max_length=30, unique=True)
    description = models.TextField('descrição', blank=True)
    date_created = models.DateTimeField('data de criação', auto_now_add=True)
    date_update = models.DateTimeField('data de atualização', auto_now=True)

    class Meta:
        ordering = ['name']
        verbose_name = 'departamento'
        verbose_name_plural = 'departamentos'

    def __str__(self):
        return f'{self.code} - {self.name}'


class UserDepartment(ActiveRecord):
    user = models.OneToOneField(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='department_profile',
        verbose_name='utilizador',
    )
    department = models.ForeignKey(
        Department,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='users',
        verbose_name='departamento',
    )

    class Meta:
        verbose_name = 'departamento do utilizador'
        verbose_name_plural = 'departamentos dos utilizadores'

    def __str__(self):
        return f'{self.user} - {self.department or "Sem departamento"}'


class AprovacaoTarefa(ActiveRecord):
    obs = models.CharField('observação', max_length=200)
    department_objective = models.ForeignKey(
        'DepartmentObjective',
        db_column='objetivo_departtamento_id',
        on_delete=models.CASCADE,
        null=True,
        blank=True,
        related_name='approval_history',
        verbose_name='objetivo departamental',
    )
    domain = models.ForeignKey(
        'Domain',
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='aprovacoes_tarefas',
        verbose_name='domínio',
    )
    date_created = models.DateTimeField('data de criação', auto_now_add=True)
    date_update = models.DateTimeField('data de atualização', auto_now=True)

    class Meta:
        db_table = 'aprovacao_tarefas'
        ordering = ['-date_created', '-id']
        verbose_name = 'aprovação de tarefa'
        verbose_name_plural = 'aprovações de tarefas'

    def __str__(self):
        return self.obs


class DepartmentObjective(ActiveRecord):
    STATUS_CHOICES = [('draft', 'Rascunho'), ('active', 'Em andamento'), ('completed', 'Concluído')]
    institutional_objective = models.ForeignKey(InstitutionalObjective, on_delete=models.CASCADE, related_name='department_objectives')
    department = models.ForeignKey(Department, on_delete=models.SET_NULL, null=True, blank=True, related_name='objectives', verbose_name='departamento')
    domain = models.ForeignKey('Domain', on_delete=models.SET_NULL, null=True, blank=True, related_name='department_objectives', verbose_name='domínio')
    description = models.CharField('descrição', max_length=200)
    status = models.CharField('status', max_length=15, choices=STATUS_CHOICES, default='draft')
    date_created = models.DateTimeField('data de criação', auto_now_add=True)
    date_update = models.DateTimeField('data de atualização', auto_now=True)

    class Meta:
        ordering = ['-date_created']
        verbose_name = 'objetivo departamental'
        verbose_name_plural = 'objetivos departamentais'

    def __str__(self):
        return self.description

    def save(self, *args, **kwargs):
        if not self.domain_id:
            open_domain = Domain.objects.filter(type=1).order_by('id').first()
            if not open_domain:
                open_domain = Domain.objects.create(
                    description='Aberto',
                    type=1,
                    domain_description='Objetivo aberto',
                )
            self.domain = open_domain
        super().save(*args, **kwargs)

    def delete(self, using=None, keep_parents=False):
        individual_ids = IndividualObjective.all_objects.filter(
            department_objective=self
        ).values_list('id', flat=True)
        RegistoOcorrencia.all_objects.filter(individual_objective_id__in=individual_ids).update(is_active=False)
        IndividualObjective.all_objects.filter(id__in=individual_ids).update(is_active=False)
        AprovacaoTarefa.all_objects.filter(department_objective=self).update(is_active=False)
        super().delete(using=using, keep_parents=keep_parents)

    @property
    def automatic_status(self):
        if self.domain_id and self.domain.type == 2:
            return 'completed'
        if self.domain_id and self.domain.type == 1:
            return 'active'
        return 'completed' if self.institutional_objective.cycle.automatic_status == 'closed' else 'active'

    @property
    def is_open(self):
        return self.automatic_status != 'completed'

    @property
    def automatic_status_display(self):
        return dict(self.STATUS_CHOICES)[self.automatic_status]

    @property
    def approval_status(self):
        approval = self.latest_approval
        if not approval or not approval.domain_id:
            return 'pending_approval'
        approval_description = approval.domain.description.strip().casefold()
        if approval_description == 'aprovado':
            return 'approved'
        if approval_description == 'rejeitado':
            return 'rejected'
        return 'pending_approval'

    @property
    def listing_status(self):
        if self.approval_status == 'pending_approval':
            return 'pending-approval'
        if self.approval_status == 'rejected':
            return 'rejected'
        return self.automatic_status

    @property
    def listing_status_display(self):
        if self.approval_status == 'pending_approval':
            return 'Por aprovar'
        if self.approval_status == 'rejected':
            return 'Rejeitado'
        return self.automatic_status_display

    @property
    def can_be_edited(self):
        return self.automatic_status != 'completed' or self.approval_status == 'rejected'

    @property
    def has_admin_feedback(self):
        return bool(self.approval_comments)

    @property
    def is_approved(self):
        return self.approval_status == 'approved'

    @property
    def approval_entries(self):
        if not hasattr(self, '_approval_entries_cache'):
            self._approval_entries_cache = list(self.approval_history.all())
        return self._approval_entries_cache

    @property
    def latest_approval(self):
        return self.approval_entries[0] if self.approval_entries else None

    @property
    def approval_comments(self):
        return [
            entry for entry in self.approval_entries
            if entry.obs.strip()
            and not entry.obs.strip().casefold().startswith('aprovado por ')
        ]


class IndividualObjective(ActiveRecord):
    STATUS_CHOICES = [('draft', 'Rascunho'), ('active', 'Em andamento'), ('completed', 'Concluído')]
    department_objective = models.ForeignKey(DepartmentObjective, on_delete=models.CASCADE, related_name='individual_objectives')
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='individual_objectives')
    domain = models.ForeignKey('Domain', on_delete=models.SET_NULL, null=True, blank=True, related_name='individual_objectives', verbose_name='domínio')
    description = models.CharField('descrição', max_length=200)
    start_date = models.DateField('data de início', null=True, blank=True)
    end_date = models.DateField('data de fim', null=True, blank=True)
    percentagem = models.DecimalField(
        'percentagem',
        max_digits=5,
        decimal_places=2,
        default=0,
        validators=[MinValueValidator(0), MaxValueValidator(100)],
    )
    status = models.CharField('status', max_length=15, choices=STATUS_CHOICES, default='draft')
    date_created = models.DateTimeField('data de criação', auto_now_add=True)
    date_update = models.DateTimeField('data de atualização', auto_now=True)

    class Meta:
        ordering = ['-date_created']
        verbose_name = 'objetivo individual'
        verbose_name_plural = 'objetivos individuais'

    def __str__(self):
        return self.description

    def delete(self, using=None, keep_parents=False):
        RegistoOcorrencia.all_objects.filter(individual_objective=self).update(is_active=False)
        super().delete(using=using, keep_parents=keep_parents)

    @property
    def automatic_status(self):
        if self.status == 'completed' or self.department_objective.institutional_objective.cycle.automatic_status == 'closed':
            return 'completed'
        return self.status

    @property
    def automatic_status_display(self):
        return dict(self.STATUS_CHOICES)[self.automatic_status]


    @property
    def schedule_flag(self):
        if not self.start_date or not self.end_date:
            return 'missing'
        today = timezone.localdate()
        if today > self.end_date:
            return 'overdue'
        if today < self.start_date:
            return 'upcoming'
        return 'warning' if (self.end_date - today).days <= 7 else 'adequate'

    @property
    def schedule_flag_display(self):
        flag = self.schedule_flag
        if flag == 'missing':
            return 'Prazo não definido'
        today = timezone.localdate()
        if flag == 'overdue':
            days = (today - self.end_date).days
            return f'Data limite ultrapassada há {days} dia{"s" if days != 1 else ""}'
        if flag == 'upcoming':
            days = (self.start_date - today).days
            return f'Inicia em {days} dia{"s" if days != 1 else ""}'
        days = (self.end_date - today).days
        if days == 0:
            return 'Data limite: hoje'
        if flag == 'warning':
            return f'Alerta: faltam {days} dia{"s" if days != 1 else ""}'
        return f'{days} dias restantes'

    @property
    def can_register_occurrence(self):
        if self.status != 'active' or not self.start_date or not self.end_date:
            return False
        today = timezone.localdate()
        return (
            self.department_objective.institutional_objective.cycle.automatic_status != 'closed'
            and self.start_date <= today <= self.end_date
        )


class RegistoOcorrencia(ActiveRecord):
    description = models.CharField('descrição', max_length=200)
    individual_objective = models.ForeignKey(
        IndividualObjective,
        on_delete=models.CASCADE,
        related_name='occurrence_records',
        db_column='objetivo_individual_id',
        verbose_name='objetivo individual',
    )
    date_created = models.DateTimeField('data de criação', auto_now_add=True)
    date_update = models.DateTimeField('data de atualização', auto_now=True)

    class Meta:
        db_table = 'registo_ocorrencia'
        ordering = ['-date_created']
        verbose_name = 'registo de ocorrência'
        verbose_name_plural = 'registos de ocorrências'

    def __str__(self):
        return self.description


class Domain(ActiveRecord):
    description = models.CharField('descrição', max_length=100)
    type = models.IntegerField('tipo')
    domain_description = models.CharField('descrição do domínio', max_length=100)
    date_created = models.DateTimeField('data de criação', auto_now_add=True)
    date_update = models.DateTimeField('data de atualização', auto_now=True)

    class Meta:
        db_table = 'domain'
        ordering = ['description']
        verbose_name = 'domínio'
        verbose_name_plural = 'domínios'

    def __str__(self):
        return self.description
