FROM --platform=$TARGETPLATFORM golang:1.24.7-alpine3.22 as builder

RUN GOOSE_VERSION=v3.25.0 && \
    go install github.com/pressly/goose/v3/cmd/goose@${GOOSE_VERSION}

FROM --platform=$TARGETPLATFORM alpine:3.22 as runner

# TODO(k-matsuzawa): opensslセキュリティ対応。次回のimage更新まで追記しておく
RUN apk update && apk add --upgrade openssl~=3.5.4
RUN apk add --update --no-cache ca-certificates libstdc++ make bash
COPY --from=builder /go/bin/goose /usr/bin/goose
CMD ["/usr/bin/goose"]
