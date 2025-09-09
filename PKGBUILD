pkgname="sitemarker"
pkgver="3.1.2"
pkgdesc="An open source bookmark manager."
pkgrel=1
arch=('x86_64')
url="https://github.com/aerocyber/sitemarker"
makedepends=('flutter')
license=('Apache-2.0')
sha256sums=('sha256:80f49dc729d4d65224adf418ec9965bc06061e47501d6eff3ed43f39f2ab1c66')
source=("https://github.com/aerocyber/$pkgname/releases/download/$pkgver/$pkgname-$pkgver-linux.tar.xz")

package() {
	cd "$srcdir"
	mkdir -p $pkgdir/usr/bin $pkgdir/opt/sitemarker	

	cp -r $srcdir/data "$pkgdir/opt/sitemarker/"
	cp -r $srcdir/lib "$pkgdir/opt/sitemarker/"
	install -Dm777 $srcdir/sitemarker "$pkgdir/opt/sitemarker/sitemarker"
	ln -sf "$pkgdir/opt/sitemarker/sitemarker" $pkgdir/usr/bin/sitemarker
}
