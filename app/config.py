from app.utils import get_env_or_default

DEBUG = False
SECRET_KEY = '96ee334b287cc46d06e2755254ed4274'
SQLALCHEMY_DATABASE_URI = get_env_or_default('db_url', 'sqlite:///db.db')
