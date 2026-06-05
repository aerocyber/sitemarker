# syntax=docker/dockerfile:1

FROM fedora:44 AS base
ENV SITEMARKER_PLATFORM=amd64
ENV PATH="${PATH}:/opt/flutter/bin"

WORKDIR /app

COPY ../.. .

RUN dnf check-update; dnf update -y; \
    dnf group install "C Development Tools and Libraries" "Development Tools" -y; \
    dnf install which bash file git curl wget zip unzip mesa-libGLU-devel mesa-libGLU libstdc++ libstdc++-devel clang cmake ninja-build gtk3-devel -y

RUN cd /opt/; \
    wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.22.1-stable.tar.xz; \
    tar xf flutter_linux_3.22.1-stable.tar.xz; \
    export PATH="$PATH:$(pwd)/flutter/bin"

RUN cd /app; \
    flutter pub get

FROM base AS build
RUN flutter build linux --release --tree-shake-icons --split-debug-info ${SITEMARKER_PLATFORM}-DEBUGINFO --no-obfuscate

FROM scratch AS binaries
COPY --from=build build/linux/amd64/release/bundle /linux-build

