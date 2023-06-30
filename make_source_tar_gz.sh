export VERSION="1.2.0"
export SRC_DIR="sitemarker-$VERSION"
cp ./data ./docs ./po ./src ./io.github.aerocyber.sitemarker.json ./README.md ./$SRC_DIR

tar --create --file $SRC_DIR.tar.gz $SRC_DIR