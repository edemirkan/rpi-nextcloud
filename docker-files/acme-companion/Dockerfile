FROM golang:1.16.5-alpine AS go-builder

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

FROM alpine:3.13.5

LABEL maintainer="Nicolas Duchon <nicolas.duchon@gmail.com> (@buchdag)"

ARG GIT_DESCRIBE
ARG ACMESH_VERSION=2.8.8
ARG ACME_COMPANION_VERSION=2.1.0

ENV COMPANION_VERSION=$GIT_DESCRIBE \
    DOCKER_HOST=unix:///var/run/docker.sock \
    PATH=$PATH:/app

# Install packages required by the image
RUN apk add --no-cache --virtual .bin-deps \
        bash \
        coreutils \
        curl \
        jq \
        openssl \
        socat

# Copy docker-gen binary from build stage
COPY --from=go-builder /usr/local/bin/docker-gen /usr/local/bin/


# Install acme.sh and the letsencrypt service
RUN mkdir /companion-src \
    && curl -sSL https://github.com/nginx-proxy/acme-companion/archive/refs/tags/v${ACME_COMPANION_VERSION}.tar.gz \
    | tar -C /companion-src -xz \
    && mv /companion-src/acme-companion-${ACME_COMPANION_VERSION}/app /app \
    && /companion-src/acme-companion-${ACME_COMPANION_VERSION}/install_acme.sh \
    && rm -rf /companion-src

WORKDIR /app

ENTRYPOINT [ "/bin/bash", "/app/entrypoint.sh" ]
CMD [ "/bin/bash", "/app/start.sh" ]
