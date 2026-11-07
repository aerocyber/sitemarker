# syntax=docker/dockerfile:1
FROM ghcr.io/canonical/snapcraft-container:core24 AS builder

ENV DEBIAN_FRONTEND=noninteractive

# Snapcraft needs basic networking and archive tools to fetch the SDK
RUN apt-get update && \
    apt-get install -y curl git unzip xz-utils snapd && \ 
    snap install snapcraft --classic

FROM builder AS snapbuild

WORKDIR /app
COPY . .

RUN mkdir -p /usr/share/snapcraft/extensions/desktop && \
    find /usr/lib /usr/local/lib -type d -path "*/snapcraft/extensions/desktop/command-chain" 2>/dev/null | head -n 1 | xargs -I {} ln -s {} /usr/share/snapcraft/extensions/desktop/command-chain || true

# Use the updated pack command syntax
RUN snapcraft pack

RUN snapcraft --destructive-mode

FROM scratch AS export
COPY --from=snapbuild /app/*.snap /linux/