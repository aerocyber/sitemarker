# syntax=docker/dockerfile:1

FROM quay.io/fedora/fedora-minimal:44 AS base

ENV PATH="/opt/flutter/bin:${PATH}"
ENV FLUTTER_VERSION="3.47.8"

# dnf is a slow tool. Force it to be quicker!
RUN echo "max_parallel_downloads=20" >> /etc/dnf/dnf.conf

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

RUN DRIFT_VERSION=$(grep -A 7 "drift:" pubspec.lock | grep version | head -n 1 | awk '{print $2}' | tr -d '"') && \ 
    echo "Detected drift version: $DRIFT_VERSION" && \
    wget -O web/sqlite3.wasm "https://github.com/simolus3/drift/releases/download/drift-$DRIFT_VERSION/sqlite3.wasm" && \
    wget -O web/drift_worker.js "https://github.com/simolus3/drift/releases/download/drift-$DRIFT_VERSION/drift_worker.js" && \ 
    flutter pub get

FROM base AS build
RUN dart run build_runner build && flutter build web --wasm --release

FROM scratch AS export
COPY --from=build /app/build/web /web
