#!/bin/bash -eux

# prepare upload URL
RELEASE_ASSETS_UPLOAD_URL=$(cat ${GITHUB_EVENT_PATH} | jq -r .release.upload_url)
RELEASE_ASSETS_UPLOAD_URL=${RELEASE_ASSETS_UPLOAD_URL%\{?name,label\}}

cd ${GITHUB_WORKSPACE}
mkdir ui
cp -R -f static/ ui/static/
cp -R -f templates/ ui/templates/
cd ui
zip -vr ui-${RELEASE_TAG}.zip *
sha256sum ui-${RELEASE_TAG}.zip >> ${GITHUB_WORKSPACE}/sha256.list

# update binary
curl \
  --fail \
  -X POST \
  --data-binary @ui-${RELEASE_TAG}.zip \
  -H 'Content-Type: application/gzip' \
  -H "Authorization: Bearer ${INPUT_GITHUB_TOKEN}" \
  "${RELEASE_ASSETS_UPLOAD_URL}?name=ui-${RELEASE_TAG}.zip"
echo $?