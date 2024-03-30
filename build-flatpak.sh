#!/bin/bash
# Build the Flutter app and package into an archive.
# Exit if any command fails
set -e
# Echo all commands for debug purposes
set -x


projectName=Sitemarker

archiveName=$projectName-linux-portable.tar.gz
baseDir=$(pwd)/build/flatpak/

projectId=io.github.aerocyber.sitemarker
executableName=sitemarker

flutter pub get
flutter build linux

cd build/linux/x64/release/bundle || exit
tar -czaf $archiveName ./*
mv $archiveName "$baseDir"/

# Extract portable Flutter build.
mkdir -p $projectName
tar -xf $baseDir/$projectName-linux-portable.tar.gz -C $projectName


cp -r $projectName /app/
chmod +x /app/$projectName/$executableName
mkdir -p /app/bin
ln -s /app/$projectName/$executableName /app/bin/$executableName

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