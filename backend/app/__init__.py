import os
import pathlib
from flask import Flask, request, session, redirect, url_for, render_template
from appwrite.client import Client
from appwrite.services.account import Account
from appwrite.services.users import Users # You might not need Users service in __init__.py if only used in models
from appwrite.services.databases import Databases
from appwrite.exception import AppwriteException
from dotenv import load_dotenv

# Load environment variables from the project root's .env file
# This should happen before any config tries to access them.
load_dotenv(dotenv_path=pathlib.Path(__file__).resolve().parent / '.env')

# --- Appwrite Configuration and Client/Service Initializers ---
# These functions will be stored in the app.config and are designed
# to be called from within blueprints to get context-aware Appwrite clients.

def get_appwrite_admin_client(app_config):
    """
    Returns an Appwrite Client configured with the API Key (admin mode).
    Takes app_config as an argument to access environment variables.
    """
    client = Client()
    client.set_endpoint(app_config['APPWRITE_ENDPOINT'])
    client.set_project(app_config['APPWRITE_PROJECT_ID'])
    client.set_key(app_config['APPWRITE_API_KEY'])
    return client

def get_appwrite_client_for_user(app_config, req_obj):
    """
    Returns an Appwrite Client configured for a specific user's session.
    It attempts to set the session from Flask session.
    """
    client = Client()
    client.set_endpoint(app_config['APPWRITE_ENDPOINT'])
    client.set_project(app_config['APPWRITE_PROJECT_ID'])

    # Set session if available in Flask session
    if 'appwrite_session_secret' in session:
        client.set_session(session['appwrite_session_secret'])

    
    return client

def create_app():
    """Application factory function to create and configure the Flask app."""
    app = Flask(__name__, instance_relative_config=True)

    # Load configuration from environment variables
    app.config.from_mapping(
        SECRET_KEY=os.getenv('FLASK_SECRET_KEY'),
        APPWRITE_ENDPOINT=os.getenv('APPWRITE_ENDPOINT'),
        APPWRITE_PROJECT_ID=os.getenv('APPWRITE_PROJECT_ID'),
        APPWRITE_API_KEY=os.getenv('APPWRITE_API_KEY'),
        APPWRITE_DATABASE_ID=os.getenv('APPWRITE_DATABASE_ID'),
        APPWRITE_COLLECTION_ID=os.getenv('APPWRITE_COLLECTION_ID'),
        APPWRITE_PREFS_COLLECTION_ID=os.getenv('APPWRITE_PREFS_COLLECTION_ID')
    )

    # Basic validation for essential environment variables
    required_vars = [
        'SECRET_KEY', 'APPWRITE_ENDPOINT', 'APPWRITE_PROJECT_ID',
        'APPWRITE_API_KEY', 'APPWRITE_DATABASE_ID', 'APPWRITE_COLLECTION_ID',
        'APPWRITE_PREFS_COLLECTION_ID'
    ]
    for var_name in required_vars:
        if not app.config.get(var_name):
            raise RuntimeError(f"Environment variable '{var_name}' is not set. Please check your .env file.")

    # Store Appwrite client/service initializers in app.config for access from blueprints.
    # We pass 'app.config' as a partial function to ensure it has access to the config.
    app.config['GET_APPWRITE_ADMIN_CLIENT'] = lambda: get_appwrite_admin_client(app.config)
    app.config['GET_APPWRITE_CLIENT_FOR_USER'] = lambda req: get_appwrite_client_for_user(app.config, req)

    # --- Register Blueprints ---
    # Import your route modules from the 'routes' package
    from .routes import auth, sync
    app.register_blueprint(auth.bp, url_prefix='/auth')
    app.register_blueprint(sync.bp, url_prefix='/sync')

    # --- Global Hooks/Middleware ---
    @app.before_request
    def check_authentication():
        """
        Global middleware to check authentication for protected routes.
        This will apply to all blueprints unless specifically excluded.
        """
        # Define routes that do NOT require authentication, even if they are under blueprints.
        # Use blueprint_name.endpoint_name for blueprint routes.
        public_endpoints = [
            'auth.signin', 'auth.signup', 'auth.magic_url_login', 'auth.verify_magic_url',
            'auth.resetpswd', # reset password initial request
            'static', # Flask's static files
            'index', # The root homepage
            'privacy', # Privacy policy page
            'about', # About page
            'not_found' # 404 page
        ]

        # If the endpoint is a public one, allow access
        if request.endpoint in public_endpoints:
            return

        # If it's a POST request to a login-related endpoint, allow it to proceed
        # to prevent infinite redirect loops. The blueprint's route will handle validation.
        # This is particularly important for form submissions to login/signup.
        if request.method == 'POST' and request.endpoint in ['auth.signin', 'auth.signup', 'auth.magic_url_login', 'auth.resetpswd']:
            return

        # For all other routes, check for an active Appwrite session
        if 'appwrite_session_secret' not in session:
            print(f"Unauthorized access to {request.path}. Redirecting to login.") # TODO: Use logging instead of print in production
            # Redirect to the sign-in page if not authenticated
            return redirect(url_for('auth.signin'))

    # --- Root Routes ---
    @app.route('/')
    def index():
        """Main homepage. Displays user info if logged in, otherwise links to login/signup."""
        user_info = None
        if 'appwrite_session_secret' in session:
            try:
                # Use the helper from app.config to get the user-specific client
                account = Account(app.config['GET_APPWRITE_CLIENT_FOR_USER'](request))
                user_info = account.get()
            except AppwriteException as e:
                print(f"Session expired or invalid at index: {e}")
                session.pop('appwrite_session_secret', None) # Clear invalid session
                user_info = None # Clear user info
        return render_template('index.html', user=user_info)

    @app.route('/privacy')
    def privacy():
        """Privacy policy page."""
        return render_template('privacy.html')

    @app.route('/about')
    def about():
        """About us page."""
        return render_template('about.html')

    @app.errorhandler(404)
    def not_found(error):
        """Custom 404 error page."""
        return render_template('404.html'), 404

    return app