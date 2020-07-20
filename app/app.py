from flask import Flask
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
app.config.from_object('app.config')
db = SQLAlchemy(app)


def create_app():
    from app.ports.resources.users import UserAPI
    from app.ports.resources.healthcheck import HealthCheckAPI
    app.add_url_rule('/users', view_func=UserAPI.as_view('users'))
    app.add_url_rule('/health', view_func=HealthCheckAPI.as_view('health'))
    return app
