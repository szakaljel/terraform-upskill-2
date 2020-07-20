from app.ports.repo.models import User, db


class UsersRepo:
    def get_users(self):
        users = User.query.all()
        return [{'username': user.username, 'email': user.email} for user in users]

    def create_user(self, data):
        user = User(**data)
        db.session.add(user)
        db.session.commit()
        return {'username': user.username, 'email': user.email}