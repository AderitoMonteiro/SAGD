from django.conf import settings
from django.db import models
from django.utils import timezone


class Cycle(models.Model):
    STATUS_CHOICES = [('active', 'Em andamento'), ('closed', 'Encerrado'), ('planned', 'Planejado')]
    name = models.CharField('nome', max_length=120)
    year = models.PositiveIntegerField('ano')
    start_date = models.DateField('início')
    end_date = models.DateField('fim')
    status = models.CharField('status', max_length=20, choices=STATUS_CHOICES, default='active')

    class Meta:
        ordering = ['-year', '-start_date']
        verbose_name = 'ciclo'
        verbose_name_plural = 'ciclos'

    def __str__(self):
        return f'{self.name} {self.year}'

    @property
    def automatic_status(self):
        today = timezone.localdate()
        if today < self.start_date:
            return 'planned'
        if today <= self.end_date:
            return 'active'
        return 'closed'

    @property
    def automatic_status_display(self):
        return dict(self.STATUS_CHOICES)[self.automatic_status]


class Evaluation(models.Model):
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


class Objective(models.Model):
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


class FollowUp(models.Model):
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


class Validation(models.Model):
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


class InstitutionalObjective(models.Model):
    STATUS_CHOICES = [('draft', 'Rascunho'), ('active', 'Em andamento'), ('completed', 'Concluído')]
    cycle = models.ForeignKey(Cycle, on_delete=models.CASCADE, related_name='institutional_objectives')
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

    @property
    def automatic_status(self):
        return 'completed' if self.cycle.automatic_status == 'closed' else 'active'

    @property
    def automatic_status_display(self):
        return dict(self.STATUS_CHOICES)[self.automatic_status]


class DepartmentObjective(models.Model):
    STATUS_CHOICES = [('draft', 'Rascunho'), ('active', 'Em andamento'), ('completed', 'Concluído')]
    institutional_objective = models.ForeignKey(InstitutionalObjective, on_delete=models.CASCADE, related_name='department_objectives')
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

    @property
    def automatic_status(self):
        return 'completed' if self.institutional_objective.cycle.automatic_status == 'closed' else 'active'

    @property
    def automatic_status_display(self):
        return dict(self.STATUS_CHOICES)[self.automatic_status]


class IndividualObjective(models.Model):
    STATUS_CHOICES = [('draft', 'Rascunho'), ('active', 'Em andamento'), ('completed', 'Concluído')]
    department_objective = models.ForeignKey(DepartmentObjective, on_delete=models.CASCADE, related_name='individual_objectives')
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='individual_objectives')
    description = models.CharField('descrição', max_length=200)
    status = models.CharField('status', max_length=15, choices=STATUS_CHOICES, default='draft')
    date_created = models.DateTimeField('data de criação', auto_now_add=True)
    date_update = models.DateTimeField('data de atualização', auto_now=True)

    class Meta:
        ordering = ['-date_created']
        verbose_name = 'objetivo individual'
        verbose_name_plural = 'objetivos individuais'

    def __str__(self):
        return self.description

    @property
    def automatic_status(self):
        return 'completed' if self.department_objective.institutional_objective.cycle.automatic_status == 'closed' else 'active'

    @property
    def automatic_status_display(self):
        return dict(self.STATUS_CHOICES)[self.automatic_status]