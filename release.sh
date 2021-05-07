#!/bin/bash -eux

# prepare upload URL
RELEASE_ASSETS_UPLOAD_URL=$(cat ${GITHUB_EVENT_PATH} | jq -r .release.upload_url)
RELEASE_ASSETS_UPLOAD_URL=${RELEASE_ASSETS_UPLOAD_URL%\{?name,label\}}

cd ${GITHUB_WORKSPACE}
RELEASE_TAG=$(basename ${GITHUB_REF})
BUILD_ARTIFACTS_FOLDER=build-artifacts-$(date +%s)
mkdir -p ${BUILD_ARTIFACTS_FOLDER}
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
packr2
if [ $1 == 'linux' ]&&[ $2 == '386' ]; then
# linux-386
CGO_ENABLED=1 GOOS=linux GOARCH=386 go build -ldflags="$flags" -o ${BUILD_ARTIFACTS_FOLDER}/PanIndex${EXT} .
fi

if [ $1 == 'linux' ]&&[ $2 == 'amd64' ]; then
# linux-amd64
CGO_ENABLED=1 GOOS=linux GOARCH=amd64 go build -ldflags="$flags" -o ${BUILD_ARTIFACTS_FOLDER}/PanIndex${EXT} .
fi

if [ $1 == 'linux' ]&&[ $2 == 'arm32-v5' ]; then
# linux-armv5
CC=arm-linux-gnueabi-gcc-$CC_CXX_VERSION CXX=arm-linux-gnueabi-g++-$CC_CXX_VERSION GOOS=linux GOARCH=arm GOARM=5 CGO_ENABLED=1 CGO_CFLAGS="-march=armv5" CGO_CXXFLAGS="-march=armv5" go build -ldflags="$flags" -o ${BUILD_ARTIFACTS_FOLDER}/PanIndex${EXT} .
fi
if [ $1 == 'linux' ]&&[ $2 == 'arm32-v6' ]; then
# linux-armv6
CC=arm-linux-gnueabi-gcc-$CC_CXX_VERSION CXX=arm-linux-gnueabi-g++-$CC_CXX_VERSION GOOS=linux GOARCH=arm GOARM=6 CGO_ENABLED=1 CGO_CFLAGS="-march=armv6" CGO_CXXFLAGS="-march=armv6" go build -ldflags="$flags" -o ${BUILD_ARTIFACTS_FOLDER}/PanIndex${EXT} .
fi
if [ $1 == 'linux' ]&&[ $2 == 'arm32-v7' ]; then
# linux-armv7-a
CC=arm-linux-gnueabihf-gcc-$CC_CXX_VERSION CXX=arm-linux-gnueabihf-g++-$CC_CXX_VERSION GOOS=linux GOARCH=arm GOARM=7 CGO_ENABLED=1 CGO_CFLAGS="-march=armv7-a -fPIC" CGO_CXXFLAGS="-march=armv7-a -fPIC" go build -ldflags="$flags" -o ${BUILD_ARTIFACTS_FOLDER}/PanIndex${EXT} .
fi

if [ $1 == 'linux' ]&&[ $2 == 'arm64' ]; then
# linux-arm64
CC=aarch64-linux-gnu-gcc-$CC_CXX_VERSION CXX=aarch64-linux-gnu-g++-$CC_CXX_VERSION GOOS=linux GOARCH=arm64 CGO_ENABLED=1 go build -ldflags="$flags" -o ${BUILD_ARTIFACTS_FOLDER}/PanIndex${EXT} .
fi

if [ $1 == 'windows' ]&&[ $2 == 'amd64' ]; then
# windows-amd64
CC=x86_64-w64-mingw32-gcc-posix CXX=x86_64-w64-mingw32-g++-posix GOOS=windows GOARCH=amd64 CGO_ENABLED=1 go build -ldflags="$flags" -o ${BUILD_ARTIFACTS_FOLDER}/PanIndex${EXT} .
fi

if [ $1 == 'windows' ]&&[ $2 == '386' ]; then
# windows-386
CC=i686-w64-mingw32-gcc-posix CXX=i686-w64-mingw32-g++-posix GOOS=windows GOARCH=386 CGO_ENABLED=1 go build -ldflags="$flags" -o ${BUILD_ARTIFACTS_FOLDER}/PanIndex${EXT} .
fi

if [ $1 == 'darwin' ]&&[ $2 == 'amd64' ]; then
# darwin-amd64
CC=o64-clang CXX=o64-clang++ GOOS=darwin GOARCH=amd64 CGO_ENABLED=1 go build -ldflags="$flags" -o ${BUILD_ARTIFACTS_FOLDER}/PanIndex${EXT} .
fi

if [ $1 == 'darwin' ]&&[ $2 == 'arm64' ]; then
# darwin-amd64
CC=o64-clang CXX=o64-clang++ GOOS=darwin GOARCH=arm64 CGO_ENABLED=1 CGO_ENABLED=1 go build -ldflags="$flags" -o ${BUILD_ARTIFACTS_FOLDER}/PanIndex${EXT} .
fi

cp -r LICENSE README.md ${BUILD_ARTIFACTS_FOLDER}/
cd ${BUILD_ARTIFACTS_FOLDER}

if [ $1 == 'windows' ]; then
zip -vr PanIndex-${RELEASE_TAG}-${FILE_SUFFIX} *
else
tar cvfz PanIndex-${RELEASE_TAG}-${FILE_SUFFIX} *
fi

#SHA256_SUM=$(sha256sum PanIndex-${RELEASE_TAG}-${FILE_SUFFIX} | cut -d ' ' -f 1)
sha256sum PanIndex-${RELEASE_TAG}-${FILE_SUFFIX} >> ${GITHUB_WORKSPACE}/sha256.list
# update binary
curl \
  --fail \
  -X POST \
  --data-binary @PanIndex-${RELEASE_TAG}-${FILE_SUFFIX} \
  -H 'Content-Type: application/gzip' \
  -H "Authorization: Bearer ${INPUT_GITHUB_TOKEN}" \
  "${RELEASE_ASSETS_UPLOAD_URL}?name=PanIndex-${RELEASE_TAG}-${FILE_SUFFIX}"
echo $?
