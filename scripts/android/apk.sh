#!/usr/bin/bash

# Temporary directory
mkdir tmp
cd tmp

# Copy source
cp ../../../sitemarker . -r
cd sitemarker

# Get dependencies
flutter pub get

# Build
flutter build apk --release \
    --no-obfuscate \
    --split-debug-info=$VERSION-android \
    --tree-shake-icons \
    --no-pub \
    --build-number 1 \
    --build-name $VERSION 