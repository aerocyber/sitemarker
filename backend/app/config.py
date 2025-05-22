import os
from dotenv import load_dotenv
load_dotenv()

class Config:
    SECRET_KEY = os.getenv("SECRET_KEY")
    JWT_SECRET = os.getenv("JWT_SECRET")
    JWT_ACCESS_TOKEN_EXPIRES = 604800 # 1 week
    MONGO_URI = os.getenv("MONGO_URI")
    AES_SALT = os.getenv("AES_SALT")
