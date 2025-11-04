@echo off
echo 🚀 Starting Visitor Notification Service with Docker...
echo.

REM Check if Docker is installed
docker --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker is not installed. Please install Docker Desktop first:
    echo    https://www.docker.com/products/docker-desktop
    pause
    exit /b 1
)

REM Check if Docker is running
echo 🔍 Checking if Docker Desktop is running...
docker ps >nul 2>&1
if errorlevel 1 (
    echo.
    echo ❌ ERROR: Docker Desktop is not running!
    echo.
    echo 📋 Please do the following:
    echo    1. Open Docker Desktop application
    echo    2. Wait for it to fully start (whale icon in system tray should be steady)
    echo    3. Run this script again
    echo.
    echo 💡 Tip: Look for Docker Desktop in your Start Menu or System Tray
    pause
    exit /b 1
)
echo ✅ Docker Desktop is running!
echo.

REM Create .env file if it doesn't exist
if not exist .env (
    echo 📝 Creating .env file with default values...
    (
        echo N8N_PASSWORD=changeme123
        echo N8N_HOST=localhost
        echo WEBHOOK_URL=http://localhost:5678
    ) > .env
    echo ✅ Created .env file. ⚠️  Please change the default password!
)

REM Start services
echo 🐳 Starting Docker containers...
docker-compose up -d

echo.
echo ✅ Services started!
echo.
echo 📋 Access your services:
echo    • n8n Dashboard: http://localhost:5678
echo    • Your Website:  http://localhost:8080
echo.
echo 🔐 Default login (CHANGE THIS in .env file!):
echo    Username: admin
echo    Password: changeme123
echo.
echo 📚 Next steps:
echo    1. Open http://localhost:5678 and login
echo    2. Import n8n-workflow.json
echo    3. Configure email settings
echo    4. Update webhook URL in index.html
echo    5. See DOCKER_SETUP.md for detailed instructions
echo.
echo 📖 View logs: docker-compose logs -f
echo 🛑 Stop services: docker-compose down
echo.
pause

