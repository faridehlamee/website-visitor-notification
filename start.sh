#!/bin/bash

echo "🚀 Starting Visitor Notification Service with Docker..."
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first:"
    echo "   https://www.docker.com/products/docker-desktop"
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo "❌ Docker Compose is not installed."
    exit 1
fi

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo "📝 Creating .env file with default values..."
    echo "N8N_PASSWORD=changeme123" > .env
    echo "N8N_HOST=localhost" >> .env
    echo "WEBHOOK_URL=http://localhost:5678" >> .env
    echo "✅ Created .env file. ⚠️  Please change the default password!"
fi

# Start services
echo "🐳 Starting Docker containers..."
docker-compose up -d

echo ""
echo "✅ Services started!"
echo ""
echo "📋 Access your services:"
echo "   • n8n Dashboard: http://localhost:5678"
echo "   • Your Website:  http://localhost:8080"
echo ""
echo "🔐 Default login (CHANGE THIS in .env file!):"
echo "   Username: admin"
echo "   Password: changeme123"
echo ""
echo "📚 Next steps:"
echo "   1. Open http://localhost:5678 and login"
echo "   2. Import n8n-workflow.json"
echo "   3. Configure email settings"
echo "   4. Update webhook URL in index.html"
echo "   5. See DOCKER_SETUP.md for detailed instructions"
echo ""
echo "📖 View logs: docker-compose logs -f"
echo "🛑 Stop services: docker-compose down"

