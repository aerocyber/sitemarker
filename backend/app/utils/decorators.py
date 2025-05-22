from bson import ObjectId
from flask import request, jsonify, current_app
from app.utils.jwt_handler import decode_token
import jwt
from functools import wraps

def token_required(f):
    @wraps(f)
    def wrapper(*args, **kwargs):
        token = request.headers.get("Authorization").split(" ")[1]
        try:
            decoded = decode_token(token)
            user = current_app.mongo_db.users.find_one({"_id": ObjectId(decoded["user_id"])})
            if not user or token in user.get("jwt_blacklist", []):
                return jsonify({"error": "Unauthorized"}), 403
            return f(user, *args, **kwargs)
        except jwt.ExpiredSignatureError:
            return jsonify({"error": "Token expired"}), 401
    return wrapper
