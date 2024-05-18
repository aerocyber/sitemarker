#!/usr/bin/bash

read -p "Enter version:\t" VERSION

flutter clean

# Android Release Build
flutter build apk --release --build-name=$VERSION --split-debug-info=$VERSION-apk --no-obfuscate  # APK
flutter build aar --no-debug --build-name=$VERSION --no-profile --release --tree-shake-icons  --split-debug-info=$VERSION-aar --no-obfuscate # AAR
flutter build appbundle --tree-shake-icons --release --build-name=$VERSION --split-debug-info=$VERSION-appbundle --no-obfuscate # APPBUNDLE

# Web Release build
flutter build web --build-name=$VERSION --release --native-null-assertions --pwa-strategy=offline-first --web-resources-cdn --source-maps --dart2js-optimization O4 

# Windows Release build
flutter build windows --tree-shake-icons --release --build-name=$VERSION --split-debug-info=$VERSION-windows --no-obfuscate

# Linux snap Release build
snapcraft

# Linux flatpak Release build
flatpak install -y org.freedesktop.Sdk/x86_64/22.08
flatpak install -y org.freedesktop.Platform/x86_64/22.08
flatpak install -y flathub org.freedesktop.appstream-glib
flatpak-builder --force-clean build-dir io.github.aerocyber.sitemarker.yml --repo=repo
flatpak build-bundle repo io.github.aerocyber.sitemarker.flatpak io.github.aerocyber.sitemarker