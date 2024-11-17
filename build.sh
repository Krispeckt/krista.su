#!/bin/bash

APP_NAME="krista"

BUILD_DIR="./build"

platforms=(
  "linux/amd64"
  "linux/arm"
  "linux/arm64"
  "darwin/amd64"
  "darwin/arm64"
  "windows/amd64"
  "windows/386"
  "freebsd/amd64"
  "freebsd/386"
  "freebsd/arm"
)

mkdir -p $BUILD_DIR

build() {
  GOOS=$1
  GOARCH=$2
  output_name="${BUILD_DIR}/${APP_NAME}-${GOOS}-${GOARCH}"
  if [ "$GOOS" = "windows" ]; then
    output_name+='.exe'
  fi
  echo "Building for $GOOS/$GOARCH..."
  env GOOS=$GOOS GOARCH=$GOARCH go build -o $output_name .
  if [ $? -ne 0 ]; then
    echo "Error: Build failed for $GOOS/$GOARCH"
  else
    echo "Build successful: $output_name"
  fi
}

# Цикл по всем платформам и архитектурам
for platform in "${platforms[@]}"
do
  # shellcheck disable=SC2206
  platform_split=(${platform//\// })
  GOOS=${platform_split[0]}
  GOARCH=${platform_split[1]}
  # shellcheck disable=SC2086
  build $GOOS $GOARCH
done

echo "All builds completed!"