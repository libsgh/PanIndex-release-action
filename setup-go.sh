#!/bin/bash -eux

#GO_LINUX_PACKAGE_URL="https://dl.google.com/go/go1.14.linux-amd64.tar.gz"
#wget --progress=dot:mega ${GO_LINUX_PACKAGE_URL} -O go-linux.tar.gz 
#tar -zxf go-linux.tar.gz
#mv go /usr/local/
#mkdir -p /go/bin /go/src /go/pkg

#export GO_HOME=/usr/local/go
#export GOPATH=/go
#export GO111MODULE="on"
#export GOPROXY="https://goproxy.io"
#export PATH=${GO_HOME}/bin/:$PATH
#export PATH=${GOPATH}/bin/:$PATH
go env

