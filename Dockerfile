FROM --platform=$TARGETPLATFORM debian:bullseye-slim

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends wget make && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt/goose

ARG GOOSE_VERSION=v3.7.0
RUN ARCH=$(uname -m) && \
    echo "ARCH=$ARCH" && \
    if test "$ARCH" == "aarch64" || test "$ARCH" == "arm64"; then \
        GOOSE_TARBALL=goose_linux_arm64 ;\
    else \
        GOOSE_TARBALL=goose_linux_x86_64 ;\
    fi && \
    wget -q --no-check-certificate https://github.com/pressly/goose/releases/download/${GOOSE_VERSION}/${GOOSE_TARBALL} && \
    mv "${GOOSE_TARBALL}" goose && \
    chmod +x goose && \
    ln -s /opt/goose/goose /usr/local/bin/goose && \
    goose --version
