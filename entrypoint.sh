#!/bin/sh

# Exit immediately if a command exits with a non-zero status
set -e

# Function to check if the database is up and running
wait_for_db() {
    until mysql -h "$MYSQL_HOST" -P "$MYSQL_PORT" -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -e "SELECT 1" > /dev/null 2>&1; do
        echo "Waiting for the database to be ready..."
        sleep 3
    done
}

# Wait for the database to be ready
echo "Checking if the database is ready..."
wait_for_db
echo "Database is ready!"

# Apply database migrations
echo "Applying database migrations..."
python manage.py makemigrations --noinput
python manage.py migrate --noinput

# Collect static files
echo "Collecting static files..."
python manage.py collectstatic --noinput

# Create superuser if it doesn't already exist
echo "Creating superuser..."
python manage.py create_admin

# Start server
echo "Starting server..."
exec "$@"
