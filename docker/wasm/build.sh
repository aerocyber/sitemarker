#!/usr/bin/envbash

export DOCKER_BUILDKIT=1
export VERSION=$(grep version sitemarker/pubspec.yaml | awk '{print $2}' | cut -d '+' -f1)

docker build -f docker/wasm/builder.Dockerfile --output type=local,dest=out/ .
docker build -f docker/wasm/server.Dockerfile -t ghcr.io/aerocyber/sitemarker-web:latest -t ghcr.io/aerocyber/sitemarker-web:$VERSION .