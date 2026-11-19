FROM --platform=$BUILDPLATFORM alpine:3.24 AS builder

RUN apk update && apk upgrade --no-cache && apk add --update --no-cache ca-certificates curl

RUN GOOSE_VERSION=3.30.1 && \
    ARCH=$(uname -m) && \
    echo "ARCH=$ARCH" && \
    if test "$ARCH" = "aarch64" || test "$ARCH" = "arm64"; then \
      GOOSE_TZ_FILE="goose-v${GOOSE_VERSION}-linux-arm64.tar.gz" ;\
      GOOSE_FILE=goose-linux-arm64 ;\
    else \
      GOOSE_TZ_FILE="goose-v${GOOSE_VERSION}-linux-amd64.tar.gz" ;\
      GOOSE_FILE=goose-linux-amd64 ;\
    fi && \
    curl -sSL "https://github.com/cryptogarageinc/goose-wrapper/releases/download/v${GOOSE_VERSION}/${GOOSE_TZ_FILE}" -o goose.tgz && \
    tar -zxvf goose.tgz && \
    chmod +x "./${GOOSE_FILE}" && \
    mv "./${GOOSE_FILE}" /usr/local/bin/goose && \
    rm -rf goose.tgz

FROM --platform=$BUILDPLATFORM alpine:3.24 AS runner

RUN apk update && apk upgrade --no-cache && apk add --update --no-cache ca-certificates libstdc++ make bash

COPY --from=builder /usr/local/bin/goose /usr/local/bin/goose
RUN chmod +x /usr/local/bin/goose
CMD ["/usr/local/bin/goose"]
