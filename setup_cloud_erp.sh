#!/bin/bash

# Project Name
PROJECT_NAME="cloud-erp-system"

# Create Project Directory Structure
echo "Creating project structure..."
mkdir -p $PROJECT_NAME/{public/{css,js,assets/{images,icons}},firebase}

# Create Default Files
echo "Creating default files..."
touch $PROJECT_NAME/public/{index.html,css/style.css,js/{main.js,firebase.js},manifest.json,favicon.ico}
touch $PROJECT_NAME/{firebase.json,.firebaserc,package.json,README.md}

# Populate index.html
cat <<EOF > $PROJECT_NAME/public/index.html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Cloud ERP System</title>
  <link rel="stylesheet" href="css/style.css">
</head>
<body>
  <h1>Welcome to the Cloud ERP System</h1>
  <script type="module" src="js/main.js"></script>
</body>
</html>
EOF

# Populate style.css
cat <<EOF > $PROJECT_NAME/public/css/style.css
/* General Styles */
body {
  font-family: Arial, sans-serif;
  margin: 0;
  padding: 0;
  background-color: #f4f4f9;
}
h1 {
  text-align: center;
  margin-top: 50px;
}
EOF

# Populate firebase.js
cat <<EOF > $PROJECT_NAME/public/js/firebase.js
// Firebase Configuration
import { initializeApp } from "https://www.gstatic.com/firebasejs/11.2.0/firebase-app.js";
import { getAnalytics } from "https://www.gstatic.com/firebasejs/11.2.0/firebase-analytics.js";

const firebaseConfig = {
  apiKey: "AIzaSyBKU5fIKgH01Nz0hYSp9Y9uOZs3NtkxM-o",
  authDomain: "aenzbi-cloud.firebaseapp.com",
  databaseURL: "https://aenzbi-cloud-default-rtdb.firebaseio.com",
  projectId: "aenzbi-cloud",
  storageBucket: "aenzbi-cloud.appspot.com",
  messagingSenderId: "542733754951",
  appId: "1:542733754951:web:e5f86b95c2914184fc8762",
  measurementId: "G-L6KTS9B6M0"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);
EOF

# Populate main.js
cat <<EOF > $PROJECT_NAME/public/js/main.js
// Main Application Logic
console.log("Welcome to the Cloud ERP System!");
EOF

# Populate manifest.json
cat <<EOF > $PROJECT_NAME/public/manifest.json
{
  "name": "Cloud ERP System",
  "short_name": "ERP System",
  "description": "A Firebase-powered Cloud ERP System for managing business operations.",
  "start_url": "/index.html",
  "display": "standalone",
  "background_color": "#ffffff",
  "theme_color": "#007bff",
  "icons": [
    {
      "src": "/assets/icons/icon-192x192.png",
      "sizes": "192x192",
      "type": "image/png"
    },
    {
      "src": "/assets/icons/icon-512x512.png",
      "sizes": "512x512",
      "type": "image/png"
    }
  ]
}
EOF

# Populate firebase.json
cat <<EOF > $PROJECT_NAME/firebase.json
{
  "hosting": {
    "public": "public",
    "ignore": ["firebase.json", "**/.*", "**/node_modules/**"],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ]
  }
}
EOF

# Populate .firebaserc
cat <<EOF > $PROJECT_NAME/.firebaserc
{
  "projects": {
    "default": "aenzbi-cloud"
  }
}
EOF

# Populate README.md
cat <<EOF > $PROJECT_NAME/README.md
# Cloud ERP System

A modern, Firebase-powered Cloud ERP System designed for seamless business operations. This system integrates essential modules such as POS, Inventory Management, User Profiles, and Analytics.

## Features
- Firebase integration
- POS module
- Inventory Management
- User Profiles
- Analytics

## Setup Instructions

1. Install Firebase CLI:
   \`\`\`bash
   npm install -g firebase-tools
   \`\`\`

2. Initialize Firebase:
   \`\`\`bash
   firebase login
   firebase init
   \`\`\`

3. Deploy the application:
   \`\`\`bash
   firebase deploy
   \`\`\`
EOF

# Initialize Firebase Hosting
echo "Initializing Firebase Hosting..."
cd $PROJECT_NAME
firebase init hosting --project aenzbi-cloud --public public --single-app

# Completion Message
echo "Project structure for Cloud ERP System created successfully!"
echo "Navigate to the $PROJECT_NAME directory to start working."