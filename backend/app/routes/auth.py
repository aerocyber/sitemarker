from flask import Blueprint, request, jsonify, redirect, url_for, current_app
from werkzeug.security import check_password_hash, generate_password_hash
from app.utils.jwt_handler import generate_tokens, decode_token
import datetime
from Crypto.Cipher import AES
from Crypto.Random import get_random_bytes
from Crypto.Protocol.KDF import PBKDF2
from base64 import b64encode, b64decode
from app.models.user import user_document
import validators
from app.utils.decorators import token_required
import string # Import for generating random strings
import random # Import for generating random strings
import smtplib # For sending emails
import ssl # For secure email connections
from email.mime.text import MIMEText


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

@auth_bp.route("/refresh", methods=["POST"])
@token_required
def refresh(current_user):
    # Get the refresh token from the request body
    data = request.json
    refresh_token = data.get("refresh_token")
    
    if not refresh_token:
        return jsonify({"status": "error", "error": "Refresh token is required"}), 400

    # Check if the refresh token is valid and belongs to the user
    if refresh_token not in current_user["refresh_tokens"]:
        return jsonify({"status": "error", "error": "Invalid refresh token"}), 401
    
    # Check if the refresh token is blacklisted
    if refresh_token in current_user.get("jwt_blacklist", []):
        return jsonify({"status": "error", "error": "Invalid refresh token"}), 401
    
    # Check if the refresh token is expired
    try:
        decoded_refresh = decode_token(refresh_token)
        if decoded_refresh["exp"] < datetime.datetime.now():
            return jsonify({"status": "error", "error": "Refresh token is expired"}), 401
    except Exception as e:
        current_app.logger.error(f"Token decoding failed: {e}")
        return jsonify({"status": "error", "error": "Invalid refresh token"}), 401

    # Generate new access and refresh tokens
    new_access, new_refresh = generate_tokens(current_user["_id"])

    # Add to the user's refresh tokens in the database
    current_app.mongo_db.users.update_one(
        {"_id": current_user["_id"]},
        {"$push": {"refresh_tokens": new_refresh}}
    )
    # Optionally, remove the old refresh token from the database
    current_app.mongo_db.users.update_one(
        {"_id": current_user["_id"]},
        {"$pull": {"refresh_tokens": refresh_token}}
    )
    # Optionally, you can also blacklist the old refresh token
    current_app.mongo_db.users.update_one(
        {"_id": current_user["_id"]},
        {"$push": {"jwt_blacklist": refresh_token}}
    )

    return jsonify({
        "status": "success",
        "access_token": new_access,
        "refresh_token": new_refresh
    })

@auth_bp.route("/user", methods=["GET"])
@token_required
def get_user_info(current_user):
    # Decrypt the fullname using the SECRET_KEY from current_app.config
    decrypted_fullname = dbdecrypt(current_user["fullname"], current_app.config["SECRET_KEY"])
    if decrypted_fullname is None:
        return jsonify({"status": "error", "error": "Failed to decrypt fullname"}), 500

    user_info = {
        "username": current_user["username"],
        "email": current_user["email"],
        "fullname": decrypted_fullname,
        "joined": current_user["joined"]
    }
    
    return jsonify({"status": "success", "user_info": user_info})

def _generate_alphanumeric_code(length=10):
    """Generates a random alphanumeric string of a given length."""
    characters = string.ascii_letters + string.digits
    return ''.join(random.choice(characters) for i in range(length))

def _send_reset_email(recipient_email, reset_code):
    """Sends the password reset email."""
    sender_email = current_app.config.get("MAIL_SENDER")
    sender_password = current_app.config.get("MAIL_PASSWORD")
    mail_server = current_app.config.get("MAIL_SERVER")
    mail_port = current_app.config.get("MAIL_PORT")
    mail_use_tls = current_app.config.get("MAIL_USE_TLS")
    mail_use_ssl = current_app.config.get("MAIL_USE_SSL") # Consider if you need to use SMTP_SSL directly

    if not all([sender_email, sender_password, mail_server, mail_port]):
        current_app.logger.error("Email configuration missing for password reset.")
        return False

    subject = "Sitemarker Password Reset Request"
    body = f"""
    Hi,

    You recently requested to reset your password for your Sitemarker account.

    Your password reset code is: {reset_code}

    This code is valid for 15 minutes. If you did not request a password reset, please ignore this email.

    Thank you,
    Sitemarker Team
    """

    msg = MIMEText(body)
    msg["Subject"] = subject
    msg["From"] = sender_email
    msg["To"] = recipient_email

    context = ssl.create_default_context()
    
    try:
        with smtplib.SMTP(mail_server, mail_port) as server:
            if mail_use_tls:
                server.starttls(context=context) # Establish secure connection using TLS
            # If mail_use_ssl is True and mail_use_tls is False, it implies
            # a direct SSL connection, which typically uses smtplib.SMTP_SSL
            # on port 465. The current smtplib.SMTP usage with starttls is for port 587.
            # Adjust if your email provider requires direct SSL (port 465)
            server.login(sender_email, sender_password)
            server.send_message(msg)
            server.quit()
        current_app.logger.info(f"Password reset email sent to {recipient_email}")
        return True
    except Exception as e:
        current_app.logger.error(f"Failed to send password reset email to {recipient_email}: {e}")
        return False

# --- Password Reset Routes ---

