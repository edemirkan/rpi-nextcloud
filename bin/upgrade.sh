#!/usr/bin/env bash

# 1. Check if .env file exists

if [ -e .env ]; then
    echo ".env file found, sourcing contents..."
    source .env
else 
    echo "########################################################################"
    echo "# Please set up your .env file before starting your cloud environment. #"
    echo "########################################################################"
    exit 1
fi

# 1. Update local images
docker compose pull

# 2. Restart services
docker compose up -d
