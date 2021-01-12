#!/bin/bash -eux

export GO111MODULE="on"
export PATH=/go/bin/:$PATH
go get github.com/karalabe/xgo
go get -u github.com/gobuffalo/packr/v2/packr2
packr2
