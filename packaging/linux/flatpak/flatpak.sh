#!/usr/bin/bash

# Set up Flutter
# Get flutter
wget "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.27.0-stable.tar.xz"
# Decompress it
tar xf flutter_linux_3.19.6-stable.tar.xz
# Add it to PATH
export PATH="$PATH:$(pwd)flutter/bin/"


# Set up project
git clone https://github.com/aerocyber/sitemarker
cd sitemarker

# Build it
flutter pub get
flutter build linux --tree-shake-icons --release --build-name=$VERSION --split-debug-info=$VERSION-linux --no-obfuscate

# Packaging

# Check if build successful
cd build/linux/x64/release/bundle || exit 1

# Fix linking errors
cd lib
patchelf --set-rpath '$ORIGIN' libsqlite3_flutter_libs_plugin.so
patchelf --set-rpath '$ORIGIN' liburl_launcher_linux_plugin.so

# Copy it
cd ..
mkdir -p /app/sitemarker
cp -r ./* /app/sitemarker
chmod +x /app/sitemarker/sitemarker
ln -s /app/sitemarker /app/bin/sitemarker

# Move back to project home
cd ../../../../..

# Install the icon.
iconDir=/app/share/icons/hicolor/scalable/apps
mkdir -p $iconDir
cp -r assets/icons/$projectId.svg $iconDir/

# Install the desktop file.
desktopFileDir=/app/share/applications
mkdir -p $desktopFileDir
cp -r packaging/linux/$projectId.desktop $desktopFileDir/

# Install the AppStream metadata file.
metadataDir=/app/share/metainfo
mkdir -p $metadataDir
cp -r packaging/linux/$projectId.metainfo.xml $metadataDir/
