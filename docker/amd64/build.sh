cd .
cd ../..
docker build -f docker/amd64/Dockerfile --output type=local,dest=out/ .
cd out/linux-build
xdg-open .