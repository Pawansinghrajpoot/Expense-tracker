FROM python:3.9-slim

# Set environment variables for better performance and debugging
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Install system dependencies (including unzip for AWS CLI)
RUN apt-get update \
    && apt-get install -y \
    gcc \
    libpq-dev \
    curl \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install AWS CLI (Optional, for AWS-related tasks like managing S3)
RUN curl "https://d1vvhvl2y92vvt.cloudfront.net/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf aws awscliv2.zip

# Set work directory in the container
WORKDIR /app

# Copy requirements file and install dependencies
COPY requirements.txt /app/
RUN pip install --upgrade pip && pip install -r requirements.txt

# Copy the rest of the application code into the container
COPY . /app/

# Expose port 8000 (standard Django port)
EXPOSE 8000

# Optional: Environment variable for AWS credentials
# ENV AWS_ACCESS_KEY_ID=your-access-key-id
# ENV AWS_SECRET_ACCESS_KEY=your-secret-access-key
# ENV AWS_DEFAULT_REGION=us-east-1

# Run the Django development server
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
