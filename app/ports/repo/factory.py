from enum import Enum
from app.ports.repo.users import UsersRepo


class FactoryError(Exception):
    pass


class RepoEnum(Enum):
    user = 'user'


class RepoFactory:
    _repo_classes = {
        RepoEnum.user: UsersRepo
    }

    @classmethod
    def get(cls, repo_type: RepoEnum):
        class_ = cls._repo_classes.get(repo_type)
        if class_:
            return class_()
        raise FactoryError(f'No repository implementation for {repo_type}')
