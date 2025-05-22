from bson import ObjectId

def user_document(username, email, hashed_pw):
    return {
        "username": username,
        "email": email,
        "password": hashed_pw,
        "refresh_tokens": [],
        "jwt_blacklist": []
    }
