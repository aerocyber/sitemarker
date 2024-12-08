pkgname="sitemarker"
pkgver="2.0.0"
pkgdesc="An open source bookmark manager."
pkgrel=1
arch=('x86_64')
url="https://github.com/aerocyber/sitemarker"
makedepends=('flutter')
license=('MIT')
sha256sums=('c628847545a41c05e3ef26f44b0a21ae7adecb11bf63196e39d71adff2d93c4c')
source=("https://github.com/aerocyber/$pkgname/releases/download/$pkgver/$pkgname-$pkgver-linux.tar.xz")

package() {
	cd "$srcdir"
	mkdir -p $pkgdir/usr/bin $pkgdir/opt/sitemarker	

	cp -r $srcdir/data "$pkgdir/opt/sitemarker/"
	cp -r $srcdir/lib "$pkgdir/opt/sitemarker/"
	install -Dm777 $srcdir/sitemarker "$pkgdir/opt/sitemarker/sitemarker"
	ln -sf "$pkgdir/opt/sitemarker/sitemarker" $pkgdir/usr/bin/sitemarker
}
