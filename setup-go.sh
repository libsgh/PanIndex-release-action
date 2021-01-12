#!/bin/bash -eux

export GO111MODULE="on"
#export GOPROXY="https://goproxy.io"
export PATH=/go/bin/:$PATH
go env

