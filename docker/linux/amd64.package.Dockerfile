# syntax=docker/dockerfile:1

# Base setup
FROM ubuntu:20.04 AS base

ARG GPG_KEY_ID

ENV PATH="/opt/flutter/bin:${PATH}"
ENV FLUTTER_VERSION="3.47.8"

# Map the args to env for later use
ENV GPG_KEY_ID=${GPG_KEY_ID}
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt upgrade -y
RUN apt install -y wget curl git unzip xz-utils zip libglu1-mesa clang cmake ninja-build pkg-config libgtk-3-dev build-essential patchelf dpkg-dev debhelper


# Extend the base for individual deployments
FROM base AS extension

# Install nfpm
RUN echo 'deb [trusted=yes] https://repo.goreleaser.com/apt/ /' | tee /etc/apt/sources.list.d/goreleaser.list && \ 
    apt update && \ 
    apt install -y nfpm



# Install flutter
FROM extension AS flutter

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
    flutter precache --linux

COPY --chown=builder:builder . .



# Set up package cache
FROM flutter AS cache
RUN cd sitemarker && flutter pub get



# Builds
FROM cache AS build
WORKDIR /app/sitemarker

RUN export VERSION=$(grep version pubspec.yaml | awk '{print $2}' | cut -d '+' -f1) && \ 
    dart run build_runner build && \ 
    flutter build linux --release --split-debug-info sitemarker-linux-amd64-$VERSION-debuginfo && \ 
    if [ -f build/linux/x64/release/bundle/sitemarker/lib/libdartjni.so ]; then \ 
    patchelf --remove-rpath build/linux/x64/release/bundle/sitemarker/lib/libdartjni.so; \ 
    fi



# Packaging layer
FROM build AS package
WORKDIR /app/sitemarker

RUN echo "export VERSION=$(grep version pubspec.yaml | awk '{print $2}' | cut -d '+' -f1)" > /tmp/get_app_version.sh
RUN . /tmp/get_app_version.sh && \ 
    mkdir -p build/linux/x64/release/bundle/data && \ 
    echo "binary" > build/linux/x64/release/bundle/data/package_format.txt && \ 
    tar -cJf sitemarker-${VERSION}-amd64.tar.xz build/linux/x64/release/bundle

RUN . /tmp/get_app_version.sh && \ 
    tar -cJf sitemarker-${VERSION}-amd64-DEBUGINFO.tar.xz sitemarker-linux-amd64-$VERSION-debuginfo

# Package the app to deb format
RUN . /tmp/get_app_version.sh && \ 
    export VERSION="$VERSION" && \ 
    mkdir -p build/linux/x64/release/bundle/data && \ 
    echo "deb" > build/linux/x64/release/bundle/data/package_format.txt && \ 
    cd .. && nfpm pkg --config nfpm.yaml --packager deb --target sitemarker/build/linux/x64/release

# Package the app to rpm and srpm format
RUN . /tmp/get_app_version.sh && \ 
    export VERSION="$VERSION" && \ 
    mkdir -p build/linux/x64/release/bundle/data && \ 
    echo "rpm" > build/linux/x64/release/bundle/data/package_format.txt && \
    cd .. && nfpm pkg --config nfpm.yaml --packager rpm --target sitemarker/build/linux/x64/release && \ 
    nfpm pkg --config nfpm.yaml --packager srpm --target sitemarker/build/linux/x64/release

RUN . /tmp/get_app_version.sh && \ 
    cat <<EOF > ../packaging/linux/deb/debian/changelog
sitemarker (${VERSION}-1) jammy; urgency=medium

  * Automated release ${VERSION}.

 -- Aero <aerocyberdev@proton.me>  $(date -R)
EOF

