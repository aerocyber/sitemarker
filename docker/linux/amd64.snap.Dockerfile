# syntax=docker/dockerfile:1
FROM ghcr.io/canonical/snapcraft-container:core24 AS builder

ENV DEBIAN_FRONTEND=noninteractive

# Snapcraft needs basic networking and archive tools to fetch the SDK
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y curl git unzip xz-utils

WORKDIR /app
COPY . .

RUN snapcraft --destructive-mode

FROM scratch AS export
COPY --from=builder /app/*.snap /linux/