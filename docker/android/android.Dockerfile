FROM ubuntu:26.10 AS base

ARG KEY_ALIAS

ENV PATH="/opt/flutter/bin:${PATH}"
ENV FLUTTER_VERSION="3.47.8"
ENV JAVA_VERSION=17

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt upgrade -y
RUN apt install -y wget curl git unzip xz-utils zip libglu1-mesa clang cmake ninja-build pkg-config build-essential openjdk-${JAVA_VERSION}-jdk-headless

FROM base AS androidtoolslocal

ENV ANDROID_SDK_ROOT="/opt/android-sdk"
ENV ANDROID_HOME="/opt/android-sdk"
ENV PATH="${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${PATH}"
# TODO: On tools upgrade, update the cmdline tools url
ENV ANDROID_SDK_CMDLINE_TOOLS_URL="https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip"

RUN mkdir -p $ANDROID_SDK_ROOT/cmdline-tools && \ 
    cd /tmp && wget -q -O cmdline-tools.zip ${ANDROID_SDK_CMDLINE_TOOLS_URL} && \ 
    unzip -q cmdline-tools.zip -d ${ANDROID_SDK_ROOT}/cmdline-tools && \
    rm cmdline-tools.zip && \
    mv ${ANDROID_SDK_ROOT}/cmdline-tools/cmdline-tools ${ANDROID_SDK_ROOT}/cmdline-tools/latest

RUN yes | sdkmanager --licenses > /dev/null

FROM androidtoolslocal AS flutter

ENV PATH="/opt/flutter/bin:${PATH}"

RUN cd /opt/ && \
    wget -q "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz" && \
    tar xf flutter_linux_${FLUTTER_VERSION}-stable.tar.xz && \
    rm flutter_linux_${FLUTTER_VERSION}-stable.tar.xz

RUN useradd -m -u 1001 builder && \
    chown -R builder:builder /opt/flutter && \
    mkdir -p /app && \
    chown -R builder:builder /app

USER builder
WORKDIR /app

RUN git config --global --add safe.directory /opt/flutter && \
    flutter config --no-analytics && \
    flutter precache --android

COPY --chown=builder:builder . .

FROM flutter AS cache

RUN cd sitemarker && flutter pub get

FROM cache AS build
WORKDIR /app/sitemarker

RUN --mount=type=secret,id=keystore,uid=1001 \ 
    --mount=type=secret,id=store_pass,uid=1001 \ 
    --mount=type=secret,id=key_pass,uid=1001 \ 
    echo "storeFile=/run/secrets/keystore" > android/key.properties && \ 
    echo "storePassword=$(cat /run/secrets/store_pass)" >> android/key.properties && \ 
    echo "keyPassword=$(cat /run/secrets/key_pass)" >> android/key.properties && \ 
    echo "keyAlias=${KEY_ALIAS}" >> android/key.properties && \ 
    export VERSION=$(grep version pubspec.yaml | awk '{print $2}' | cut -d '+' -f1) && \ 
    dart run build_runner build && \ 
    flutter build apk --release --split-debug-info sitemarker-android-$VERSION-debuginfo --split-per-abi && \ 
    if [ -f build/linux/x64/release/bundle/sitemarker/lib/libdartjni.so ]; then \ 
    patchelf --remove-rpath build/linux/x64/release/bundle/sitemarker/lib/libdartjni.so; \ 
    fi

FROM scratch AS export
COPY --from=build /app/build/app/outputs/flutter-apk/app-release.apk /android/