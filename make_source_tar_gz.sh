export VERSION="1.2.2"
export SRC_DIR="sitemarker-$VERSION"
mkdir $SRC_DIR
cp -r ./data ./docs ./po ./src ./io.github.aerocyber.sitemarker.json ./README.md ./$SRC_DIR

tar --create --file $SRC_DIR.tar.gz $SRC_DIR
