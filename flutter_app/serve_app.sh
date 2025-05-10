#!/bin/bash

# Ensure the script exits on error
set -e

echo "Starting Khalfan Center Flutter Web App"

# Path to env.js
ENV_JS="web/env.js"

# Update env.js with actual environment variables
echo "Updating environment variables in $ENV_JS"

# Read the original content
CONTENT=$(cat $ENV_JS)

# Replace placeholders with actual environment variables
CONTENT="${CONTENT//%VITE_FIREBASE_API_KEY%/$VITE_FIREBASE_API_KEY}"
CONTENT="${CONTENT//%VITE_FIREBASE_PROJECT_ID%/$VITE_FIREBASE_PROJECT_ID}"
CONTENT="${CONTENT//%VITE_FIREBASE_APP_ID%/$VITE_FIREBASE_APP_ID}"

# Write the updated content back to the file
echo "$CONTENT" > $ENV_JS

echo "Environment variables updated successfully"

# Start the Flutter web server
echo "Starting Flutter web server on port 5000"
flutter run -d web-server --web-port 5000 --web-hostname 0.0.0.0