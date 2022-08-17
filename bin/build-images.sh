#!/usr/bin/env bash

# 1. Build docker-gen
docker build --pull --rm -t aveferrum/docker-gen:latest -f ./docker-files/docker-gen/Dockerfile ./docker-files/docker-gen

# 2. Build acme-companion
docker build --pull --rm -t aveferrum/acme-companion:latest -f ./docker-files/acme-companion/Dockerfile ./docker-files/acme-companion

# 4. Update local images and restart services
docker compose pull && docker compose up -d
