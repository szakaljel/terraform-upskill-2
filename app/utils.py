import os
env_prefix = 'TU'


def get_env_or_default(var_name, default=None):
    name = f'{env_prefix}_{var_name}'.upper()
    return os.environ.get(name, default)
