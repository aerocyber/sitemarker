from flask import Blueprint, request, jsonify, redirect, url_for, current_app
from werkzeug.security import check_password_hash, generate_password_hash
from app.utils.jwt_handler import generate_tokens
import datetime
from Crypto.Cipher import AES
from Crypto.Random import get_random_bytes
from Crypto.Protocol.KDF import PBKDF2
from base64 import b64encode, b64decode
from app.models.user import user_document
import validators
from app.utils.decorators import token_required

auth_bp = Blueprint("auth", __name__)

# Helper function to get AES key
def _get_aes_key(secret_key, salt):
    return PBKDF2(secret_key.encode('utf-8'), salt, dkLen=32, count=1000000)

def dbencrypt(data, secret_key):
    salt = get_random_bytes(16)  # Generate a unique salt for each encryption
    aes_key = _get_aes_key(secret_key, salt)
    try:
        dat = data.encode("utf-8")
        cipher = AES.new(aes_key, AES.MODE_GCM)
        ciphertext, tag = cipher.encrypt_and_digest(dat)
        nonce = cipher.nonce
        # Store salt, nonce, tag, and ciphertext
        encrypted_data = b64encode(salt + nonce + tag + ciphertext).decode("utf-8")
        return encrypted_data
    except Exception as e:
        current_app.logger.error(f"Encryption failed: {e}")
        return None

def dbdecrypt(encrypted_data, secret_key):
    try:
        data = b64decode(encrypted_data)
        salt = data[:16]
        nonce = data[16:32]
        tag = data[32:48]
        ciphertext = data[48:]

        aes_key = _get_aes_key(secret_key, salt)
        cipher = AES.new(aes_key, AES.MODE_GCM, nonce=nonce)
        decrypted_data = cipher.decrypt_and_verify(ciphertext, tag)
        return decrypted_data.decode("utf-8")
    except Exception as e:
        current_app.logger.error(f"Decryption failed: {e}")
        return None

def generate_device_id(device_name, device_os, username):
    """
    Generate a device ID based on the device name, OS, and username.
    The format is: <username>.<device_name>.<device_os>.<timestamp>
    It must not be in mongo db collection
    """

    dev_id_suffix = str(int(datetime.datetime.now().timestamp() * 1000))
    device_full_id = f"{username}.{device_name}.{device_os}.{dev_id_suffix}"

    while current_app.mongo_db.devices.find_one({"device_id": device_full_id}):
        # If the generated ID already exists, generate a new one
        dev_id_suffix = str(int(datetime.datetime.now().timestamp() * 1000))
        device_full_id = f"{username}.{device_name}.{device_os}.{dev_id_suffix}"
    # Insert the device information into the devices collection

    current_app.mongo_db.devices.insert_one({
        "device_id": device_full_id,
        "name": device_name,
        "os": device_os,
        "username": username,
        "created_at": datetime.datetime.now()
    })
    return device_full_id

@auth_bp.route("/login", methods=["POST"])
def login():
    data = request.json
    username_or_email = data.get("username") or data.get("email") # Accept either username or email
    password = data.get("password")
    device_name = data.get("name")
    device_os = data.get("os")

    if not username_or_email or not password or not device_name or not device_os:
        return jsonify({"status": "error", "error": "Missing required login details"}), 400

    query = {"$or": [{"username": username_or_email}, {"email": username_or_email}]}
    user = current_app.mongo_db.users.find_one(query)

    if not user or not check_password_hash(user["password"], password):
        return jsonify({"status": "error", "error": "Invalid credentials"}), 401

    access, refresh = generate_tokens(user["_id"])
    current_app.mongo_db.users.update_one({"_id": user["_id"]}, {"$push": {"refresh_tokens": refresh}})

    device_id = generate_device_id(device_name, device_os, user["username"])

    return jsonify({
        "status": "success",
        "access_token": access,
        "refresh_token": refresh,
        "device_id": device_id
    })

@auth_bp.route("/signup", methods=["POST"])
def signup():
    data = request.json
    username = data.get("username")
    password = data.get("password")
    password_confirm = data.get("password_confirm") # Changed from pswd to password_confirm for clarity
    email = data.get("email")
    fullname = data.get("fullname")

    if not username or not password or not password_confirm or not email or not fullname:
        return jsonify({"status": "error", "error": "Missing required values"}), 400
    
    if not validators.email(email):
        return jsonify({"status": "error", "error": "Invalid email format"}), 400

    if password != password_confirm:
        return jsonify({"status": "error", "error": "Passwords mismatch"}), 400

    if current_app.mongo_db.users.find_one({"username": username}):
        return jsonify({"status": "error", "error": "Username is taken"}), 409 # 409 Conflict

    if current_app.mongo_db.users.find_one({"email": email}):
        return jsonify({"status": "error", "error": "Email is already registered"}), 409 # 409 Conflict

    # Encrypt fullname using the SECRET_KEY from current_app.config
    encrypted_fullname = dbencrypt(fullname, current_app.config["SECRET_KEY"])
    if encrypted_fullname is None:
        return jsonify({"status": "error", "error": "Failed to encrypt fullname"}), 500

    new_user_document = user_document(username, email, generate_password_hash(password))
    new_user_document["fullname"] = encrypted_fullname
    new_user_document["joined"] = datetime.datetime.now()

    current_app.mongo_db.users.insert_one(new_user_document)

    return jsonify({"status": "success", "message": "User registered successfully."}), 201 # 201 Created

@auth_bp.route("/logout", methods=["POST"])
@token_required
def logout(current_user):
    # Get the access token from the Authorization header
    auth_header = request.headers.get("Authorization")
    if not auth_header or not auth_header.startswith("Bearer "):
        return jsonify({"error": "Bearer token missing"}), 400
    
    access_token = auth_header.split(" ")[1]

    # Add the access token to the user's JWT blacklist
    current_app.mongo_db.users.update_one(
        {"_id": current_user["_id"]},
        {"$push": {"jwt_blacklist": access_token}}
    )

    # Optionally, also revoke the refresh token if provided in the request body
    # This is useful for logging out from a specific device/session
    data = request.json
    refresh_token_to_revoke = data.get("refresh_token")
    if refresh_token_to_revoke:
        current_app.mongo_db.users.update_one(
            {"_id": current_user["_id"]},
            {"$pull": {"refresh_tokens": refresh_token_to_revoke}}
        )
        return jsonify({"status": "success", "message": "Logged out successfully and refresh token revoked."}), 200
    
    return jsonify({"status": "success", "message": "Logged out successfully."}), 200
