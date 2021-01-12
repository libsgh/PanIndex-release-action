#!/bin/bash -eux

# prepare upload URL
cat ${GITHUB_EVENT_PATH}
RELEASE_ASSETS_UPLOAD_URL=$(cat ${GITHUB_EVENT_PATH} | jq -r .release.upload_url)
RELEASE_ASSETS_UPLOAD_URL=${RELEASE_ASSETS_UPLOAD_URL%\{?name,label\}}
git clone https://github.com/libsgh/PanIndex.git
cd PanIndex
#xgo --targets=windows/*,darwin/*,linux/arm-7,linux/arm64,linux/386,linux/amd64 github.com/libsgh/PanIndex
#ls -al

echo ${GITHUB_REF}
RELEASE_TAG=$(basename ${GITHUB_REF})
BUILD_ARTIFACTS_FOLDER=build-artifacts-$(date +%s)
mkdir -p ${BUILD_ARTIFACTS_FOLDER}

echo $RELEASE_TAG
# linux-amd64
CGO_ENABLED=1 GOOS=linux GOARCH=amd64 go build -o ${BUILD_ARTIFACTS_FOLDER}/PanIndex

cp -r LICENSE README.md CHANGELOG.md config/config.json ${BUILD_ARTIFACTS_FOLDER}/
cd ${BUILD_ARTIFACTS_FOLDER}
ls -lha

tar cvfz PanIndex-${RELEASE_TAG}-linux-amd64.tar.gz  *

# update binary and checksum
curl \
  --fail \
  -X POST \
  --data-binary @PanIndex-${RELEASE_TAG}-linux-amd64.tar.gz \
  -H 'Content-Type: application/gzip' \
  -H "Authorization: Bearer ${INPUT_GITHUB_TOKEN}" \
  "${RELEASE_ASSETS_UPLOAD_URL}?name=PanIndex-${RELEASE_TAG}-linux-amd64.tar.gz"
echo $?