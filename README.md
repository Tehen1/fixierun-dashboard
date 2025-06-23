# 🚴‍♂️ FixieRun Dashboard

> **Advanced Fitness Tracking Dashboard with Blockchain Integration & Google Drive Sync**

A modern, responsive web application that combines fitness tracking, blockchain technology, and cloud synchronization into one powerful dashboard. Track your workouts, earn crypto tokens, manage NFT bikes, and sync everything to Google Drive.

![FixieRun Dashboard](https://img.shields.io/badge/Status-Production%20Ready-brightgreen)
![Version](https://img.shields.io/badge/Version-1.0.0-blue)
![License](https://img.shields.io/badge/License-MIT-green)

## ✨ Features

### 🏃‍♂️ **Fitness Tracking**
- **Real-time GPS tracking** with geolocation support
- **Activity monitoring** (distance, speed, calories, duration)
- **Workout history** and progress analytics
- **Weekly goals** and achievement tracking
- **Streak counters** and motivation metrics

### 🔐 **Google Integration**
- **Google OAuth2 authentication** for secure sign-in
- **Google Drive sync** for cross-device data access
- **Automatic backup** of all fitness data
- **Profile integration** with Google account data
- **Real-time synchronization** every 5 minutes

### ⛓️ **Blockchain Features**
- **Real-time gas price tracking** for Ethereum
- **Crypto token rewards** for completed workouts
- **NFT bike collection** with rarity and boosts
- **DeFi dashboard** with portfolio tracking
- **MetaMask wallet integration**

### 📱 **Modern UI/UX**
- **Responsive design** for mobile and desktop
- **Dark theme** with neon accents
- **Progressive Web App** (PWA) support
- **Real-time notifications** and status updates
- **Smooth animations** and transitions

## 🚀 Quick Start

### Local Development

1. **Clone or download** the project
2. **Start a local server**:
   ```bash
   cd fixierun-dashboard
   python3 -m http.server 9000
   ```
3. **Open your browser** to `http://localhost:9000`

### One-Click Deployment

Use the automated deployment script:

```bash
./deploy.sh
```

Choose from:
- **Netlify** (Recommended - Free)
- **Vercel** (Fast & Easy) 
- **GitHub Pages** (Free)
- **Docker** (Self-hosted)

## 🔧 Production Setup

### Step 1: Google OAuth2 Configuration

1. **Go to [Google Cloud Console](https://console.cloud.google.com/)**
2. **Create a new project**: `FixieRun Dashboard`
3. **Enable APIs**:
   - Google+ API
   - Google Drive API
   - Google Identity Services
4. **Create OAuth2 credentials**:
   - Type: Web Application
   - Add your domain to authorized origins
5. **Update your app**:
   ```javascript
   // In index.html, replace the CLIENT_ID
   const GOOGLE_CONFIG = {
       CLIENT_ID: 'YOUR_REAL_CLIENT_ID_HERE.apps.googleusercontent.com',
       SCOPES: 'profile email https://www.googleapis.com/auth/drive.file'
   };
   ```

### Step 2: Deploy to Your Platform

#### Netlify (Recommended)
```bash
# Upload your files or connect GitHub
# Netlify will auto-deploy from the main branch
# Domain: https://your-app.netlify.app
```

#### Vercel
```bash
npm install -g vercel
vercel --prod
# Domain: https://your-app.vercel.app
```

#### GitHub Pages
```bash
git init
git add .
git commit -m "Deploy FixieRun Dashboard"
git remote add origin https://github.com/yourusername/fixierun-dashboard.git
git push -u origin main
# Enable Pages in Settings > Pages
# Domain: https://yourusername.github.io/fixierun-dashboard/
```

#### Docker
```bash
docker build -t fixierun-dashboard .
docker run -d -p 80:80 fixierun-dashboard
# Access at http://localhost
```

### Step 3: Update Google Cloud Console

Add your production domain to authorized origins:
- `https://app.fixie.run`
- `https://your-app.netlify.app` 
- `https://your-app.vercel.app`

## 📋 Testing Checklist

After deployment, verify these features work:

- [ ] **Google Sign-In** button appears and functions
- [ ] **Profile updates** with Google account data
- [ ] **GPS tracking** works (requires HTTPS)
- [ ] **Data syncs** to Google Drive
- [ ] **Activity tracking** records workouts
- [ ] **Blockchain data** loads (gas prices, crypto prices)
- [ ] **Mobile responsive** design works
- [ ] **PWA features** (if enabled)

## 🛠️ Technical Stack

- **Frontend**: Vanilla JavaScript, TailwindCSS, Chart.js
- **Authentication**: Google OAuth2, Google Identity Services
- **Storage**: Google Drive API, LocalStorage
- **APIs**: Google Maps, Geolocation, MetaMask
- **Deployment**: Static hosting (Netlify, Vercel, GitHub Pages)
- **Containerization**: Docker with Nginx

## 📁 Project Structure

```
fixierun-dashboard/
├── index.html              # Main application file
├── manifest.json           # PWA manifest
├── netlify.toml            # Netlify configuration
├── vercel.json             # Vercel configuration
├── Dockerfile              # Docker configuration
├── nginx.conf              # Nginx configuration
├── deploy.sh               # Deployment script
├── .env.example            # Environment variables template
├── PRODUCTION_SETUP.md     # Detailed setup guide
└── README.md               # This file
```

## 🔒 Security Features

- **Content Security Policy** headers
- **XSS Protection** and frame denial
- **HTTPS enforcement** for production
- **Secure token handling** for Google OAuth
- **Rate limiting** for API endpoints
- **Input validation** and sanitization

## 🌟 Advanced Features

### PWA Support
- **Installable** on mobile devices
- **Offline functionality** with service workers
- **Push notifications** (configurable)
- **App shortcuts** for quick actions

### Real Google Drive Integration
```javascript
// Example: Save user data to Google Drive
async function saveToGoogleDrive(userData) {
    const response = await fetch('https://www.googleapis.com/upload/drive/v3/files', {
        method: 'POST',
        headers: {
            'Authorization': `Bearer ${accessToken}`,
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            name: 'fixierun-data.json',
            mimeType: 'application/json'
        })
    });
}
```

### Analytics Integration
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

## 🐛 Troubleshooting

### Common Issues

**"Invalid client ID" error**
- ✅ Verify CLIENT_ID in index.html
- ✅ Check authorized domains in Google Console
- ✅ Clear browser cache

**"Unauthorized domain" error**  
- ✅ Add exact domain to Google Console
- ✅ Include both www and non-www versions
- ✅ Use HTTPS for production

**GPS/Geolocation not working**
- ✅ Ensure HTTPS is enabled
- ✅ Check browser permissions
- ✅ Test on different devices

**Google Drive sync fails**
- ✅ Verify Google Drive API is enabled
- ✅ Check user granted permissions
- ✅ Confirm scopes include 'drive.file'

## 📞 Support & Documentation

- **Production Setup**: See `PRODUCTION_SETUP.md`
- **Environment Config**: See `.env.example`
- **Deployment Script**: Run `./deploy.sh`

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Google APIs** for authentication and drive sync
- **TailwindCSS** for styling framework
- **Chart.js** for data visualization
- **MetaMask** for blockchain integration

---

**Ready to launch your fitness tracking empire? 🚀**

Deploy your FixieRun Dashboard today and start building the next generation of fitness apps with blockchain integration!
