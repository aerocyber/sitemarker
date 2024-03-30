export VERSION="2.0.0"
export SRC_DIR="sitemarker-$VERSION"
mkdir ../$SRC_DIR
cp -r * ../$SRC_DIR

tar --create --file ../$SRC_DIR.tar.gz ../$SRC_DIR
rm -r ../$SRC_DIR
xdg-open ..
