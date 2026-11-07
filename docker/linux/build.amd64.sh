# Replace with actual key id
# export GPG_KEY_ID=""
# Replace with actual private key path
# export GPG_PRIVATE_PATH="/path/to/your/private.key"
# export GPG_PASS_PATH="/path/to/gpg_pass.txt"

export DOCKER_BUILDKIT=1

echo "============================================"
echo "+ [BINARY]: BUILDING FLUTTER APPLICATION +"
echo "============================================"

docker build \
  --progress plain \
  --build-arg GPG_KEY_ID="$GPG_KEY_ID" \
  --secret id=gpg_private_key,src="$GPG_PRIVATE_PATH" \
  --secret id=gpg_passphrase,src="$GPG_PASS_PATH" \
  -f docker/linux/amd64.package.Dockerfile \
  --output type=local,dest=out/ \
  .

# echo "==================================="
# echo "+ [SNAP]: BUILDING SNAP PACKAGE +"
# echo "==================================="

# docker build \
#   --progress plain \
#   -f docker/linux/amd64.snap.Dockerfile \
#   --output type=local,dest=out/ \
#   .