# Use an official Python runtime as a parent image
FROM python:3.12-slim

WORKDIR /var/www/html/

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Install system dependencies including pkg-config
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       gcc libc-dev pkg-config \
       default-mysql-client \
       libmariadb-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install pip and virtualenv
RUN pip install --upgrade pip

# Copy the requirements file into the container at /app
COPY requirements.txt .

# Install Python dependencies from requirements.txt
RUN pip install -r requirements.txt

# Copy the current directory contents into the container at /app
COPY . .

# Copy entrypoint.sh
COPY entrypoint.sh /var/www/html/entrypoint.sh

# Ensure the entrypoint script is executable
RUN chmod +x /var/www/html/entrypoint.sh

# Expose port 8000 to allow communication to/from server
EXPOSE 8000

# Set the entrypoint script
ENTRYPOINT ["/var/www/html/entrypoint.sh"]

# Run the Django development server
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
