import jwt, datetime
from flask import current_app

def generate_tokens(user_id):
    now = datetime.datetime.utcnow()
    # Use current_app.config["JWT_SECRET_KEY"] for consistency
    access = jwt.encode({"user_id": str(user_id), "exp": now + datetime.timedelta(weeks=1)}, current_app.config["JWT_SECRET"], algorithm="HS256")
    refresh = jwt.encode({"user_id": str(user_id), "type": "refresh", "exp": now + datetime.timedelta(days=30)}, current_app.config["JWT_SECRET"], algorithm="HS256")
    return access, refresh

def decode_token(token):
    # Use current_app.config["JWT_SECRET_KEY"] for consistency
    return jwt.decode(token, current_app.config["JWT_SECRET"], algorithms=["HS256"])