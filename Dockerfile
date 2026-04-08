FROM golang:1.25.9-alpine3.23 AS builder

RUN GOOSE_VERSION=v3.27.0 && \
    go install github.com/cryptogarageinc/goose-wrapper/v3/cmd/goose@${GOOSE_VERSION}

FROM alpine:3.23 AS runner

RUN apk add --update --no-cache ca-certificates libstdc++ make bash
COPY --from=builder /go/bin/goose /usr/bin/goose
CMD ["/usr/bin/goose"]
