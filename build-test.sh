#!/bin/bash -eux
source /setup-go.sh
# prepare upload URL
git clone https://github.com/libsgh/PanIndex.git
cd PanIndex
RELEASE_TAG=v1.0.6-test
mkdir dist
flags="-X 'PanIndex/boot.VERSION=${RELEASE_TAG}' -X 'PanIndex/boot.BUILD_TIME=$(date "+%F %T")' -X 'PanIndex/boot.GO_VERSION=$(go version)'-X 'PanIndex/boot.GIT_COMMIT_SHA=$(git show -s --format=%H)'"
CC_CXX_VERSION="6"
# binary suffix
EXT=''
ASSETS_EXT='.tar.gz'
if [ $1 == 'windows' ]; then
  EXT='.exe'
  ASSETS_EXT='.zip'
fi
FILE_SUFFIX=$1-$2${ASSETS_EXT}

CGO_ENABLED=1 GOOS=linux GOARCH=amd64 go build -ldflags="$flags" -o dist/PanIndex-linux-amd64${EXT} .
CC=o64-clang CXX=o64-clang++ GOOS=darwin GOARCH=amd64 CGO_ENABLED=1 go build -ldflags="$flags" -o dist/PanIndex-darwin-amd64${EXT} .
CC=o64-clang CXX=o64-clang++ GOOS=darwin GOARCH=arm64 CGO_ENABLED=1 go build -ldflags="$flags" -o dist/PanIndex-darwin-arm64${EXT} .
CC=arm-linux-gnueabi-gcc-$CC_CXX_VERSION CXX=arm-linux-gnueabi-g++-$CC_CXX_VERSION GOOS=linux GOARCH=arm GOARM=5 CGO_ENABLED=1 CGO_CFLAGS="-march=armv5" CGO_CXXFLAGS="-march=armv5" go build -ldflags="$flags" -o dist/PanIndex-linux-armv5${EXT} .
CC=arm-linux-gnueabi-gcc-$CC_CXX_VERSION CXX=arm-linux-gnueabi-g++-$CC_CXX_VERSION GOOS=linux GOARCH=arm GOARM=6 CGO_ENABLED=1 CGO_CFLAGS="-march=armv6" CGO_CXXFLAGS="-march=armv6" go build -ldflags="$flags" -o dist/PanIndex-linux-armv6${EXT} .
CC=arm-linux-gnueabihf-gcc-$CC_CXX_VERSION CXX=arm-linux-gnueabihf-g++-$CC_CXX_VERSION GOOS=linux GOARCH=arm GOARM=7 CGO_ENABLED=1 CGO_CFLAGS="-march=armv7-a -fPIC" CGO_CXXFLAGS="-march=armv7-a -fPIC" go build -ldflags="$flags" -o dist/PanIndex-linux-armv7${EXT} .
CC=aarch64-linux-gnu-gcc-$CC_CXX_VERSION CXX=aarch64-linux-gnu-g++-$CC_CXX_VERSION GOOS=linux GOARCH=arm64 CGO_ENABLED=1 go build -ldflags="$flags" -o dist/PanIndex-linux-arm64${EXT} .
cd dist
ls -n