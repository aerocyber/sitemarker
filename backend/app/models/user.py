# app/models/user.py
from flask import session, current_app, request
from appwrite.services.account import Account
from appwrite.services.users import Users
from appwrite.exception import AppwriteException
from appwrite.id import ID

class AppwriteUser:
    """
    A class to represent the currently authenticated Appwrite user and
    provide methods to interact with the Appwrite Account and Users services
    on their behalf.
    """
    def __init__(self):
        self._get_user_client = current_app.config['GET_APPWRITE_CLIENT_FOR_USER']
        self._get_admin_client = current_app.config['GET_APPWRITE_ADMIN_CLIENT']
        
        self.account_service = Account(self._get_user_client(request))
        self.users_service = Users(self._get_admin_client())
        
        self._user_data = None

    def get_current_user_data(self, force_refresh=False):
        """
        Fetches and caches the current user's data from Appwrite.
        """
        if self._user_data is None or force_refresh:
            try:
                self._user_data = self.account_service.get()
            except AppwriteException as e:
                print(f"Error fetching user data for model: {e}")
                session.pop('appwrite_session_secret', None)
                self._user_data = None
        return self._user_data

    @property
    def is_authenticated(self):
        """Checks if there's an active Appwrite session for the user."""
        return 'appwrite_session_secret' in session and self.get_current_user_data() is not None

    @property
    def id(self):
        """Returns the user's Appwrite ID."""
        user_data = self.get_current_user_data()
        return user_data['$id'] if user_data else None

    @property
    def name(self):
        """Returns the user's name."""
        user_data = self.get_current_user_data()
        return user_data['name'] if user_data else None

    @property
    def email(self):
        """Returns the user's email."""
        user_data = self.get_current_user_data()
        return user_data['email'] if user_data else None

    @property
    def email_verified(self):
        """Returns the user's email verification status."""
        user_data = self.get_current_user_data()
        return user_data['emailVerification'] if user_data else False

    # --- Methods for Account Management (requiring authenticated user client) ---

    def update_name(self, name):
        """Updates the user's display name."""
        res = self.account_service.update_name(name)
        self.get_current_user_data(force_refresh=True)
        return res

    def update_email(self, email, password):
        """Updates the user's email address."""
        res = self.account_service.update_email(email, password)
        self.get_current_user_data(force_refresh=True)
        return res

    def update_password(self, new_password, old_password):
        """Updates the user's password."""
        return self.account_service.update_password(new_password, old_password)

    def list_sessions(self):
        """Lists all active sessions for the current user."""
        return self.account_service.list_sessions()

    def delete_session(self, session_id):
        """Deletes a specific session of the current user."""
        return self.account_service.delete_session(session_id)
    
    # --- Methods for User Management (often requiring admin client) ---

    def create_user_admin(self, email, password, name=''):
        """Creates a new user using the admin Appwrite client."""
        return self.users_service.create(
            user_id=ID.unique(),
            email=email,
            password=password,
            name=name
        )