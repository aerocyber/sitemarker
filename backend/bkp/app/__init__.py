import os
from flask import Flask, current_app # Import current_app for accessing DB
from flask_cors import CORS
from dotenv import load_dotenv
from pymongo import MongoClient # Change: Import MongoClient from pymongo
from pymongo import ASCENDING, DESCENDING
from app.config import Config

# Change: Remove the global PyMongo instance.
# The MongoClient instance will be created inside create_app and attached to `app`.

def create_app():
    load_dotenv()

    app = Flask(__name__)
    app.config.from_object(Config)

    # --- Start: MongoClient Setup ---
    try:
        # Get MONGO_URI from app.config (which is loaded from Config class)
        mongo_uri = app.config['MONGO_URI']
        if not mongo_uri:
            raise ValueError("MONGO_URI is not set in application configuration.")

        # Create MongoClient instance and attach it to the app
        app.mongo_client = MongoClient(mongo_uri)
        # Get the default database from the URI.
        # Assuming the database name is part of your MONGO_URI (e.g., ...mongodb.net/your_db_name?...)
        app.mongo_db = app.mongo_client[os.getenv('MONGO_DB', 'sitemarker-db')]
        print("DEBUG: MongoDB MongoClient connected successfully.")

    except Exception as e:
        print(f"ERROR: Exception during MongoDB MongoClient initialization: {e}")
        # Ensure client and db are None if connection fails
        app.mongo_client = None 
        app.mongo_db = None
        
    # --- End: MongoClient Setup ---

    # --- Start: Collection and Index Creation ---
    # This logic now uses app.mongo_db instead of mongo.db
    with app.app_context():
        if app.mongo_db is not None: # Only proceed if database connection was successful
            try:
                existing_collections = app.mongo_db.list_collection_names()

                # Users Collection and Indexes
                if 'users' not in existing_collections:
                    app.mongo_db.create_collection('users')
                    print("Created 'users' collection.")
                
                if 'username_1' not in app.mongo_db.users.index_information():
                    app.mongo_db.users.create_index("username", unique=True)
                    print("Created unique index on 'username' for 'users' collection.")
                if 'email_1' not in app.mongo_db.users.index_information():
                    app.mongo_db.users.create_index("email", unique=True, sparse=True)
                    print("Created unique index on 'email' for 'users' collection.")
                
                # Devices Collection and Indexes
                if 'devices' not in existing_collections:
                    app.mongo_db.create_collection('devices')
                    print("Created 'devices' collection.")
                
                if 'sync_id_1' not in app.mongo_db.devices.index_information():
                    app.mongo_db.devices.create_index("sync_id", unique=True)
                    print("Created unique index on 'sync_id' for 'devices' collection.")
                if 'user_id_1' not in app.mongo_db.devices.index_information():
                    app.mongo_db.devices.create_index("user_id")
                    print("Created index on 'user_id' for 'devices' collection.")


                # Sync Data Collection and Indexes
                if 'sync_data' not in existing_collections:
                    app.mongo_db.create_collection('sync_data')
                    print("Created 'sync_data' collection.")

                if 'user_id_1' not in app.mongo_db.sync_data.index_information():
                    app.mongo_db.sync_data.create_index("user_id")
                    print("Created index on 'user_id' for 'sync_data' collection.")
                
                if 'user_id_1_modified_at_-1' not in app.mongo_db.sync_data.index_information():
                    app.mongo_db.sync_data.create_index([("user_id", ASCENDING), ("modified_at", DESCENDING)])
                    print("Created compound index on 'user_id' and 'modified_at' for 'sync_data' collection.")

            except Exception as e:
                print(f"Error creating collections or indexes: {e}")
        else:
            print("Skipping collection/index creation: MongoDB connection failed in app context.")
    # --- End: Collection and Index Creation ---


    # --- Start: CORS Configuration (Simplified to default) ---
    print("CORS: Initializing with default permissive settings (assuming same-domain content loading).")
    CORS(app) 
    # --- End: CORS Configuration ---

    from app.routes.auth import auth_bp
    from app.routes.sync import sync_bp

    app.register_blueprint(auth_bp, url_prefix='/api/auth')
    app.register_blueprint(sync_bp, url_prefix='/api/sync')

    return app