# 🚀 FixieRun Dashboard - Production Setup Guide

## 🔧 Google OAuth2 Configuration

### Step 1: Google Cloud Console Setup

1. **Go to Google Cloud Console**
   - Visit: https://console.cloud.google.com/
   - Sign in with your Google account

2. **Create a New Project**
   ```bash
   Project Name: FixieRun Dashboard
   Project ID: fixierun-dashboard-[random-id]
   ```

3. **Enable Required APIs**
   - Go to "APIs & Services" > "Library"
   - Enable these APIs:
     - **Google+ API** (for profile data)
     - **Google Drive API** (for data sync)
     - **Google Identity Services**

### Step 2: Create OAuth2 Credentials

1. **Go to Credentials**
   - Navigate to "APIs & Services" > "Credentials"
   - Click "Create Credentials" > "OAuth client ID"

2. **Configure OAuth Consent Screen**
   ```
   Application Type: Web Application
   Application Name: FixieRun Dashboard
   User Support Email: your-email@domain.com
   Developer Contact: your-email@domain.com
   
   Scopes:
   - profile
   - email
   - https://www.googleapis.com/auth/drive.file
   ```

3. **Create Web Application Credentials**
   ```
   Name: FixieRun Web Client
   
   Authorized JavaScript Origins:
   - http://localhost:9000 (for development)
   - https://your-domain.com (for production)
   - https://your-app.netlify.app (if using Netlify)
   - https://your-app.vercel.app (if using Vercel)
   
   Authorized Redirect URIs:
   - http://localhost:9000 (for development)
   - https://your-domain.com (for production)
   ```

4. **Download Credentials**
   - Download the JSON file with your credentials
   - Note the `client_id` - you'll need this!

### Step 3: Update Your App Configuration

Replace the demo CLIENT_ID in your `index.html`:

```javascript
// Find this section in your index.html (around line 1751)
const GOOGLE_CONFIG = {
    CLIENT_ID: 'YOUR_REAL_CLIENT_ID_HERE.apps.googleusercontent.com',
    SCOPES: 'profile email https://www.googleapis.com/auth/drive.file'
};
```

## 🌐 Production Deployment Options

### Option 1: Netlify (Recommended - Free)

1. **Prepare for deployment**
   ```bash
   # Make sure your index.html has the correct CLIENT_ID
   # No build process needed - it's a static site!
   ```

2. **Deploy to Netlify**
   - Go to https://netlify.com
   - Drag and drop your `index.html` file
   - Or connect your GitHub repository

3. **Configure Custom Domain (Optional)**
   ```
   Your app will be available at:
   https://your-app-name.netlify.app
   
   Or configure custom domain:
   https://fixierun.your-domain.com
   ```

4. **Update Google OAuth2 Settings**
   - Add your Netlify URL to authorized origins in Google Cloud Console

### Option 2: Vercel (Fast & Easy)

1. **Install Vercel CLI**
   ```bash
   npm install -g vercel
   ```

2. **Deploy**
   ```bash
   cd fixierun-dashboard
   vercel --prod
   ```

3. **Configure Domain**
   - Follow Vercel's prompts to set up your domain
   - Update Google OAuth2 settings with your Vercel URL

### Option 3: GitHub Pages (Free)

1. **Create GitHub Repository**
   ```bash
   git init
   git add .
   git commit -m "Initial commit: FixieRun Dashboard"
   git branch -M main
   git remote add origin https://github.com/yourusername/fixierun-dashboard.git
   git push -u origin main
   ```

2. **Enable GitHub Pages**
   - Go to repository Settings > Pages
   - Source: Deploy from a branch
   - Branch: main / (root)

3. **Access Your App**
   ```
   https://yourusername.github.io/fixierun-dashboard/
   ```

### Option 4: Custom Server

1. **Using Node.js/Express**
   ```bash
   npm init -y
   npm install express
   ```

2. **Create server.js**
   ```javascript
   const express = require('express');
   const path = require('path');
   const app = express();
   
   app.use(express.static('.'));
   
   app.get('/', (req, res) => {
       res.sendFile(path.join(__dirname, 'index.html'));
   });
   
   const PORT = process.env.PORT || 3000;
   app.listen(PORT, () => {
       console.log(`FixieRun Dashboard running on port ${PORT}`);
   });
   ```

