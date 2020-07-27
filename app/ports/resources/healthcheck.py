from flask.views import MethodView


class HealthCheckAPI(MethodView):

    def get(self):
        return 'tu!!!', 200
