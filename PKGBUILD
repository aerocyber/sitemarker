# Maintainer: Aero <aerocyberdev@proton.me>
pkgname=sitemarker
pkgver=4.0.0 # TODO: Update version
pkgrel=1
pkgdesc="A cross-platform, offline-first bookmark management application."
arch=('x86_64')
url="https://github.com/aerocyber/sitemarker"
license=('Apache-2.0')
depends=('gtk3' 'sqlite' 'glibc')
makedepends=('clang' 'cmake' 'ninja' 'pkgconf' 'git' 'unzip' 'curl')

_flutter_ver="3.47.5" # TODO: Update to match target Flutter version

source=(
  "$pkgname-$pkgver.tar.gz::https://github.com/aerocyber/$pkgname/archive/refs/tags/$pkgver.tar.gz"

  "flutter-$_flutter_ver.tar.xz::https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${_flutter_ver}-stable.tar.xz"
)

sha256sums=('SKIP' 'SKIP')

build() {
  export PATH="$srcdir/flutter/bin:$PATH"
  
  # Isolate caches to the srcdir so makepkg doesn't crash from user permission blocks
  export PUB_CACHE="$srcdir/pub-cache"
  export XDG_CONFIG_HOME="$srcdir/config"
  export XDG_DATA_HOME="$srcdir/data"

  cd "$pkgname-$pkgver/sitemarker"
  
  flutter config --no-analytics
  flutter pub get
  dart run build_runner build
  flutter build linux --release
}

package() {
  cd "$pkgname-$pkgver"

  local _bundle="sitemarker/build/linux/x64/release/bundle"

  install -dm755 "$pkgdir/opt/$pkgname"
  install -dm755 "$pkgdir/usr/bin"

  cp -r "$_bundle"/* "$pkgdir/opt/$pkgname/"
  chmod -R u=rwX,go=rX "$pkgdir/opt/$pkgname"
  
  ln -sf "/opt/$pkgname/sitemarker" "$pkgdir/usr/bin/sitemarker"

  install -Dm644 "packaging/linux/flatpak/flatpak/io.github.aerocyber.sitemarker.desktop" -t "$pkgdir/usr/share/applications/"
  install -Dm644 "packaging/linux/flatpak/flatpak/io.github.aerocyber.sitemarker.appdata.xml" -t "$pkgdir/usr/share/metainfo/"
  install -Dm644 "sitemarker/windows/runner/resources/app_icon.png" "$pkgdir/usr/share/icons/hicolor/512x512/apps/sitemarker.png"
}