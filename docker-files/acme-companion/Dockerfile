FROM aveferrum/docker-gen:latest AS docker-gen
FROM alpine:3

ARG GIT_DESCRIBE
ARG ACMESH_VERSION=2.9.0
ARG ACME_COMPANION_VERSION=2.2.7

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
COPY --from=docker-gen /usr/local/bin/docker-gen /usr/local/bin/


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
