import json
from flask.views import MethodView
from flask import request
from app.bl.users import UsersQuery, UserCreateCommand
from app.ports.repo.factory import RepoFactory, RepoEnum


class UserAPI(MethodView):

    def get(self):
        users_repo = RepoFactory.get(RepoEnum.user)
        query = UsersQuery(users_repo)
        users = query()
        return json.dumps(users), 200

    def post(self):
        users_repo = RepoFactory.get(RepoEnum.user)
        cmd = UserCreateCommand(users_repo)
        if not ('username' in request.json and 'email' in request.json):
            return 'Invalid data', 400
        data = {
            'username': request.json['username'],
            'email': request.json['email']
        }
        user = cmd(data)
        return json.dumps(user), 200