3. **Deploy to Heroku/Railway/DigitalOcean**

## 🔒 Security Configuration

### Environment Variables

Create a `.env` file for sensitive configuration:

```env
# .env file (for server-side apps)
GOOGLE_CLIENT_ID=your_client_id_here
GOOGLE_CLIENT_SECRET=your_client_secret_here
GOOGLE_REDIRECT_URI=https://your-domain.com/auth/callback
```

### Content Security Policy

Update your CSP header to include Google domains:

```html
<meta http-equiv="Content-Security-Policy" content="
    default-src 'self' 'unsafe-inline' 'unsafe-eval' data: blob:;
    script-src 'self' 'unsafe-inline' 'unsafe-eval' 
        https://apis.google.com 
        https://accounts.google.com
        https://cdn.tailwindcss.com 
        https://cdn.jsdelivr.net
        https://kit.fontawesome.com;
    connect-src 'self' 
        https://apis.google.com 
        https://accounts.google.com
        https://www.googleapis.com;
    frame-src 'self' 
        https://accounts.google.com;
">
```

## 📱 Testing Production Setup

### Test Checklist

- [ ] Google Sign-In button appears
- [ ] Clicking opens Google OAuth popup
- [ ] Successful sign-in updates profile
- [ ] Data syncs to Google Drive
- [ ] Sign-out works correctly
- [ ] Auto-sync works every 5 minutes
- [ ] Activity completion triggers sync

### Debug Common Issues

1. **"Invalid client ID" error**
   ```
   ✅ Check CLIENT_ID is correct
   ✅ Verify domain is authorized in Google Console
   ✅ Clear browser cache
   ```

2. **"Unauthorized domain" error**
   ```
   ✅ Add your domain to authorized origins
   ✅ Include both www and non-www versions
   ✅ Use exact URL format (https://, no trailing slash)
   ```

3. **Google Drive sync fails**
   ```
   ✅ Enable Google Drive API
   ✅ Check scopes include drive.file
   ✅ Verify user granted permissions
   ```

## 🚀 Advanced Features

### Real Google Drive Integration

For full Google Drive sync, implement these functions:

```javascript
// Real Google Drive API implementation
async function saveToDrive(userData, accessToken) {
    const response = await fetch('https://www.googleapis.com/upload/drive/v3/files', {
        method: 'POST',
        headers: {
            'Authorization': `Bearer ${accessToken}`,
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            name: 'fixierun-data.json',
            parents: ['fixierun-app-folder'],
            mimeType: 'application/json'
        })
    });
    
    return response.json();
}

async function loadFromDrive(accessToken) {
    const response = await fetch('https://www.googleapis.com/drive/v3/files?q=name="fixierun-data.json"', {
        headers: {
            'Authorization': `Bearer ${accessToken}`
        }
    });
    
    return response.json();
}
```

### Analytics Integration

Add Google Analytics to track usage:

```html
<!-- Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=GA_MEASUREMENT_ID"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'GA_MEASUREMENT_ID');
</script>
```

### PWA Configuration

Make your app installable by adding a manifest:

```json
{
  "name": "FixieRun Dashboard",
  "short_name": "FixieRun",
  "description": "Advanced fitness tracking with blockchain integration",
  "start_url": "/",
  "display": "standalone",
  "background_color": "#0e1117",
  "theme_color": "#5D5CDE",
  "icons": [
    {
      "src": "icon-192.png",
      "sizes": "192x192",
      "type": "image/png"
    },
    {
      "src": "icon-512.png",
      "sizes": "512x512",
      "type": "image/png"
    }
  ]
}
```

## 📞 Support

Need help with production setup?

1. **Check the console** for detailed error messages
2. **Verify Google Cloud Console** configuration
3. **Test with localhost first** before deploying
4. **Use browser dev tools** to debug OAuth flow

---

**Your FixieRun Dashboard is ready for production! 🎉**

Deploy with confidence knowing your users can securely sync their fitness data with Google Drive.
