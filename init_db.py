from app.ports.repo.models import *


def db_exists():
    try:
        db.session.execute("select * from public.user limit 1")
        return True
    except:
        return False


if not db_exists():
    db.drop_all()
    db.create_all()

