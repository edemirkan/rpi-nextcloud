FROM golang:1.16-alpine AS go-builder

ARG DOCKER_GEN_VERSION=0.7.6
LABEL stage=intermediate

# Build docker-gen
RUN apk add --no-cache --virtual .build-deps git \
    && git clone https://github.com/nginx-proxy/docker-gen \
    && cd /go/docker-gen \
    && git -c advice.detachedHead=false checkout $DOCKER_GEN_VERSION \
    && go mod download \
    && CGO_ENABLED=0 go build -ldflags "-X main.buildVersion=${VERSION}" -o docker-gen ./cmd/docker-gen \
    && go clean -cache \
    && mv docker-gen /usr/local/bin/ \
    && cd - \
    && rm -rf /go/docker-gen \
    && apk del .build-deps

FROM alpine:3.13

LABEL maintainer="Jason Wilder <mail@jasonwilder.com>"

# DOCKER_GEN_VERSION environment variable is required by acme-companion
ENV DOCKER_GEN_VERSION=0.7.6 \
    DOCKER_HOST=unix:///tmp/docker.sock

# Copy docker-gen binary from build stage
COPY --from=go-builder /usr/local/bin/docker-gen /usr/local/bin/

# Get latest nginx.tmpl
ADD https://raw.githubusercontent.com/nginx-proxy/nginx-proxy/main/nginx.tmpl /etc/docker-gen/templates/

ENTRYPOINT ["/usr/local/bin/docker-gen"]
