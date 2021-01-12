#!/bin/bash -eux

git clone https://github.com/libsgh/PanIndex.git

cd PanIndex

go get -u github.com/gobuffalo/packr/v2/packr2

CGO_ENABLED=1 GOOS=linux GOARCH=amd64 go build -o dist/PanIndex

ls -n