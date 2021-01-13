#!/bin/bash -eux

# prepare golang
source /setup-go.sh 

# easy to debug if anything wrong
go version

# build & release go binaries
/release.sh linux 386
/release.sh linux amd64
/release.sh linux arm32-v7
/release.sh linux arm64
/release.sh windows 386
/release.sh windows amd64
/release.sh darwin 386
/release.sh darwin amd64


