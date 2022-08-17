ARG DOCKER_GEN_VERSION=main

# Build docker-gen from scratch
FROM golang:1.19-alpine as go-builder

ARG DOCKER_GEN_VERSION
WORKDIR /build

# Build docker-gen
RUN apk add --no-cache --virtual .build-deps git \
    && git clone https://github.com/nginx-proxy/docker-gen \
    && cd docker-gen \
    && git -c advice.detachedHead=false checkout ${DOCKER_GEN_VERSION} \
    && go mod download \
    && GOOS=linux CGO_ENABLED=0 go build -ldflags "-X main.buildVersion=${DOCKER_GEN_VERSION}" -o docker-gen ./cmd/docker-gen

FROM alpine:3.16

# DOCKER_GEN_VERSION environment variable is required by acme-companion
ARG DOCKER_GEN_VERSION
ENV DOCKER_GEN_VERSION=${DOCKER_GEN_VERSION} \
    DOCKER_HOST=unix:///tmp/docker.sock

# Install packages required by the image
RUN apk add --no-cache --virtual .bin-deps openssl

# Copy docker-gen binary from build stage
COPY --from=go-builder /build/docker-gen/docker-gen /usr/local/bin/docker-gen

# Get latest nginx.tmpl
ADD https://raw.githubusercontent.com/nginx-proxy/nginx-proxy/main/nginx.tmpl /etc/docker-gen/templates/

ENTRYPOINT ["/usr/local/bin/docker-gen"]
