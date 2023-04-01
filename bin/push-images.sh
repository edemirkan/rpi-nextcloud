#!/usr/bin/env bash

# 1 Push updated docker-gen image
docker push aveferrum/docker-gen:latest

# 2 Push updated acme-companion image
docker push aveferrum/acme-companion:latest
