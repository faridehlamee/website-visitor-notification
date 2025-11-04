# Docker Setup Guide for Visitor Notification Service

This guide will help you run the entire visitor notification service using Docker, including both n8n and your website.

## Prerequisites

1. **Docker** installed on your system
   - Download: https://www.docker.com/products/docker-desktop
   - Or install Docker Engine for Linux

2. **Docker Compose** (usually included with Docker Desktop)
   - Verify: Run `docker-compose --version` in terminal

3. **Email Account** (for sending notifications)
   - Use your existing Gmail, Outlook, or any SMTP-enabled email

## Quick Start

### Step 1: Update Webhook URL in HTML

Before starting, you need to update the webhook URL in `index.html`:

1. Open `index.html`
2. Find the line: `const webhookUrl = 'YOUR_N8N_WEBHOOK_URL';`
3. For local development, use: `http://localhost:5678/webhook/visitor-notification`
4. For production (with domain), use: `http://your-domain.com:5678/webhook/visitor-notification`
5. Save the file

**Note**: After you activate the n8n workflow, you'll get the exact webhook URL. Update it then.

### Step 2: Configure Environment Variables (Optional)

Create a `.env` file in the project directory (optional, for custom settings):

```bash
# n8n Configuration
N8N_PASSWORD=your-secure-password-here
N8N_HOST=localhost
WEBHOOK_URL=http://localhost:5678

# Or for production with domain:
# N8N_HOST=your-domain.com
# WEBHOOK_URL=http://your-domain.com:5678
```

If you don't create `.env`, the defaults will be used (no basic auth - you'll create your account on first visit).

### Step 3: Start the Services

Open terminal in the project directory and run:

```bash
docker-compose up -d
```

This will:
- Download n8n image (first time only)
- Build the website container
- Start both services in the background

### Step 4: Access the Services

Once started, access:

- **n8n Dashboard**: http://localhost:5678
  - **First time setup**: n8n will prompt you to create your admin account
  - Enter your **email address** and choose a password
  - This will be your admin account for n8n

- **Your Website**: http://localhost:8080
  - Your HTML page will be accessible here

### Step 5: Create Your Admin Account (First Time Only)

1. Open http://localhost:5678 in your browser
2. You'll see a setup screen to create your first admin account
3. Enter:
   - **Email**: Your email address (e.g., `your-email@example.com`)
   - **Password**: Choose a secure password
   - **First Name**: Your first name
   - **Last Name**: Your last name
4. Click **"Create account"** or **"Sign up"**
5. You'll be logged in automatically

### Step 6: Import and Configure n8n Workflow

1. Once logged in to n8n
2. Click **"Workflows"** → **"Import from File"**
3. Select `n8n-workflow.json` from this project
4. The workflow will be imported

### Step 7: Configure Email in n8n

1. Click on the **"Send Email"** node in the workflow
2. Click **"Credential to connect with"** → **"Create New Credential"**
3. Choose **"SMTP"** and fill in:
   - **User**: Your email address
   - **Password**: 
     - **For Gmail**: You MUST use an App Password (not your regular password)
       - Enable 2-Step Verification in your Google Account
       - Go to App Passwords: https://myaccount.google.com/apppasswords
       - Generate a new app password and use it here
     - **For other providers**: Your email password
   - **Host**: 
     - Gmail: `smtp.gmail.com`
     - Outlook: `smtp-mail.outlook.com`
     - Yahoo: `smtp.mail.yahoo.com`
   - **Port**: 
     - Gmail: `587`
     - Outlook: `587`
     - Yahoo: `587`
   - **Secure**: Choose `TLS`
   - **Client Host Name**: Leave blank (or use `localhost` if required)
4. Update **"From Email"** and **"To Email"** fields

**Important for Gmail**: If you get "Couldn't connect" error:
- Make sure you're using an App Password, not your regular Gmail password
- Enable 2-Step Verification first
- Leave Client Host Name blank

