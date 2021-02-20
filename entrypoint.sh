#!/bin/bash -eux

# prepare golang
source /setup-go.sh 

# easy to debug if anything wrong
go version
source /test.sh 
# build & release go binaries
/release.sh linux 386
sleep 30
/release.sh linux amd64
sleep 30
/release.sh linux arm32-v7
sleep 30
/release.sh linux arm64
sleep 30
/release.sh windows 386
sleep 30
/release.sh windows amd64
sleep 30
/release.sh darwin 386
sleep 30
/release.sh darwin amd64
sleep 30
# update checksum
# prepare upload URL
RELEASE_ASSETS_UPLOAD_URL=$(cat ${GITHUB_EVENT_PATH} | jq -r .release.upload_url)
RELEASE_ASSETS_UPLOAD_URL=${RELEASE_ASSETS_UPLOAD_URL%\{?name,label\}}
curl \
  --fail \
  -X POST \
  --data-binary @sha256.list \
  -H 'Content-Type: text/plain' \
  -H "Authorization: Bearer ${INPUT_GITHUB_TOKEN}" \
  "${RELEASE_ASSETS_UPLOAD_URL}?name=sha256.list"
echo $?