RUN --mount=type=secret,id=gpg_private_key,uid=1000 \ 
    --mount=type=secret,id=gpg_passphrase,uid=1000 \ 
    gpg --batch --import /run/secrets/gpg_private_key && \ 
    . /tmp/get_app_version.sh && \ 
    # Debian source packaging steps starts now
    mkdir -p ../sitemarker-${VERSION}-amd64/bundle && \ 
    # Copy binaries
    mkdir -p build/linux/x64/release/bundle/data && \ 
    echo "deb-src" > build/linux/x64/release/bundle/data/package_format.txt && \ 
    cp -r build/linux/x64/release/bundle/* ../sitemarker-${VERSION}-amd64/bundle/ && \ 
    # Copy supporting resources
    cp ../packaging/linux/flatpak/flatpak/io.github.aerocyber.sitemarker.desktop ../sitemarker-${VERSION}-amd64/ && \ 
    cp ../packaging/linux/flatpak/flatpak/io.github.aerocyber.sitemarker.appdata.xml ../sitemarker-${VERSION}-amd64/ && \ 
    cp ../packaging/windows/sitemarker-1024x1024.png ../sitemarker-${VERSION}-amd64/sitemarker.png && \ 
    cp -r ../packaging/linux/deb/debian ../sitemarker-${VERSION}-amd64/ && \ 
    # Create origin tarball
    tar -czf ../sitemarker_${VERSION}.orig.tar.gz -C .. sitemarker-${VERSION}-amd64 && \ 
    # Build it
    cd ../sitemarker-${VERSION}-amd64 && \ 
    echo '#!/bin/sh' > /tmp/sign.sh && \
    echo 'exec gpg --batch --pinentry-mode=loopback --passphrase-file /run/secrets/gpg_passphrase "$@"' >> /tmp/sign.sh && \
    chmod +x /tmp/sign.sh && \
    dpkg-buildpackage -S -k"$GPG_KEY_ID" -p/tmp/sign.sh

# Package as appimage file as well
RUN wget -q -O /tmp/appimagetool "https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage" && \ 
    chmod +x /tmp/appimagetool

RUN --mount=type=secret,id=gpg_private_key,uid=1000 \ 
    --mount=type=secret,id=gpg_passphrase,uid=1000 \ 
    gpg --batch --import /run/secrets/gpg_private_key && \ 
    . /tmp/get_app_version.sh && \ 
    mkdir -p AppDir/usr/bin && \ 
    cp -r build/linux/x64/release/bundle/* AppDir/usr/bin/ && \ 
    cp ../packaging/linux/flatpak/flatpak/io.github.aerocyber.sitemarker.desktop AppDir/sitemarker.desktop && \ 
    cp ../packaging/windows/sitemarker-1024x1024.png AppDir/sitemarker.png && \ 
    ln -s usr/bin/sitemarker AppDir/AppRun && \ 
    echo "appimage" > AppDir/usr/bin/data/package_format.txt && \ 
    APPIMAGE_EXTRACT_AND_RUN=1 /tmp/appimagetool -u "gh-releases-zsync|aerocyber|sitemarker|latest|sitemarker-*-amd64.AppImage.zsync" AppDir sitemarker-${VERSION}-amd64.AppImage && \ 
    # Sign the binary
    gpg --batch --pinentry-mode=loopback --passphrase-file /run/secrets/gpg_passphrase --yes --detach-sign --armor --local-user "$GPG_KEY_ID" sitemarker-${VERSION}-amd64.AppImage

FROM scratch AS export
COPY --from=package /app/sitemarker/sitemarker-*.tar.xz /linux/
COPY --from=package /app/sitemarker/build/linux/x64/release/*.deb /linux/
COPY --from=package /app/sitemarker/build/linux/x64/release/*.rpm /linux/
# Export all generated Debian source package files from /app
COPY --from=package /app/sitemarker_*.orig.tar.gz /linux/
COPY --from=package /app/sitemarker_*.dsc /linux/
COPY --from=package /app/sitemarker_*.buildinfo /linux/
COPY --from=package /app/sitemarker_*.changes /linux/
# Copy the appimage file
COPY --from=package /app/sitemarker/*.AppImage /linux/
COPY --from=package /app/sitemarker/*.AppImage.asc /linux/
COPY --from=package /app/sitemarker/*.AppImage.zsync /linux/