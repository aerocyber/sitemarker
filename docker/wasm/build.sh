docker build -f docker/wasm/builder.Dockerfile --output type=local,dest=out/ .
docker build -f docker/wasm/server.Dockerfile -t ghcr.io/aerocyber/sitemarker-web:latest .