FROM --platform=$TARGETPLATFORM golang:1.20.3-alpine3.17 as builder

RUN GOOSE_VERSION=v3.13.4 && \
    go install github.com/pressly/goose/v3/cmd/goose@${GOOSE_VERSION}

FROM --platform=$TARGETPLATFORM alpine:3.17 as runner
RUN apk add --update --no-cache ca-certificates libstdc++ make bash
COPY --from=builder /go/bin/goose /usr/bin/goose
CMD ["/usr/bin/goose"]
