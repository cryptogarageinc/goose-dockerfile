FROM --platform=$TARGETPLATFORM golang:1.23.4-alpine3.20 as builder

RUN GOOSE_VERSION=v3.24.1 && \
    go install github.com/pressly/goose/v3/cmd/goose@${GOOSE_VERSION}

FROM --platform=$TARGETPLATFORM alpine:3.20 as runner
RUN apk add --update --no-cache ca-certificates libstdc++ make bash
COPY --from=builder /go/bin/goose /usr/bin/goose
CMD ["/usr/bin/goose"]
