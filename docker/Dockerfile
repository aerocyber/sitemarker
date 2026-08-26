# syntax=docker/dockerfile:1

FROM fedora:40 AS base

ARG SITEMARKER_PLATFORM=amd64
ENV PATH="/opt/flutter/bin:${PATH}"
ENV FLUTTER_VERSION="3.47.1"
# Required to run appimagetool inside a Docker container without FUSE
ENV APPIMAGE_EXTRACT_AND_RUN=1 

# 1. Install toolchain, wget, and nFPM via the GoReleaser repository
RUN echo -e '[goreleaser]\nname=GoReleaser\nbaseurl=https://repo.goreleaser.com/yum/\nenabled=1\ngpgcheck=0' > /etc/yum.repos.d/goreleaser.repo && \
    dnf check-update || true && \
    dnf update -y && \
    dnf group install "C Development Tools and Libraries" "Development Tools" -y && \
    dnf install -y which bash file git curl wget zip unzip mesa-libGLU-devel mesa-libGLU libstdc++ libstdc++-devel clang cmake ninja-build gtk3-devel patchelf xz shadow-utils nfpm && \
    dnf clean all

# 2. Download AppImageTool and Flutter SDK
RUN cd /opt && \
    wget -q "https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage" && \
    chmod +x appimagetool-x86_64.AppImage && \
    wget -q "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz" && \
    tar xf flutter_linux_${FLUTTER_VERSION}-stable.tar.xz && \
    rm flutter_linux_${FLUTTER_VERSION}-stable.tar.xz

# 3. Create non-root builder user
RUN useradd -m -u 1000 builder && \
    chown -R builder:builder /opt/flutter /opt/appimagetool-x86_64.AppImage && \
    mkdir -p /app && \
    chown -R builder:builder /app

USER builder
WORKDIR /app

# 4. Configure Git and warm up Linux cache
RUN git config --global --add safe.directory /opt/flutter && \
    flutter config --no-analytics && \
    flutter config --enable-linux-desktop && \
    flutter precache --linux

# 5. Copy project files
COPY --chown=builder:builder sitemarker .

RUN flutter pub get

FROM base AS build
ARG SITEMARKER_PLATFORM=amd64
ARG APP_VERSION="1.0.0"

# Step A: Build the raw bundle
RUN flutter build linux --release --tree-shake-icons --split-debug-info ${SITEMARKER_PLATFORM}-DEBUGINFO --no-obfuscate && \
    patchelf --set-rpath '$ORIGIN:$ORIGIN/lib' build/linux/x64/release/bundle/sitemarker && \
    if [ -f build/linux/x64/release/bundle/lib/libdartjni.so ]; then \
    patchelf --set-rpath '$ORIGIN' build/linux/x64/release/bundle/lib/libdartjni.so; \
    fi

# Create a master output directory for all packages
RUN mkdir -p build/linux/dist/amd64

# Step B: Create The Raw Tarball
RUN tar -czf build/linux/dist/sitemarker-linux-${SITEMARKER_PLATFORM}.tar.gz -C build/linux/x64/release/ bundle

# Step C: Create the AppImage
RUN mkdir -p AppDir/usr/bin AppDir/usr/lib AppDir/usr/share/applications AppDir/usr/share/icons/hicolor/256x256/apps && \
    cp -r build/linux/x64/release/bundle/* AppDir/usr/bin/ && \
    echo -e "[Desktop Entry]\nName=Sitemarker\nExec=sitemarker\nIcon=sitemarker\nType=Application\nCategories=Utility;" > AppDir/sitemarker.desktop && \
    echo -e "#!/bin/sh\nHERE=\"\$(dirname \"\$(readlink -f \"\${0}\")\")\"\nexport LD_LIBRARY_PATH=\"\${HERE}/usr/bin/lib:\${LD_LIBRARY_PATH}\"\nexec \"\${HERE}/usr/bin/sitemarker\" \"\$@\"" > AppDir/AppRun && \
    chmod +x AppDir/AppRun && \
    touch AppDir/sitemarker.png && \
    /opt/appimagetool-x86_64.AppImage AppDir build/linux/dist/sitemarker-${SITEMARKER_PLATFORM}.AppImage

# Step D: Create the DEB and RPM via nFPM
# Step D: Create the DEB and RPM via nFPM
RUN echo -e "name: sitemarker\narch: amd64\nplatform: linux\nversion: ${APP_VERSION}\nsection: default\npriority: extra\nmaintainer: Aero\ndescription: Sitemarker\nvendor: Sitemarker\nhomepage: https://github.com/aerocyber/sitemarker\nlicense: MIT\ncontents:\n  - src: build/linux/x64/release/bundle/\n    dst: /opt/sitemarker\n    type: tree\n  - src: /opt/sitemarker/sitemarker\n    dst: /usr/bin/sitemarker\n    type: symlink" > nfpm.yaml && \
    nfpm pkg --packager deb --target build/linux/dist/ && \
    nfpm pkg --packager rpm --target build/linux/dist/

FROM scratch AS binaries
COPY --from=build /app/build/linux/dist /linux-build/amd64