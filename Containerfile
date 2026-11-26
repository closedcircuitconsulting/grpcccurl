# SPDX-License-Identifier: MIT
# Copyright (c) 2026 Closed Circuit Consulting

ARG GRPCURL_VERSION=1.9.4

FROM --platform=$BUILDPLATFORM docker.io/library/golang:1.27.4-alpine3.24 AS build

ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT
ARG GRPCURL_VERSION

ENV CGO_ENABLED=0 \
    GOFLAGS=-trimpath \
    GOWORK=off

RUN set -eu; \
    GOOS="${TARGETOS}" GOARCH="${TARGETARCH}" GOARM="${TARGETVARIANT#v}" \
        go install -ldflags "-s -w -X main.version=v${GRPCURL_VERSION}" \
        "github.com/fullstorydev/grpcurl/cmd/grpcurl@v${GRPCURL_VERSION}"; \
    find /go/bin -type f -name grpcurl -exec cp {} /grpcurl \; ; \
    test -x /grpcurl; \
    cp "/go/pkg/mod/github.com/fullstorydev/grpcurl@v${GRPCURL_VERSION}/LICENSE" /LICENSE

FROM scratch
ARG GRPCURL_VERSION
LABEL org.opencontainers.image.title="grpcccurl"
LABEL org.opencontainers.image.description="grpcurl built from source by Closed Circuit Consulting (upstream fullstorydev/grpcurl)"
LABEL org.opencontainers.image.vendor="Closed Circuit Consulting"
LABEL org.opencontainers.image.authors="unitexe"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.source="https://git.closedcircuitconsulting.com/grpcccurl"
LABEL org.opencontainers.image.url="https://git.closedcircuitconsulting.com"
LABEL com.closedcircuitconsulting.upstream.version="${GRPCURL_VERSION}"
LABEL maintainer="unitexe"
COPY --from=build /LICENSE /usr/share/licenses/grpcurl/LICENSE
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=build /grpcurl /usr/local/bin/grpcurl
USER 65534:65534
ENTRYPOINT ["/usr/local/bin/grpcurl"]
