#!/bin/bash -eux

# prepare golang
source /setup-go.sh 

# easy to debug if anything wrong
go version

git clone https://github.com/libsgh/PanIndex.git

cd PanIndex

flags="-X 'PanIndex/boot.VERSION=v1.0.3' -X 'PanIndex/boot.BUILD_TIME=$(date "+%F %T")' -X 'PanIndex/boot.GO_VERSION=$(go version)'-X 'PanIndex/boot.GIT_COMMIT_SHA=$(git show -s --format=%H)'"

CGO_ENABLED=1 GOOS=linux  GOARCH=386 go build -ldflags="$flags" -v -o PanIndex .


