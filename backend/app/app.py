# app/app.py
from app import create_app

# Create the Flask application instance by calling the factory function
app = create_app()

if __name__ == '__main__':
    print("Starting Flask application...")
    app.run(debug=True, host='0.0.0.0', port=5000)