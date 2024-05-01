

# Set up Flutter
# Get flutter
wget "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.19.6-stable.tar.xz"
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
# Fix linking errors

# Packaging

# Check if build successful
cd build/linux/x64/release/bundle || exit 1

# Convert it to .tar.gz archive
tar -czaf $archiveName ./*
mv $archiveName "$baseDir"/