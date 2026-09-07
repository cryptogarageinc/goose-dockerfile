FROM golang:1.26.8-alpine3.24 AS builder

RUN apk update && apk upgrade --no-cache
RUN GOOSE_VERSION=v3.28.0 && \
    go install github.com/cryptogarageinc/goose-wrapper/v3/cmd/goose@${GOOSE_VERSION}

FROM alpine:3.24 AS runner

RUN apk update && apk upgrade --no-cache && apk add --update --no-cache ca-certificates libstdc++ make bash
COPY --from=builder /go/bin/goose /usr/bin/goose
CMD ["/usr/bin/goose"]
