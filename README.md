# gRPCurl Container

## Overview
Containers built from source for [gRPCurl](https://github.com/fullstorydev/grpcurl) for the following platforms:
* amd64
* arm64
* arm/v7
* riscv64

May or may not use the same go toolchain as upstream.

## Version Scheme
Versioning scheme will be `<upstream>-<revision>` where revision is a 1-based patch number.

Examples:
* `1.9.3-1`
* `1.9.3-2`
* `1.9.4-1`

Reasons for bumping the patch number include (but are not limited to):
* Bumping go toolchain
* Changes to [Containerfile](/Containerfile)

## Why?
* An `arm/v7` container is not published upstream
  * [PR](https://github.com/fullstorydev/grpcurl/issues/551) for adding this was rejected
* Upstream does not build for `riscv64` (see their [.goreleaser.yml](https://github.com/fullstorydev/grpcurl/blob/master/.goreleaser.yml)) and therefore doesn't publish a container for it either
