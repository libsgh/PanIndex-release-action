#!/bin/bash -eux

# prepare upload URL
RELEASE_ASSETS_UPLOAD_URL=$(cat ${GITHUB_EVENT_PATH} | jq -r .release.upload_url)
RELEASE_ASSETS_UPLOAD_URL=${RELEASE_ASSETS_UPLOAD_URL%\{?name,label\}}

cd ${GITHUB_WORKSPACE}

RELEASE_TAG=$(basename ${GITHUB_REF})
BUILD_ARTIFACTS_FOLDER=build-artifacts-$(date +%s)
mkdir -p ${BUILD_ARTIFACTS_FOLDER}
flags="-X 'main.VERSION=${RELEASE_TAG}' -X 'main.BUILD_TIME=$(date "+%F %T")' -X 'main.GO_VERSION=$(go version)'-X 'main.GIT_COMMIT_SHA=$(git show -s --format=%H)'"
# binary suffix
EXT=''
ASSETS_EXT='.tar.gz'
if [ $1 == 'windows' ]; then
  EXT='.exe'
  ASSETS_EXT='.zip'
fi
FILE_SUFFIX=$1-$2${ASSETS_EXT}
if [ $1 == 'linux' ]&&[ $2 == '386' ]; then
# linux-386
CGO_ENABLED=1 GOOS=linux GOARCH=386 go build -ldflags="$flags" -o ${BUILD_ARTIFACTS_FOLDER}/PanIndex${EXT}
fi

if [ $1 == 'linux' ]&&[ $2 == 'amd64' ]; then
# linux-amd64
CGO_ENABLED=1 GOOS=linux GOARCH=amd64 go build -ldflags="$flags" -o ${BUILD_ARTIFACTS_FOLDER}/PanIndex${EXT}
fi

if [ $1 == 'linux' ]&&[ $2 == 'arm32-v7' ]; then
# linux-armv7-a
CC=arm-linux-gnueabihf-gcc-5 CXX=arm-linux-gnueabihf-g++-5 GOOS=linux GOARCH=arm GOARM=7 CGO_ENABLED=1 CGO_CFLAGS="-march=armv7-a -fPIC" CGO_CXXFLAGS="-march=armv7-a -fPIC" go build -ldflags="$flags" -o ${BUILD_ARTIFACTS_FOLDER}/PanIndex${EXT}
fi

if [ $1 == 'linux' ]&&[ $2 == 'arm64' ]; then
# linux-arm64
CC=aarch64-linux-gnu-gcc-5 CXX=aarch64-linux-gnu-g++-5 GOOS=linux GOARCH=arm64 CGO_ENABLED=1 go build -ldflags="$flags" -o ${BUILD_ARTIFACTS_FOLDER}/PanIndex${EXT}
fi

if [ $1 == 'windows' ]&&[ $2 == 'amd64' ]; then
# windows-amd64
CC=x86_64-w64-mingw32-gcc-posix CXX=x86_64-w64-mingw32-g++-posix GOOS=windows GOARCH=amd64 CGO_ENABLED=1 go build -ldflags="$flags" -o ${BUILD_ARTIFACTS_FOLDER}/PanIndex${EXT}
fi

if [ $1 == 'windows' ]&&[ $2 == '386' ]; then
# windows-386
CC=i686-w64-mingw32-gcc-posix CXX=i686-w64-mingw32-g++-posix GOOS=windows GOARCH=386 CGO_ENABLED=1 go build -ldflags="$flags" -o ${BUILD_ARTIFACTS_FOLDER}/PanIndex${EXT}
fi

if [ $1 == 'darwin' ]&&[ $2 == 'amd64' ]; then
# darwin-amd64
CC=o64-clang CXX=o64-clang++ GOOS=darwin GOARCH=amd64 CGO_ENABLED=1 go build -ldflags="$flags" -o ${BUILD_ARTIFACTS_FOLDER}/PanIndex${EXT}
fi

if [ $1 == 'darwin' ]&&[ $2 == '386' ]; then
# darwin-386
CC=o32-clang CXX=o32-clang++ GOOS=darwin GOARCH=386 CGO_ENABLED=1 go build -ldflags="$flags" -o ${BUILD_ARTIFACTS_FOLDER}/PanIndex${EXT}
fi

cp -r LICENSE README.md config/config.json ${BUILD_ARTIFACTS_FOLDER}/
cd ${BUILD_ARTIFACTS_FOLDER}

if [ $1 == 'windows' ]; then
zip -vr PanIndex-${RELEASE_TAG}-${FILE_SUFFIX} *
else
tar cvfz PanIndex-${RELEASE_TAG}-${FILE_SUFFIX} *
fi

MD5_SUM=$(md5sum PanIndex-${RELEASE_TAG}-${FILE_SUFFIX} | cut -d ' ' -f 1)
#SHA1_SUM=$(sha1sum PanIndex-${RELEASE_TAG}-${FILE_SUFFIX} | cut -d ' ' -f 1)
#SHA256_SUM=$(sha256sum PanIndex-${RELEASE_TAG}-${FILE_SUFFIX} | cut -d ' ' -f 1)
#SHA512_SUM=$(sha512sum PanIndex-${RELEASE_TAG}-${FILE_SUFFIX} | cut -d ' ' -f 1)

# update binary and checksum
curl \
  --fail \
  -X POST \
  --data-binary @PanIndex-${RELEASE_TAG}-${FILE_SUFFIX} \
  -H 'Content-Type: application/gzip' \
  -H "Authorization: Bearer ${INPUT_GITHUB_TOKEN}" \
  "${RELEASE_ASSETS_UPLOAD_URL}?name=PanIndex-${RELEASE_TAG}-${FILE_SUFFIX}"
echo $?

curl \
  --fail \
  -X POST \
  --data $MD5_SUM \
  -H 'Content-Type: text/plain' \
  -H "Authorization: Bearer ${INPUT_GITHUB_TOKEN}" \
  "${RELEASE_ASSETS_UPLOAD_URL}?name=PanIndex-${RELEASE_TAG}-${FILE_SUFFIX}.md5"
echo $?