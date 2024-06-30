# Temporary directory for the build
mkdir tmp
cd tmp

# Copy the source
cp ../../../sitemarker . -r
cd sitemarker

# Get deps
flutter pub get

flutter build windows --no-pub --release --no-obfuscate --split-debug-info=$VERSION-windows --tree-shake-icons --build-number 1 --build-name $VERSION