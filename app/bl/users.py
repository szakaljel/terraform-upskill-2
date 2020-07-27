class UsersQuery:

    def __init__(self, users_repo):
        self._users_repo = users_repo

    def __call__(self):
        return self._users_repo.get_users()


class UserCreateCommand:
    def __init__(self, users_repo):
        self._users_repo = users_repo

    def __call__(self, data):
        return self._users_repo.create_user(data)
