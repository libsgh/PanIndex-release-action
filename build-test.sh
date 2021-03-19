#!/bin/bash -eux
source /setup-go.sh
# prepare upload URL
RELEASE_ASSETS_UPLOAD_URL=$(cat ${GITHUB_EVENT_PATH} | jq -r .release.upload_url)
RELEASE_ASSETS_UPLOAD_URL=${RELEASE_ASSETS_UPLOAD_URL%\{?name,label\}}

cd ${GITHUB_WORKSPACE}
RELEASE_TAG=$(basename ${GITHUB_REF})
BUILD_ARTIFACTS_FOLDER=build-artifacts-$(date +%s)
mkdir -p ${BUILD_ARTIFACTS_FOLDER}
flags="-X 'PanIndex/boot.VERSION=${RELEASE_TAG}' -X 'PanIndex/boot.BUILD_TIME=$(date "+%F %T")' -X 'PanIndex/boot.GO_VERSION=$(go version)'-X 'PanIndex/boot.GIT_COMMIT_SHA=$(git show -s --format=%H)'"
CC_CXX_VERSION="8"
# binary suffix
EXT=''
ASSETS_EXT='.tar.gz'
if [ $1 == 'windows' ]; then
  EXT='.exe'
  ASSETS_EXT='.zip'
fi
FILE_SUFFIX=$1-$2${ASSETS_EXT}

CGO_ENABLED=1 GOOS=linux GOARCH=amd64 go build -ldflags="$flags" -o ${BUILD_ARTIFACTS_FOLDER}/PanIndex${EXT} .
CC=o64-clang CXX=o64-clang++ GOOS=darwin GOARCH=amd64 CGO_ENABLED=1 go build -ldflags="$flags" -o ${BUILD_ARTIFACTS_FOLDER}/PanIndex${EXT} .
CC=o64-clang CXX=o64-clang++ GOOS=darwin GOARCH=arm64 CGO_ENABLED=1 go build -ldflags="$flags" -o ${BUILD_ARTIFACTS_FOLDER}/PanIndex${EXT} .
CC=arm-linux-gnueabi-gcc-$CC_CXX_VERSION CXX=arm-linux-gnueabi-g++-$CC_CXX_VERSION GOOS=linux GOARCH=arm GOARM=5 CGO_ENABLED=1 CGO_CFLAGS="-march=armv5" CGO_CXXFLAGS="-march=armv5" go build -ldflags="$flags" -o ${BUILD_ARTIFACTS_FOLDER}/PanIndex${EXT} .
CC=arm-linux-gnueabi-gcc-$CC_CXX_VERSION CXX=arm-linux-gnueabi-g++-$CC_CXX_VERSION GOOS=linux GOARCH=arm GOARM=6 CGO_ENABLED=1 CGO_CFLAGS="-march=armv6" CGO_CXXFLAGS="-march=armv6" go build -ldflags="$flags" -o ${BUILD_ARTIFACTS_FOLDER}/PanIndex${EXT} .
CC=arm-linux-gnueabihf-gcc-$CC_CXX_VERSION CXX=arm-linux-gnueabihf-g++-$CC_CXX_VERSION GOOS=linux GOARCH=arm GOARM=7 CGO_ENABLED=1 CGO_CFLAGS="-march=armv7-a -fPIC" CGO_CXXFLAGS="-march=armv7-a -fPIC" go build -ldflags="$flags" -o ${BUILD_ARTIFACTS_FOLDER}/PanIndex${EXT} .
CC=aarch64-linux-gnu-gcc-$CC_CXX_VERSION CXX=aarch64-linux-gnu-g++-$CC_CXX_VERSION GOOS=linux GOARCH=arm64 CGO_ENABLED=1 go build -ldflags="$flags" -o ${BUILD_ARTIFACTS_FOLDER}/PanIndex${EXT} .
