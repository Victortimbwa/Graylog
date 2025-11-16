#!/bin/bash
# Quick start script for Graylog deployment

set -e

echo "======================================"
echo "Graylog Docker Deployment Setup"
echo "======================================"
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Error: Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is available
if ! docker compose version &> /dev/null; then
    echo "Error: Docker Compose is not available. Please install Docker Compose v2."
    exit 1
fi

# Check if .env file exists
if [ ! -f .env ]; then
    echo "Creating .env file from .env.example..."
    cp .env.example .env
    echo ""
    echo "⚠️  IMPORTANT: Please edit the .env file and update the following:"
    echo "   - MONGO_ROOT_PASSWORD"
    echo "   - GRAYLOG_PASSWORD_SECRET"
    echo "   - GRAYLOG_ROOT_PASSWORD_SHA2"
    echo "   - GRAYLOG_HTTP_EXTERNAL_URI"
    echo ""
    echo "Generate password secret with: pwgen -N 1 -s 96"
    echo "Generate password hash with: echo -n 'yourpassword' | sha256sum"
    echo ""
    read -p "Press Enter to continue after updating .env file..."
fi

# Start services
echo ""
echo "Starting Graylog services..."
docker compose up -d

echo ""
echo "======================================"
echo "Deployment Status"
echo "======================================"
docker compose ps

echo ""
echo "======================================"
echo "Graylog is starting up!"
echo "======================================"
echo ""
echo "Please wait 1-2 minutes for all services to be fully ready."
echo ""
echo "Access Graylog at: http://localhost:9000"
echo "Default username: admin"
echo "Default password: admin (or the one you configured)"
echo ""
echo "View logs with: docker compose logs -f"
echo "Stop services with: docker compose down"
echo ""