### Step 8: Get Webhook URL and Update HTML

1. In n8n, click on the **"Webhook"** node
2. Click **"Test"** button or **"Execute Node"**
3. Copy the **Webhook URL** shown (e.g., `http://localhost:5678/webhook/visitor-notification`)
4. Open `index.html`
5. Replace `YOUR_N8N_WEBHOOK_URL` with your actual webhook URL
6. Save the file
7. Rebuild the website container:

```bash
docker-compose up -d --build website
```

### Step 9: Activate the Workflow

1. In n8n workflow, toggle the **"Active"** switch (top right)
2. It should turn green - your workflow is now live!

### Step 10: Test It!

1. Visit http://localhost:8080 in your browser
2. Check your email - you should receive a notification!
3. If it works, you're all set! 🎉

## Docker Commands Reference

### Start services
```bash
docker-compose up -d
```

### Stop services
```bash
docker-compose down
```

### View logs
```bash
# All services
docker-compose logs -f

# Just n8n
docker-compose logs -f n8n

# Just website
docker-compose logs -f website
```

### Restart services
```bash
docker-compose restart
```

### Rebuild after changes
```bash
# Rebuild and restart all
docker-compose up -d --build

# Rebuild just website (after editing index.html)
docker-compose up -d --build website
```

### Stop and remove everything (keeps data)
```bash
docker-compose down
```

### Stop and remove everything including data
```bash
docker-compose down -v
```

## Production Deployment

For production use on a server:

### 1. Update `.env` file:
```bash
N8N_PASSWORD=your-very-secure-password
N8N_HOST=yourdomain.com
WEBHOOK_URL=http://yourdomain.com:5678
```

### 2. Update `docker-compose.yml` ports:
```yaml
ports:
  - "80:5678"  # Or use reverse proxy (recommended)
```

### 3. Use Reverse Proxy (Recommended)

Use Nginx or Traefik as reverse proxy:
- Expose ports 80/443 only
- Route `/webhook` to n8n
- Route `/` to website
- Add SSL certificates

### 4. Security Considerations

- **Change default password** in `.env`
- Use HTTPS in production
- Configure firewall rules
- Use reverse proxy for better security
- Limit access to n8n dashboard

## Troubleshooting

### n8n not accessible
- Check if port 5678 is already in use: `netstat -an | grep 5678`
- Change port in `docker-compose.yml` if needed
- Check logs: `docker-compose logs n8n`

### Website not loading
- Check if port 8080 is available
- View logs: `docker-compose logs website`
- Verify `index.html` was copied correctly

### Email not sending
- Verify SMTP credentials in n8n
- Check n8n execution logs for errors
- For Gmail, make sure App Password is used (not regular password)

### Webhook not working
- Ensure workflow is activated (green toggle)
- Verify webhook URL in `index.html` matches n8n webhook URL
- Check browser console for CORS errors
- Check n8n logs: `docker-compose logs n8n`

### Container won't start
- Check Docker is running: `docker ps`
- View logs: `docker-compose logs`
- Try removing and recreating: `docker-compose down && docker-compose up -d`

## Data Persistence

Your n8n workflows and data are stored in a Docker volume named `n8n_data`. This means:
- ✅ Your data persists even if you restart containers
- ✅ Workflows are saved automatically
- ⚠️ Backup the volume if needed: `docker volume inspect visitor-notification-service_n8n_data`

## Port Configuration

Default ports:
- **5678**: n8n dashboard
- **8080**: Website

To change ports, edit `docker-compose.yml`:
```yaml
ports:
  - "YOUR_PORT:5678"  # n8n
  - "YOUR_PORT:80"    # website
```

## Next Steps

1. ✅ Set up Docker and start services
2. ✅ Import workflow to n8n
3. ✅ Configure email settings
4. ✅ Update webhook URL in HTML
5. ✅ Test the service
6. 🚀 Deploy to production server (optional)

Need help? Check the main [README.md](README.md) for more details!

