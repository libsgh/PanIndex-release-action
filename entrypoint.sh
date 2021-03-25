#!/bin/bash -eux

# prepare golang
source /setup-go.sh

# build & release go binaries
/release.sh linux 386
sleep 10
/release.sh linux amd64
sleep 10
/release.sh linux arm32-v5
sleep 10
/release.sh linux arm32-v6
sleep 10
/release.sh linux arm32-v7
sleep 10
/release.sh linux arm64
sleep 10
/release.sh windows 386
sleep 10
/release.sh windows amd64
sleep 10
/release.sh darwin arm64
sleep 10
/release.sh darwin amd64
sleep 10
/release-ui.sh
# update checksum
# prepare upload URL
RELEASE_ASSETS_UPLOAD_URL=$(cat ${GITHUB_EVENT_PATH} | jq -r .release.upload_url)
RELEASE_ASSETS_UPLOAD_URL=${RELEASE_ASSETS_UPLOAD_URL%\{?name,label\}}
curl \
  --fail \
  -X POST \
  --data-binary @${GITHUB_WORKSPACE}/sha256.list \
  -H 'Content-Type: text/plain' \
  -H "Authorization: Bearer ${INPUT_GITHUB_TOKEN}" \
  "${RELEASE_ASSETS_UPLOAD_URL}?name=sha256.list"
echo $?


