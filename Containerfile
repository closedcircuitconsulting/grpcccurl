# SPDX-License-Identifier: MIT
# Copyright (c) 2026 Closed Circuit Consulting

FROM --platform=$BUILDPLATFORM docker.io/library/alpine:3.24 AS fetch

ARG TARGETARCH
ARG TARGETVARIANT
ARG VERSION

WORKDIR /tmp

RUN set -eu; \
    : "${VERSION:?VERSION build arg is required}"; \
    case "${TARGETARCH}/${TARGETVARIANT}" in \
      amd64/*) GRPC_ARCH=x86_64 ;; \
      arm64/*) GRPC_ARCH=arm64 ;; \
      arm/v7)  GRPC_ARCH=armv7 ;; \
      *) echo "unsupported platform: ${TARGETARCH}/${TARGETVARIANT}" >&2; exit 1 ;; \
    esac; \
    BASE="https://github.com/fullstorydev/grpcurl/releases/download/v${VERSION}"; \
    FILE="grpcurl_${VERSION}_linux_${GRPC_ARCH}.tar.gz"; \
    wget -q "${BASE}/${FILE}"; \
    wget -q "${BASE}/grpcurl_${VERSION}_checksums.txt"; \
    grep " ${FILE}\$" "grpcurl_${VERSION}_checksums.txt" | sha256sum -c -; \
    tar --no-same-owner -xzf "${FILE}" grpcurl LICENSE

FROM scratch
LABEL org.opencontainers.image.title="grpcccurl"
LABEL org.opencontainers.image.description="grpcccurl container (upstream fullstorydev/grpcurl)"
LABEL org.opencontainers.image.vendor="Closed Circuit Consulting"
LABEL org.opencontainers.image.authors="unitexe"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.source="https://git.closedcircuitconsulting.com/grpcccurl"
LABEL org.opencontainers.image.url="https://git.closedcircuitconsulting.com"
LABEL maintainer="unitexe"
COPY --from=fetch /tmp/LICENSE /usr/share/licenses/grpcurl/LICENSE
COPY --from=fetch /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=fetch /tmp/grpcurl /usr/local/bin/grpcurl
USER 65534:65534
ENTRYPOINT ["/usr/local/bin/grpcurl"]
