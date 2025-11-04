# Troubleshooting Guide

## Problem: Hyper-V Setup Error - "Insufficient system resources" or "Unable to allocate 6144 MB of RAM"

**Error Message**: `'DockerDesktopVM' is unable to allocate 6144 MB of RAM: Insufficient system resources exist to complete the requested service.`

This means Docker Desktop needs 6 GB of RAM but your system doesn't have enough available memory.

### Solution 1: Reduce Docker Desktop Memory Allocation (Recommended)

1. **Open Docker Desktop Settings**
   - Right-click Docker Desktop icon in system tray
   - Click "Settings" or "Preferences"

2. **Go to Resources → Advanced**
   - In the left sidebar, click "Resources"
   - Click "Advanced" tab

3. **Reduce Memory Allocation**
   - Find "Memory" slider
   - Reduce from 6144 MB (6 GB) to a lower value:
     - **4 GB (4096 MB)** - Recommended minimum
     - **2 GB (2048 MB)** - If you have limited RAM (may be slow)
   - Click "Apply & Restart"

4. **Wait for Docker to restart**
   - Docker Desktop will restart with new settings
   - Wait until it fully loads

5. **Try starting the service again**
   ```powershell
   .\start.bat
   ```

### Solution 2: Free Up RAM Before Starting Docker

Close memory-intensive applications:
- Web browsers (Chrome, Firefox, etc.) - keep only necessary tabs
- Visual Studio Code or other IDEs
- Games
- Video editors
- Other Docker containers
- Virtual machines

**Check available RAM:**
- Press `Ctrl + Shift + Esc` to open Task Manager
- Click "Performance" tab
- Check "Available" memory
- You need at least **4-6 GB free** for Docker Desktop

### Solution 3: Check Your System RAM

You need at least **8 GB total RAM** to run Docker Desktop comfortably:
- **8 GB total**: Set Docker to 2-3 GB
- **16 GB total**: Set Docker to 4-6 GB
- **32 GB total**: Can use 6-8 GB

**Check your total RAM:**
1. Press `Windows Key + Pause/Break`
2. Or: Settings → System → About
3. Look for "Installed RAM"

### Solution 4: Use WSL 2 Backend Instead of Hyper-V

If you have Windows 10/11 Pro, try switching to WSL 2:

1. **Open Docker Desktop Settings**
2. **Go to General**
3. **Enable "Use the WSL 2 based engine"**
4. **Click "Apply & Restart"**

**Note**: WSL 2 requires WSL to be installed (Docker Desktop can install it automatically).

### Solution 5: Alternative - Use n8n Cloud Instead

If your computer doesn't have enough RAM, consider using n8n Cloud (free tier available):

1. **Sign up at**: https://n8n.io
2. **Use the cloud setup** instead of Docker
3. **Follow the main README.md** for cloud setup instructions
4. **No Docker needed!** - Just upload your HTML to Netlify or similar

This way you don't need to run Docker Desktop on your computer.

### Quick Fix Summary:

```
1. Open Docker Desktop → Settings → Resources → Advanced
2. Reduce Memory from 6144 MB to 4096 MB (or lower)
3. Click "Apply & Restart"
4. Wait for Docker to fully start
5. Run .\start.bat again
```

---

## Problem: "Unable to get image" or "The system cannot find the file specified"

This means **Docker Desktop is not running** or not properly started.

### Solution:

1. **Start Docker Desktop**
   - Look for Docker Desktop in your Start Menu
   - Click to open it
   - Wait for it to fully start (the whale icon in system tray should be steady, not animated)
   - You should see "Docker Desktop is running" in the app

2. **Verify Docker is running**
   ```powershell
   docker ps
   ```
   - If you see a table (even if empty), Docker is running ✅
   - If you get an error, Docker is not running ❌

3. **Restart Docker Desktop** (if needed)
   - Right-click Docker icon in system tray → "Quit Docker Desktop"
   - Wait 10 seconds
   - Start Docker Desktop again
   - Wait for it to fully load

4. **Try the start script again**
   ```powershell
   .\start.bat
   ```

---

## Problem: localhost:5678 shows nothing or connection refused

### Check 1: Are containers running?
```powershell
docker ps
```
You should see two containers:
- `visitor-notification-n8n`
- `visitor-notification-website`

If containers are not running:
```powershell
docker-compose logs -f
```
This shows what went wrong.

### Check 2: Check container status
```powershell
docker-compose ps
```
All services should show "Up" status.

### Check 3: Check n8n logs
```powershell
docker-compose logs n8n
```
Look for any error messages.

---

## Problem: Port already in use

Error: `Bind for 0.0.0.0:5678 failed: port is already allocated`

### Solution:

1. **Find what's using the port:**
   ```powershell
   netstat -ano | findstr :5678
   ```

2. **Change the port in docker-compose.yml:**
   ```yaml
   ports:
     - "5679:5678"  # Changed from 5678:5678
   ```
   Then access at http://localhost:5679

3. **Or stop the conflicting service** if you know what it is

---

## Problem: "version" warning in docker-compose

This is just a warning, not an error. The version field is now optional in newer Docker Compose versions.

**Fixed**: The docker-compose.yml has been updated to remove the version field.

---

## Problem: Can't pull Docker images (network issues)

### Solution:

1. **Check internet connection**
2. **Restart Docker Desktop**
3. **Try manually pulling:**
   ```powershell
   docker pull n8nio/n8n:latest
   docker pull nginx:alpine
   ```

---

## Problem: Email not sending from n8n

### Check n8n execution logs:

1. Open n8n dashboard
2. Go to the workflow
3. Click on "Executions" tab
4. View failed executions
5. Check error messages

### Common email issues:

- **Gmail**: Need to use App Password, not regular password
- **SMTP Settings**: Verify host, port, and secure settings
- **Credentials**: Make sure credentials are saved in n8n

---

## Problem: Website shows error or blank page

### Check website container logs:
```powershell
docker-compose logs website
```

### Rebuild the website:
```powershell
docker-compose up -d --build website
```

---

## Quick Diagnostic Commands

### Check everything is working:
```powershell
# Check Docker is running
docker ps

# Check container status
docker-compose ps

# View all logs
docker-compose logs

# View n8n logs only
docker-compose logs -f n8n

# Restart all services
docker-compose restart

# Stop everything
docker-compose down

# Start everything fresh
docker-compose up -d
```

---

## Still Having Issues?

1. **Verify Docker Desktop is fully started**
   - System tray icon should be steady (not animated)
   - Open Docker Desktop app - should show "Docker Desktop is running"

2. **Check Windows version**
   - Docker Desktop requires Windows 10/11 64-bit
   - WSL 2 must be enabled (Docker Desktop handles this)

3. **Restart your computer**
   - Sometimes Docker needs a full restart to connect properly

4. **Reinstall Docker Desktop** (last resort)
   - Uninstall Docker Desktop
   - Restart computer
   - Reinstall from https://www.docker.com/products/docker-desktop

