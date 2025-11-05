# How to Add Visitor Notification to Your Existing Website

Since you already have an `index.html` file on www.kiatechsoftware.com, here are two ways to add visitor notification without replacing your existing homepage.

## Option 1: Add Script to Existing Pages (Recommended - Easiest)

This method adds the tracking script to your existing website without changing your design.

### Step 1: Upload the JavaScript File

1. Upload `visitor-notification.js` to your website server
2. Place it in a folder like `/js/` or `/assets/js/` on your server
3. Note the path (e.g., `https://www.kiatechsoftware.com/js/visitor-notification.js`)

### Step 2: Add Script to Your Existing HTML

Open your existing `index.html` (or any page you want to track) and add this line **before the closing `</body>` tag**:

```html
<!-- Visitor Notification Script -->
<script src="/js/visitor-notification.js"></script>
```

Or if you uploaded it to a different location:

```html
<!-- Visitor Notification Script -->
<script src="https://www.kiatechsoftware.com/js/visitor-notification.js"></script>
```

### Example:

```html
<!DOCTYPE html>
<html>
<head>
    <title>Your Existing Website</title>
    <!-- Your existing head content -->
</head>
<body>
    <!-- Your existing website content -->
    <h1>Welcome to KiaTech Software</h1>
    <p>Your existing content here...</p>
    
    <!-- Add this line before closing body tag -->
    <script src="/js/visitor-notification.js"></script>
</body>
</html>
```

### Step 3: Test It

1. Visit your website
2. Check your email - you should receive a notification!

**That's it!** The script runs silently in the background and won't affect your website's appearance or functionality.

---

## Option 2: Copy JavaScript Code Directly

If you prefer not to upload a separate file, you can copy the JavaScript code directly into your existing HTML.

### Step 1: Open Your Existing index.html

### Step 2: Add This Script Before `</body>` Tag

```html
<script>
// Visitor Notification Script
(function() {
    'use strict';
    
    async function sendVisitorNotification() {
        try {
            const ipResponse = await fetch('https://api.ipify.org?format=json');
            const ipData = await ipResponse.json();
            const ipAddress = ipData.ip;

            const visitorData = {
                ip: ipAddress,
                ipAddress: ipAddress,
                userAgent: navigator.userAgent,
                referrer: document.referrer || 'Direct',
                timestamp: new Date().toISOString(),
                pageUrl: window.location.href,
                language: navigator.language,
                screenResolution: `${window.screen.width}x${window.screen.height}`,
                timezone: Intl.DateTimeFormat().resolvedOptions().timeZone
            };

            const webhookUrl = 'https://website-visitor-notification-production.up.railway.app/webhook/visitor-notification';

            await fetch(webhookUrl, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(visitorData)
            });
        } catch (error) {
            console.error('Error sending visitor notification:', error);
        }
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', sendVisitorNotification);
    } else {
        sendVisitorNotification();
    }
})();
</script>
```

### Step 3: Save and Upload

1. Save your `index.html`
2. Upload it to your website
3. Test it!

---

## Option 3: Add to Specific Pages Only

If you only want to track certain pages (not all pages):

1. Add the script only to the pages you want to track
2. For example, add it to:
   - Homepage (`index.html`)
   - Contact page (`contact.html`)
   - About page (`about.html`)
   - etc.

---

## Which Option Should I Use?

- **Option 1** (separate .js file): Best if you want to track multiple pages - just add one line to each page
- **Option 2** (inline script): Best if you only want to track one or two pages
- **Option 3**: Use if you want selective tracking

---

## Important Notes

✅ **The script runs silently** - visitors won't see anything
✅ **No changes to your website design** - it's invisible
✅ **Works on all pages** where you add the script
✅ **Doesn't slow down your website** - runs in background
✅ **No conflicts** - won't interfere with your existing code

---

## Testing

1. Add the script to your website
2. Visit your website in a browser
3. Check your email inbox
4. You should receive a notification with visitor details!

---

## Troubleshooting

### Not receiving emails?
- Check that n8n workflow is activated (green toggle)
- Check Railway logs for webhook requests
- Check browser console for JavaScript errors (F12 → Console)

### Want to track only homepage?
- Add script only to `index.html`

### Want to track all pages?
- Add script to a common template/header file (if using a CMS)
- Or add to each page individually

---

## Summary

**Easiest method**: Upload `visitor-notification.js` to your server, then add one line to your existing HTML:

```html
<script src="/js/visitor-notification.js"></script>
```

That's it! Your existing website will now send visitor notifications without any visible changes.

