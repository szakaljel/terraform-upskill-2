from app.utils import get_env_or_default

port = get_env_or_default('port', '5555')
host = get_env_or_default('host', '0.0.0.0')

bind = f'{host}:{port}'
workers = 1