@auth_bp.route("/request_password_reset", methods=["POST"])
def request_password_reset():
    data = request.json
    identifier = data.get("identifier") # Can be email or username

    if not identifier:
        return jsonify({"status": "error", "error": "Email or username is required"}), 400
    
    # Check if an existing request is already in progress
    existing_request = current_app.mongo_db.users.find_one({
        "$or": [
            {"username": identifier},
            {"email": identifier}
        ],
        "reset_token": {"$exists": True},
        "reset_token_expires": {"$gt": datetime.datetime.now()} # Token must not be expired
    })
    if existing_request:
        return jsonify({"status": "error", "error": "A password reset request is already in progress. Please check your email."}), 400

    query = {"$or": [{"username": identifier}, {"email": identifier}]}
    user = current_app.mongo_db.users.find_one(query)

    if not user:
        # For security, return a generic success message even if user not found
        # to avoid leaking information about valid emails/usernames.
        return jsonify({"status": "success", "message": "If an account with provided username/email exists, a password reset code has been sent."}), 200

    reset_code = _generate_alphanumeric_code(10)
    # Set expiration for 15 minutes from now
    expiration_time = datetime.datetime.now() + datetime.timedelta(minutes=15)

    # Store the reset code and its expiration in the user's document
    current_app.mongo_db.users.update_one(
        {"_id": user["_id"]},
        {"$set": {
            "reset_token": reset_code,
            "reset_token_expires": expiration_time
        }}
    )

    # Send the email
    if _send_reset_email(user["email"], reset_code):
        return jsonify({"status": "success", "message": "If an account with that username/email exists, a password reset code has been sent."}), 200
    else:
        current_app.logger.error(f"Failed to send reset email for user {user['username']}")
        return jsonify({"status": "error", "error": "Failed to send password reset email. Please try again later."}), 500

@auth_bp.route("/reset_password", methods=["POST"])
def reset_password():
    data = request.json
    identifier = data.get("identifier") # Email or username
    reset_code = data.get("reset_code")
    new_password = data.get("new_password")
    confirm_new_password = data.get("confirm_new_password")

    if not all([identifier, reset_code, new_password, confirm_new_password]):
        return jsonify({"status": "error", "error": "Missing required fields"}), 400

    if new_password != confirm_new_password:
        return jsonify({"status": "error", "error": "Passwords mismatch"}), 400

    query = {
        "$or": [{"username": identifier}, {"email": identifier}],
        "reset_token": reset_code,
        "reset_token_expires": {"$gt": datetime.datetime.now()} # Token must not be expired
    }
    user = current_app.mongo_db.users.find_one(query)

    if not user:
        return jsonify({"status": "error", "error": "Invalid or expired reset code, or incorrect identifier."}), 400

    # Hash the new password
    hashed_new_password = generate_password_hash(new_password)

    # Update the user's password and clear the reset token fields
    current_app.mongo_db.users.update_one(
        {"_id": user["_id"]},
        {"$set": {
            "password": hashed_new_password,
            "reset_token": None,          # Clear the token
            "reset_token_expires": None   # Clear expiration
        }}
    )

    return jsonify({"status": "success", "message": "Password has been reset successfully."}), 200

@auth_bp.route("/change_password", methods=["POST"])
@token_required
def change_password(current_user):
    """
    Allows an authenticated user to change their password.
    Requires current password for verification.
    """
    data = request.json
    current_password = data.get("current_password")
    new_password = data.get("new_password")
    confirm_new_password = data.get("confirm_new_password")

    if not all([current_password, new_password, confirm_new_password]):
        return jsonify({"status": "error", "error": "Missing required fields"}), 400

    if new_password != confirm_new_password:
        return jsonify({"status": "error", "error": "New passwords mismatch"}), 400

    # Verify current password
    if not check_password_hash(current_user["password"], current_password):
        return jsonify({"status": "error", "error": "Incorrect current password"}), 401

    # Hash the new password
    hashed_new_password = generate_password_hash(new_password)

    # Update the user's password in the database
    current_app.mongo_db.users.update_one(
        {"_id": current_user["_id"]},
        {"$set": {"password": hashed_new_password}}
    )

    # Optional: Invalidate all existing JWTs and refresh tokens for security
    # This forces the user to log in again with the new password on all devices.
    current_app.mongo_db.users.update_one(
        {"_id": current_user["_id"]},
        {"$set": {"jwt_blacklist": [], "refresh_tokens": []}} # Clear all tokens
    )
    # Note: If you clear tokens, the current request's token will still be valid
    # for this response, but subsequent requests will fail.
    # A more robust approach might be to issue a new token here, or simply
    # let the client know they need to re-authenticate.

    return jsonify({"status": "success", "message": "Password changed successfully. Please log in again with your new password."}), 200


@auth_bp.route("/change_email", methods=["POST"])
@token_required
def change_email(current_user):
    """
    Allows an authenticated user to change their email address.
    Requires current password for verification.
    """
    data = request.json
    new_email = data.get("new_email")
    password = data.get("password") # Current password for verification

    if not all([new_email, password]):
        return jsonify({"status": "error", "error": "Missing required fields"}), 400

    if not validators.email(new_email):
        return jsonify({"status": "error", "error": "Invalid new email format"}), 400

    # Verify current password
    if not check_password_hash(current_user["password"], password):
        return jsonify({"status": "error", "error": "Incorrect password"}), 401

    # Check if the new email is already registered by another user
    if current_app.mongo_db.users.find_one({"email": new_email, "_id": {"$ne": current_user["_id"]}}):
        return jsonify({"status": "error", "error": "New email is already registered by another account"}), 409 # Conflict

    # Update the user's email in the database
    current_app.mongo_db.users.update_one(
        {"_id": current_user["_id"]},
        {"$set": {"email": new_email}}
    )

    return jsonify({"status": "success", "message": "Email address changed successfully."}), 200
