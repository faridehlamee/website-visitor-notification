# Webhook Testing Guide - Test vs Production

## Understanding Webhook URLs in n8n

n8n shows **two different webhook URLs**:

### 1. Test Webhook URL (`/webhook-test/`)
- **URL**: `https://website-visitor-notification-production.up.railway.app/webhook-test/visitor-notification`
- **Purpose**: Only for testing in n8n editor
- **How it works**: 
  - Only works **once** after clicking "Execute Workflow" button
  - Not for production use
  - Used to test workflow logic in n8n
- **When to use**: When you're editing the workflow and want to test it

### 2. Production Webhook URL (`/webhook/`)
- **URL**: `https://website-visitor-notification-production.up.railway.app/webhook/visitor-notification`
- **Purpose**: For actual production use (your website)
- **How it works**: 
  - Works **continuously** when workflow is **ACTIVATED**
  - Accepts requests from your website
  - This is what you use in your JavaScript code
- **When to use**: In your `index.html` or `visitor-notification.js` file

---

## Important: Activate the Workflow!

**The production webhook (`/webhook/`) ONLY works when the workflow is ACTIVATED!**

### How to Activate:

1. Open your workflow in n8n
2. Look for the **toggle switch** at the top (usually in the top-right corner)
3. Click it to **turn it ON** (it should be green/active)
4. The workflow is now active and listening for webhooks

**Without activation, the webhook will return 404 error!**

---

## Testing Your Webhook

### ❌ Wrong Way (This won't work):

Typing the URL directly in browser:
```
https://website-visitor-notification-production.up.railway.app/webhook/visitor-notification
```

**Why it doesn't work**: 
- Browser makes a GET request
- Your webhook expects a POST request (with JSON data)
- You'll get an error or no response

### ✅ Correct Way to Test:

#### Option 1: Use Your Website (Best Test)
1. Upload `visitor-notification.js` to your website
2. Visit `https://www.kiatechsoftware.com`
3. Check your email - you should receive a notification!

#### Option 2: Use curl (Command Line)
```bash
curl -X POST https://website-visitor-notification-production.up.railway.app/webhook/visitor-notification \
  -H "Content-Type: application/json" \
  -d '{
    "ip": "123.456.789.0",
    "ipAddress": "123.456.789.0",
    "userAgent": "Mozilla/5.0",
    "referrer": "Direct",
    "timestamp": "2024-01-01T12:00:00.000Z",
    "pageUrl": "https://www.kiatechsoftware.com",
    "language": "en-US",
    "screenResolution": "1920x1080",
    "timezone": "America/New_York"
  }'
```

#### Option 3: Use Postman or Similar Tool
1. Create a POST request
2. URL: `https://website-visitor-notification-production.up.railway.app/webhook/visitor-notification`
3. Headers: `Content-Type: application/json`
4. Body (JSON):
```json
{
  "ip": "123.456.789.0",
  "ipAddress": "123.456.789.0",
  "userAgent": "Mozilla/5.0",
  "referrer": "Direct",
  "timestamp": "2024-01-01T12:00:00.000Z",
  "pageUrl": "https://www.kiatechsoftware.com",
  "language": "en-US",
  "screenResolution": "1920x1080",
  "timezone": "America/New_York"
}
```

---

## About `$RAILWAY_PUBLIC_DOMAIN`

**This is normal!** Don't worry about it.

- `$RAILWAY_PUBLIC_DOMAIN` is an **internal Railway variable**
- n8n uses it to construct the webhook URL
- Railway automatically replaces it with your actual domain: `website-visitor-notification-production.up.railway.app`
- **Your JavaScript code correctly uses the actual domain** - that's all that matters!

**What you see in n8n UI:**
```
https://$RAILWAY_PUBLIC_DOMAIN/webhook/visitor-notification
```

**What actually works:**
```
https://website-visitor-notification-production.up.railway.app/webhook/visitor-notification
```

Both are correct - n8n just shows the variable, but resolves it to the actual domain when used.

---

## Checklist: Is Your Webhook Working?

✅ **Workflow is ACTIVATED** (toggle switch is ON/green)
✅ **Using production URL** (`/webhook/` not `/webhook-test/`)
✅ **Using POST method** (not GET via browser)
✅ **Sending JSON data** in the request body
✅ **Workflow has email configured** and credentials set up
✅ **JavaScript code uses correct URL**: `https://website-visitor-notification-production.up.railway.app/webhook/visitor-notification`

---

## Troubleshooting

### Error: "webhook is not registered"
**Solution**: Activate the workflow (toggle switch ON)

### Error: 404 when accessing via browser
**Solution**: Normal! Webhooks need POST requests, not GET. Use your website or curl/Postman to test.

### Error: Workflow not receiving data
**Solution**: 
1. Check workflow is activated
2. Check Railway logs for incoming requests
3. Verify webhook URL in your JavaScript matches exactly

### Error: Email not sending
**Solution**:
1. Check SMTP credentials are configured
2. Verify email node has correct "from" and "to" addresses
3. Check Railway logs for email sending errors

---

## Summary

1. **Test webhook** (`/webhook-test/`): Only for testing in n8n editor
2. **Production webhook** (`/webhook/`): Use this in your website code
3. **Activate workflow**: Toggle switch must be ON
4. **Don't test via browser URL**: Use your website or POST request tools
5. **`$RAILWAY_PUBLIC_DOMAIN` is fine**: It's just an internal variable

Your setup is correct! Just make sure the workflow is activated. 🚀

