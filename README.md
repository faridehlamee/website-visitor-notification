# Visitor Notification Service with n8n

This project creates a visitor notification service that automatically sends you an email whenever someone visits your website. The email includes the visitor's IP address and location information.

## Features

- 🔔 Real-time email notifications when someone visits your website
- 🌍 Automatic IP geolocation (City, Region, Country)
- 📊 Additional visitor information (User Agent, Referrer, Timestamp, ISP)
- 🎨 Beautiful HTML email template
- 📱 Works on all devices and browsers

## Prerequisites

**👉 Need help creating accounts? See [ACCOUNTS_NEEDED.md](ACCOUNTS_NEEDED.md) for a complete guide!**

**🐳 Want to use Docker? See [DOCKER_SETUP.md](DOCKER_SETUP.md) for complete Docker instructions!**

### Option 1: Docker Setup (Recommended for Self-Hosting)
- **Docker** and **Docker Compose** installed
- **Email Account** for sending notifications
- See [DOCKER_SETUP.md](DOCKER_SETUP.md) for full guide
- ✅ Runs everything locally - no cloud accounts needed!

### Option 2: Cloud Setup
1. **n8n Account** (FREE tier available)
   - Create account at https://n8n.io (recommended)
   - Or self-host n8n via npm/Docker

2. **Email Account** (Use your existing email)
   - Any email with SMTP (Gmail, Outlook, Yahoo, etc.)
   - Gmail users may need to create an App Password

3. **Website Hosting** (FREE options available)
   - Netlify (easiest - just drag and drop)
   - GitHub Pages, Vercel, or your own server

## Setup Instructions

### 🐳 Docker Quick Start (Easiest!)

If you want to run everything locally with Docker:

1. **Install Docker** from https://www.docker.com/products/docker-desktop
2. **Run**: `docker-compose up -d`
3. **Access n8n**: http://localhost:5678 (login: admin/changeme123)
4. **Access website**: http://localhost:8080
5. Follow the detailed guide in [DOCKER_SETUP.md](DOCKER_SETUP.md)

### ☁️ Cloud Setup Instructions

### Step 1: Import the n8n Workflow

1. Open your n8n instance (either cloud or localhost)
2. Click on "Workflows" → "Import from File"
3. Select the `n8n-workflow.json` file from this project
4. The workflow will be imported with all nodes configured

### Step 2: Configure Email Settings

1. In the n8n workflow, click on the **"Send Email"** node
2. Click on **"Credential to connect with"** → **"Create New Credential"**
3. Choose **"SMTP"** and fill in:
   - **User**: Your email address
   - **Password**: Your email password (or App Password for Gmail)
   - **Host**: SMTP server (e.g., `smtp.gmail.com` for Gmail)
   - **Port**: SMTP port (e.g., `587` for Gmail)
   - **Secure**: Choose TLS or SSL based on your email provider

4. Update the **"From Email"** field to your email address
5. Update the **"To Email"** field to where you want to receive notifications

### Step 3: Activate the Webhook

1. Click on the **"Webhook"** node in your workflow
2. Click **"Listen for Test Event"** or **"Test"** button
3. Copy the **Webhook URL** that appears (it will look like: `https://your-n8n-instance.com/webhook/visitor-notification`)
4. **Keep this URL handy** - you'll need it for the next step

### Step 4: Update the HTML Page

1. Open `index.html` in a text editor
2. Find the line: `const webhookUrl = 'YOUR_N8N_WEBHOOK_URL';`
3. Replace `'YOUR_N8N_WEBHOOK_URL'` with your actual webhook URL from Step 3
4. Save the file

Example:
```javascript
const webhookUrl = 'https://n8n.yoursite.com/webhook/visitor-notification';
```

### Step 5: Deploy Your HTML Page

You can deploy your HTML page in several ways:

#### Option A: GitHub Pages (Free)
1. Create a GitHub repository
2. Upload `index.html` to the repository
3. Go to Settings → Pages
4. Enable GitHub Pages and select your branch
5. Your site will be available at `https://yourusername.github.io/repository-name`

#### Option B: Netlify (Free)
1. Go to https://netlify.com
2. Drag and drop your `index.html` file
3. Your site will be instantly deployed
4. You can customize the domain name

#### Option C: Vercel (Free)
1. Go to https://vercel.com
2. Import your project or upload the HTML file
3. Deploy instantly

#### Option D: Your Own Server
1. Upload `index.html` to your web server
2. Make sure it's accessible via HTTP/HTTPS

### Step 6: Activate the Workflow

1. Go back to your n8n workflow
2. Toggle the **"Active"** switch at the top right (it should be green)
3. Your workflow is now live and listening for webhook requests!

## Testing

1. Visit your deployed HTML page in a browser
2. Check your email inbox - you should receive a notification within seconds
3. The email will contain:
   - IP Address
   - Location (City, Region, Country)
   - Coordinates (Latitude, Longitude)
   - ISP (Internet Service Provider)
   - User Agent (Browser and OS information)
   - Referrer (Where they came from)
   - Timestamp

## How It Works

1. **Visitor opens your website** → The HTML page loads
2. **JavaScript executes** → Gets the visitor's IP address from ipify.org
3. **Data sent to webhook** → POST request to your n8n webhook endpoint
4. **n8n workflow processes**:
   - Receives webhook data
   - Extracts IP address
   - Gets location information from IP-API.com
   - Formats the email with all information
   - Sends email notification
5. **You receive email** → With all visitor details!

## Customization

### Change Email Template
- Edit the **"Send Email"** node in n8n
- Modify the HTML content in the `message` field
- You can use n8n expressions like `{{ $json.ipAddress }}` to insert data

### Add More Information
- Modify `index.html` to collect additional data (screen size, timezone, etc.)
- Add more fields in the **"Set Visitor Data"** node
- Update the email template to display new fields

### Change Geolocation Service
- Currently uses IP-API.com (free, 45 requests/minute limit)
- You can replace it with other services like:
  - ipapi.co
  - ipgeolocation.io
  - ip-api.com (paid plans for higher limits)

## Troubleshooting

### Email Not Received
- Check your spam folder
- Verify SMTP credentials are correct
- Make sure the workflow is activated (green toggle)
- Check n8n execution logs for errors

### Webhook Not Working
- Ensure the workflow is activated
- Check that the webhook URL is correct in `index.html`
- Verify CORS settings if accessing from different domain
- Check browser console for JavaScript errors

### Location Shows "Unknown"
- IP-API.com may not have data for the IP address
- Some IPs (especially VPNs) may not resolve to locations
- Check the workflow execution logs for API response

### Rate Limiting
- IP-API.com free tier: 45 requests/minute
- For production use, consider:
  - Upgrading to paid plan
  - Using a different geolocation service
  - Adding request throttling

## Security Considerations

- The webhook URL is exposed in your HTML (JavaScript)
- Consider adding authentication if needed
- For sensitive data, implement server-side validation
- Rate limiting can be added in n8n to prevent abuse

## Support

- n8n Documentation: https://docs.n8n.io
- n8n Community: https://community.n8n.io
- IP-API Documentation: http://ip-api.com/docs

## License

This project is free to use and modify for your needs.

