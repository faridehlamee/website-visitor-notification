# Railway Troubleshooting Guide

## Error: "Application failed to respond"

This means Railway deployed but the service isn't starting correctly.

### Step 1: Check Deployment Logs

1. Go to Railway dashboard
2. Click on your service
3. Click "Deployments" tab
4. Click on the latest deployment
5. Click "View Logs"
6. Look for error messages

**Common errors to look for:**
- Port binding errors
- Environment variable issues
- Build failures
- n8n startup errors

### Step 2: Check Service Configuration

1. Go to your service → "Settings"
2. Check:
   - **Build Command**: Should be empty or auto-detected
   - **Start Command**: Should be `n8n start` or empty
   - **Dockerfile Path**: Should be `Dockerfile.n8n` (if using our custom one)

### Step 3: Set Environment Variables

Go to "Variables" tab and add:

```
N8N_PORT=$PORT
N8N_PROTOCOL=https
N8N_HOST=$RAILWAY_PUBLIC_DOMAIN
WEBHOOK_URL=https://$RAILWAY_PUBLIC_DOMAIN
GENERIC_TIMEZONE=UTC
N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true
DB_SQLITE_POOL_SIZE=10
N8N_RUNNERS_ENABLED=true
N8N_BLOCK_ENV_ACCESS_IN_NODE=false
N8N_GIT_NODE_DISABLE_BARE_REPOS=true
```

**Important**: Railway automatically sets `$PORT` and `$RAILWAY_PUBLIC_DOMAIN` - use these!

### Step 4: Fix Port Configuration

1. Go to "Settings" → "Networking"
2. Make sure the port matches what Railway provides
3. Railway usually provides `$PORT` environment variable
4. n8n should use `$PORT` instead of hardcoded 5678

### Step 5: Redeploy

1. Go to "Settings"
2. Scroll down
3. Click "Redeploy"
4. Wait for deployment
5. Check logs again

---

## Alternative: Use Railway's Dockerfile Detection

If the above doesn't work:

1. **Delete the current service** in Railway
2. **Create a new service** → "Deploy from GitHub"
3. Select your repository
4. Railway will ask "What would you like to deploy?"
5. Choose **"Dockerfile"** or **"Empty"**
6. Configure it manually:
   - **Dockerfile Path**: `Dockerfile.n8n`
   - **Start Command**: `n8n start`
   - Add environment variables (see Step 3 above)

---

## Common Issues

### Issue: Port Already in Use
**Solution**: Railway manages ports automatically. Use `$PORT` environment variable.

### Issue: n8n Not Starting
**Solution**: Check logs for n8n errors. Make sure all environment variables are set.

### Issue: Can't Access After Deployment
**Solution**: 
- Wait 2-3 minutes for full deployment
- Check service status (should be green)
- Verify domain is generated
- Check that port 5678 (or $PORT) is exposed

### Issue: Build Fails
**Solution**:
- Check Dockerfile syntax
- Make sure Dockerfile.n8n exists
- Check Railway build logs

---

## Quick Fix: Start Fresh

If nothing works:

1. **Delete the service** in Railway
2. **Create new service** → "Deploy from GitHub repo"
3. Select "website-visitor-notification"
4. When Railway asks what to deploy:
   - Choose **"Dockerfile"**
   - Set Dockerfile path to: `Dockerfile.n8n`
5. **Add environment variables** (see Step 3 above)
6. **Generate domain** with port: `$PORT` (Railway will set this automatically)
7. **Deploy**

---

## Need More Help?

Check Railway logs first - they usually tell you exactly what's wrong!

Share the logs with me and I can help fix the specific issue.

