import warnings

from django.db.backends.mysql.base import DatabaseWrapper as MySQLDatabaseWrapper

from .features import DatabaseFeatures


class DatabaseWrapper(MySQLDatabaseWrapper):
    """Permite a utilização temporária do MariaDB 10.4 fornecido pelo XAMPP."""

    def check_database_version_supported(self):
        warnings.warn(
            'MariaDB 10.4 está abaixo da versão oficialmente suportada pelo Django 5.2. '
            'Atualize o MariaDB do XAMPP para 10.5 ou superior quando possível.',
            RuntimeWarning,
        )

    features_class = DatabaseFeatures
