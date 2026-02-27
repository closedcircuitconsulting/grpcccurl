#
# Build (fetch) stage
#

FROM alpine AS fetch

ARG TARGETARCH
ARG TARGETVARIANT
ARG VERSION

RUN echo "TARGETARCH=${TARGETARCH} TARGETVARIANT=${TARGETVARIANT}"
RUN apk add --no-cache wget tar \
    && ARCH=$(uname -m) \
    && case "${ARCH}" in \
       x86_64)  GRPC_ARCH="x86_64" ;; \
       aarch64) GRPC_ARCH="arm64" ;; \
       armv7l)  GRPC_ARCH="armv7" ;; \
       esac \
    && wget -q https://github.com/fullstorydev/grpcurl/releases/download/v${VERSION}/grpcurl_${VERSION}_linux_${GRPC_ARCH}.tar.gz \
    && tar --no-same-owner -xzf grpcurl_${VERSION}_linux_${GRPC_ARCH}.tar.gz

#
# Run stage
#

FROM scratch
COPY --from=fetch /grpcurl /grpcurl
ENTRYPOINT ["/grpcurl"]
