#!/bin/bash

echo "🚀 Starting deployment to EC2..."

# Variables
APP_DIR="/home/ubuntu/task-manager-app"
BACKUP_DIR="/home/ubuntu/backups"

# Create backup of current deployment
echo "📦 Creating backup..."
mkdir -p $BACKUP_DIR
if [ -d "$APP_DIR" ]; then
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    tar -czf $BACKUP_DIR/backup_$TIMESTAMP.tar.gz -C $APP_DIR . 2>/dev/null || echo "No existing app to backup"
    
    # Keep only last 5 backups
    cd $BACKUP_DIR
    ls -t | tail -n +6 | xargs rm -f 2>/dev/null || true
fi

# Navigate to app directory
mkdir -p $APP_DIR
cd $APP_DIR

# Stop running containers
echo "🛑 Stopping existing containers..."
docker-compose down 2>/dev/null || echo "No containers to stop"

# Pull latest code (if using git)
# git pull origin main

# Build and start containers
echo "🏗️ Building Docker images..."
docker-compose build --no-cache

echo "🚀 Starting containers..."
docker-compose up

# Wait for services to start
echo "⏳ Waiting for services to start..."
sleep 15

# Health check
echo "💚 Running health check..."
if curl -f http://localhost/api/health > /dev/null 2>&1; then
    echo "✅ Deployment successful!"
    echo "✅ Application is running at http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)"
    docker-compose ps
else
    echo "❌ Health check failed! Rolling back..."
    docker-compose down
    
    # Restore from backup if available
    LATEST_BACKUP=$(ls -t $BACKUP_DIR | head -1)
    if [ ! -z "$LATEST_BACKUP" ]; then
        echo "📦 Restoring from backup: $LATEST_BACKUP"
        tar -xzf $BACKUP_DIR/$LATEST_BACKUP -C $APP_DIR
        docker-compose up
    fi
    exit 1
fi

# Cleanup old images
echo "🧹 Cleaning up old Docker images..."
docker image prune -f

echo "✅ Deployment complete!"
