#!/bin/bash -eux

# prepare upload URL
RELEASE_ASSETS_UPLOAD_URL=$(cat ${GITHUB_EVENT_PATH} | jq -r .release.upload_url)
RELEASE_ASSETS_UPLOAD_URL=${RELEASE_ASSETS_UPLOAD_URL%\{?name,label\}}
#git clone https://github.com/libsgh/PanIndex.git
#cd PanIndex
xgo --targets=windows/*,darwin/*,linux/arm-7,linux/arm64,linux/386,linux/amd64 github.com/libsgh/PanIndex@v1.0.0
ls -al