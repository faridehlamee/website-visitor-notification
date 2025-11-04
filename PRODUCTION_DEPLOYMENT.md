# Production Deployment Guide for www.kiatechsoftware.com

This guide will help you deploy the visitor notification service to your live website.

## Overview

To make this work on `www.kiatechsoftware.com`, you need:
1. ✅ n8n accessible from the internet (not just localhost)
2. ✅ Upload `index.html` to your website
3. ✅ Update webhook URL in `index.html` to point to your public n8n instance

---

## Option 1: Use n8n Cloud (Recommended - Easiest!)

This is the easiest option - n8n Cloud is already accessible from the internet.

### Step 1: Sign up for n8n Cloud
1. Go to https://n8n.io
2. Click "Sign Up" or "Get Started"
3. Create your account (free tier available)
4. You'll get access to `https://your-workspace.n8n.cloud`

### Step 2: Import Workflow to n8n Cloud
1. Log into your n8n Cloud account
2. Click "Workflows" → "Import from File"
3. Select `n8n-workflow.json` from this project
4. The workflow will be imported

### Step 3: Configure Email in n8n Cloud
1. Click on the "Send Email" node
2. Configure your SMTP credentials (same as before)
3. Update "From Email" and "To Email" fields

### Step 4: Get Webhook URL from n8n Cloud
1. Click on the "Webhook" node
2. Click "Test" or "Execute Node"
3. Copy the webhook URL - it will look like:
   ```
   https://your-workspace.n8n.cloud/webhook/visitor-notification
   ```

### Step 5: Update index.html with Cloud Webhook URL
1. Open `index.html`
2. Find line 83: `const webhookUrl = 'http://localhost:5678/webhook/visitor-notification';`
3. Replace it with your n8n Cloud webhook URL:
   ```javascript
   const webhookUrl = 'https://your-workspace.n8n.cloud/webhook/visitor-notification';
   ```
4. Save the file

### Step 6: Upload index.html to Your Website
1. Upload `index.html` to your website server (www.kiatechsoftware.com)
2. Make sure it's accessible at `https://www.kiatechsoftware.com/index.html` (or your homepage)

### Step 7: Activate Workflow
1. In n8n Cloud, toggle the "Active" switch (top right)
2. It should turn green - workflow is now live!

### Step 8: Test
1. Visit `https://www.kiatechsoftware.com`
2. Check your email - you should receive a notification!

---

## Option 2: Deploy Your Own n8n Server (Advanced)

If you want to host n8n yourself on a server:

### Step 1: Deploy n8n to a Server
You have several options:

#### Option A: Deploy to a VPS (DigitalOcean, AWS, etc.)
1. Set up a server (Ubuntu recommended)
2. Install Docker and Docker Compose
3. Upload your `docker-compose.yml` and related files
4. Configure domain name (e.g., `n8n.kiatechsoftware.com`)
5. Set up SSL certificate (Let's Encrypt)
6. Update DNS records

#### Option B: Use Railway, Render, or Fly.io
1. Sign up for a platform service
2. Connect your GitHub repository
3. Deploy using Docker
4. Configure environment variables
5. Set up custom domain

### Step 2: Configure n8n for Public Access
1. Update `docker-compose.yml` environment variables:
   ```yaml
   environment:
     - N8N_HOST=n8n.kiatechsoftware.com  # Your n8n domain
     - N8N_PROTOCOL=https
     - WEBHOOK_URL=https://n8n.kiatechsoftware.com
   ```

2. Set up reverse proxy (Nginx) with SSL:
   ```nginx
   server {
       listen 443 ssl;
       server_name n8n.kiatechsoftware.com;
       
       ssl_certificate /path/to/cert.pem;
       ssl_certificate_key /path/to/key.pem;
       
       location / {
           proxy_pass http://localhost:5678;
           proxy_set_header Host $host;
           proxy_set_header X-Real-IP $remote_addr;
       }
   }
   ```

### Step 3: Get Webhook URL
1. Your webhook URL will be: `https://n8n.kiatechsoftware.com/webhook/visitor-notification`
2. Update `index.html` with this URL

### Step 4: Upload index.html to Website
1. Upload `index.html` to www.kiatechsoftware.com
2. Ensure it's accessible

### Step 5: Test
1. Visit `https://www.kiatechsoftware.com`
2. Check your email!

---

## Quick Checklist for Production

- [ ] n8n is accessible from the internet (n8n Cloud or your own server)
- [ ] Workflow is imported and configured in n8n
- [ ] Email credentials are set up in n8n
- [ ] Webhook URL is copied from n8n
- [ ] `index.html` is updated with the public webhook URL
- [ ] `index.html` is uploaded to www.kiatechsoftware.com
- [ ] Workflow is activated in n8n
- [ ] Tested by visiting the website

---

## Important Notes

### Security
- ✅ Use HTTPS for both your website and n8n webhook
- ✅ Consider adding authentication to webhook if sensitive
- ✅ Use strong passwords for n8n accounts
- ✅ Keep n8n credentials secure

### CORS Issues
If you get CORS errors, you may need to:
1. Configure CORS in n8n (if using your own server)
2. Or use n8n Cloud (handles CORS automatically)

### Testing
- Test locally first with `http://localhost:8080`
- Then test with production webhook URL
- Finally, test on live website

---

## Troubleshooting

### Webhook not receiving requests
- Check webhook URL is correct in `index.html`
- Verify n8n workflow is activated
- Check browser console for errors
- Verify n8n is accessible from the internet

### CORS errors
- n8n Cloud handles CORS automatically
- If using your own server, configure CORS in n8n settings

### Email not sending
- Verify SMTP credentials in n8n
- Check n8n execution logs
- Ensure workflow is activated

---

## Recommended: Use n8n Cloud

For production, I **strongly recommend using n8n Cloud** because:
- ✅ Already accessible from the internet
- ✅ No server setup required
- ✅ Automatic SSL/HTTPS
- ✅ CORS handled automatically
- ✅ Free tier available
- ✅ Easy to use

Just sign up, import workflow, get webhook URL, update `index.html`, and upload to your website!

