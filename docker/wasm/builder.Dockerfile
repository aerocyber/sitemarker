# syntax=docker/dockerfile:1

FROM quay.io/fedora/fedora-minimal:40 AS base

ENV PATH="/opt/flutter/bin:${PATH}"
ENV FLUTTER_VERSION="3.47.1"

RUN microdnf check-update || true && \
    microdnf update -y && \
    microdnf install --nodocs -y tar git curl wget unzip xz shadow-utils which && \
    microdnf clean all

RUN cd /opt/ && \
    wget -q "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz" && \
    tar xf flutter_linux_${FLUTTER_VERSION}-stable.tar.xz && \
    rm flutter_linux_${FLUTTER_VERSION}-stable.tar.xz

RUN useradd -m -u 1000 builder && \
    chown -R builder:builder /opt/flutter && \
    mkdir -p /app && \
    chown -R builder:builder /app

USER builder
WORKDIR /app

RUN git config --global --add safe.directory /opt/flutter && \
    flutter config --no-analytics && \
    flutter precache --web

COPY --chown=builder:builder sitemarker .

RUN flutter pub get

FROM base AS build
RUN flutter build web --wasm --release

FROM scratch AS export
COPY --from=build /app/build/web /web
