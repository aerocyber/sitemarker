#!/usr/bin/bash

# Temporary directory for the build
mkdir tmp
cd tmp

# Copy the source
cp ../../../sitemarker . -r
cd sitemarker

# Get deps
flutter pub get

# Build
flutter build linux \
    --release \
    --no-obfuscate \
    --split-debug-info=$VERSION-linux \
    --tree-shake-icons \
    --no-pub \
    --build-number 1 \
    --build-name $VERSION 
