#!/usr/bin/env bash

export DOCKER_BUILDKIT=1

echo "==================================="
echo "+ [APK]: BUILDING ANDROID PACKAGE +"
echo "==================================="

# Don't forget to have these env vars!

# export KEYSTORE_PATH="/path/to/upload-keystore.jks"
# export STORE_PASS_PATH="/path/to/store_pass.txt"
# export KEY_PASS_PATH="/path/to/key_pass.txt"
# export KEY_ALIAS="upload" # Replace with your actual key alias

docker build \
  --progress plain \
  --build-arg KEY_ALIAS="$KEY_ALIAS" \
  --secret id=keystore,src="$KEYSTORE_PATH" \
  --secret id=store_pass,src="$STORE_PASS_PATH" \
  --secret id=key_pass,src="$KEY_PASS_PATH" \
  -f docker/android/android.Dockerfile \
  --output type=local,dest=out/ \
  .