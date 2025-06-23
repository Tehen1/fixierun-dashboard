#!/bin/bash

# FixieRun Dashboard - Production Deployment Script
# This script helps automate the deployment process

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PROJECT_NAME="fixierun-dashboard"
DOCKER_IMAGE="fixierun/dashboard"
VERSION="1.0.0"

echo -e "${BLUE}🚀 FixieRun Dashboard Deployment Script${NC}"
echo -e "${BLUE}======================================${NC}"

# Function to print colored output
print_step() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check if configuration is set up
check_config() {
    print_step "Checking configuration..."
    
    if [ ! -f "index.html" ]; then
        print_error "index.html not found. Make sure you're in the project directory."
        exit 1
    fi
    
    # Check if Google Client ID is configured
    if grep -q "1234567890-abcdefghijklmnopqrstuvwxyz.apps.googleusercontent.com" index.html; then
        print_warning "Demo Google Client ID detected. Update with your real Client ID for production!"
        echo "  Edit index.html and replace the CLIENT_ID in GOOGLE_CONFIG"
        echo ""
    fi
    
    print_step "Configuration check complete"
}

# Deploy to Netlify
deploy_netlify() {
    print_step "Deploying to Netlify..."
    
    if ! command -v netlify &> /dev/null; then
        print_warning "Netlify CLI not found. Installing..."
        npm install -g netlify-cli
    fi
    
    echo "Please make sure you're logged in to Netlify:"
    netlify login
    
    print_step "Deploying to Netlify..."
    netlify deploy --prod --dir=. --site-name="$PROJECT_NAME"
    
    print_step "Netlify deployment complete!"
}

# Deploy to Vercel
deploy_vercel() {
    print_step "Deploying to Vercel..."
    
    if ! command -v vercel &> /dev/null; then
        print_warning "Vercel CLI not found. Installing..."
        npm install -g vercel
    fi
    
    print_step "Deploying to Vercel..."
    vercel --prod
    
    print_step "Vercel deployment complete!"
}

# Deploy to GitHub Pages
deploy_github_pages() {
    print_step "Setting up GitHub Pages deployment..."
    
    if [ ! -d ".git" ]; then
        print_step "Initializing Git repository..."
        git init
        git branch -M main
    fi
    
    print_step "Adding files to Git..."
    git add .
    git commit -m "Deploy FixieRun Dashboard v$VERSION" || echo "No changes to commit"
    
    echo "Please enter your GitHub repository URL (e.g., https://github.com/username/fixierun-dashboard.git):"
    read -r GITHUB_REPO
    
    if [ ! -z "$GITHUB_REPO" ]; then
        git remote add origin "$GITHUB_REPO" 2>/dev/null || git remote set-url origin "$GITHUB_REPO"
        git push -u origin main
        
        print_step "Code pushed to GitHub!"
        print_warning "Don't forget to enable GitHub Pages in your repository settings:"
        echo "  1. Go to Settings > Pages"
        echo "  2. Source: Deploy from a branch"
        echo "  3. Branch: main / (root)"
    fi
}

# Build and deploy Docker container
deploy_docker() {
    print_step "Building Docker image..."
    
    if ! command -v docker &> /dev/null; then
        print_error "Docker not found. Please install Docker first."
        exit 1
    fi
    
    # Build the image
    docker build -t "$DOCKER_IMAGE:$VERSION" -t "$DOCKER_IMAGE:latest" .
    
    print_step "Docker image built successfully!"
    
    echo "Would you like to run the container locally? (y/n)"
    read -r RUN_LOCAL
    
    if [ "$RUN_LOCAL" = "y" ] || [ "$RUN_LOCAL" = "Y" ]; then
        print_step "Starting container on port 8080..."
        docker run -d -p 8080:80 --name "$PROJECT_NAME" "$DOCKER_IMAGE:latest"
        print_step "Container is running at http://localhost:8080"
    fi
    
    echo "Would you like to push to Docker Hub? (y/n)"
    read -r PUSH_DOCKER
    
    if [ "$PUSH_DOCKER" = "y" ] || [ "$PUSH_DOCKER" = "Y" ]; then
        echo "Please enter your Docker Hub username:"
        read -r DOCKER_USERNAME
        
        docker tag "$DOCKER_IMAGE:latest" "$DOCKER_USERNAME/$PROJECT_NAME:latest"
        docker tag "$DOCKER_IMAGE:$VERSION" "$DOCKER_USERNAME/$PROJECT_NAME:$VERSION"
        
        docker push "$DOCKER_USERNAME/$PROJECT_NAME:latest"
        docker push "$DOCKER_USERNAME/$PROJECT_NAME:$VERSION"
        
        print_step "Docker images pushed to Docker Hub!"
    fi
}

# Validate Google OAuth setup
validate_google_oauth() {
    print_step "Google OAuth Setup Validation"
    echo ""
    echo "Make sure you've completed these steps in Google Cloud Console:"
    echo "1. ✅ Created a new project"
    echo "2. ✅ Enabled Google+ API and Google Drive API"
    echo "3. ✅ Created OAuth2 credentials"
    echo "4. ✅ Added your deployment domain to authorized origins"
    echo "5. ✅ Updated CLIENT_ID in index.html"
    echo ""
    echo "Press Enter to continue..."
    read
}

# Main deployment menu
main_menu() {
    echo ""
    echo "Choose your deployment platform:"
    echo "1) Netlify (Recommended - Free)"
    echo "2) Vercel (Fast & Easy)"
    echo "3) GitHub Pages (Free)"
    echo "4) Docker (Self-hosted)"
    echo "5) Validate Google OAuth Setup"
    echo "6) Exit"
    echo ""
    echo -n "Enter your choice (1-6): "
    read -r choice
    
    case $choice in
        1)
            deploy_netlify
            ;;
        2)
            deploy_vercel
            ;;
        3)
            deploy_github_pages
            ;;
        4)
            deploy_docker
            ;;
        5)
            validate_google_oauth
            main_menu
            ;;
        6)
            echo "Goodbye! 👋"
            exit 0
            ;;
        *)
            print_error "Invalid choice. Please try again."
            main_menu
            ;;
    esac
}

# Pre-deployment checks
pre_deployment_checks() {
    print_step "Running pre-deployment checks..."
    
    # Check for required files
    if [ ! -f "manifest.json" ]; then
        print_warning "manifest.json not found. PWA features will be limited."
    fi
    
    # Check if using HTTPS (required for many features)
    print_warning "Remember: HTTPS is required for:"
    echo "  - Google OAuth2"
    echo "  - Geolocation API"
    echo "  - Service Workers (PWA)"
    echo "  - Web Push Notifications"
    echo ""
}

# Check if we're in the right directory
if [ ! -f "index.html" ]; then
    print_error "Please run this script from the fixierun-dashboard directory"
    exit 1
fi

# Main execution
check_config
pre_deployment_checks
main_menu

# Post-deployment instructions
echo ""
print_step "Deployment completed!"
echo ""
echo -e "${BLUE}📋 Post-deployment checklist:${NC}"
echo "1. Update Google Cloud Console with your new domain"
echo "2. Test Google Sign-In functionality"
echo "3. Verify GPS/geolocation works on HTTPS"
echo "4. Test data synchronization"
echo "5. Check mobile responsiveness"
echo "6. Set up monitoring and analytics"
echo ""
echo -e "${GREEN}🎉 Your FixieRun Dashboard is now live!${NC}"
