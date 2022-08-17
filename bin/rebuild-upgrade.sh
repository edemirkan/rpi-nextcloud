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

# 2. Build docker-gen
docker compose build --no-cache docker-gen

# 2.1 Push updated docker-gen image
docker push aveferrum/docker-gen:latest

# 3. Build acme-companion
docker compose build --no-cache acme-companion

# 3.1 Push updated acme-companion image
docker push aveferrum/acme-companion:latest

# 4. Update local images
docker compose pull

# 5. Restart services
docker compose up -d
