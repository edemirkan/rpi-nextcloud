FROM golang:1.15.8-alpine AS go-builder

ARG DOCKER_GEN_VERSION=0.7.4
LABEL stage=intermediate

# Install build dependencies and build docker-gen
RUN apk add --no-cache --virtual .build-deps \
        curl \
        gcc \
        git \
        make \
        musl-dev \
    && go get github.com/jwilder/docker-gen \
    && cd /go/src/github.com/jwilder/docker-gen \
    && git -c advice.detachedHead=false checkout $DOCKER_GEN_VERSION \
    && make get-deps \
    && make all \
    && go clean -cache \
    && mv docker-gen /usr/local/bin/ \
    && rm -rf /go/src \
    && apk del .build-deps

FROM alpine:3.13.4

LABEL maintainer="Nicolas Duchon <nicolas.duchon@gmail.com>"

# DOCKER_GEN_VERSION environment variable is required by acme-companion
ENV DOCKER_GEN_VERSION=0.7.4 \
    DOCKER_HOST=unix:///tmp/docker.sock

# Copy docker-gen binary from build stage
COPY --from=go-builder /usr/local/bin/docker-gen /usr/local/bin/

# Get latest nginx.tmpl
ADD https://raw.githubusercontent.com/nginx-proxy/nginx-proxy/main/nginx.tmpl /etc/docker-gen/templates/

ENTRYPOINT ["/usr/local/bin/docker-gen"]
