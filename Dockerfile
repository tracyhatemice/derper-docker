FROM --platform=$BUILDPLATFORM golang:alpine AS builder
WORKDIR /app

RUN apk add --no-cache git ca-certificates

ARG DERP_VERSION=latest
ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH

ENV CGO_ENABLED=0
ENV GOOS=${TARGETOS}
ENV GOARCH=${TARGETARCH}

RUN go install tailscale.com/cmd/derper@${DERP_VERSION}

FROM alpine:latest
WORKDIR /app

RUN apk add --no-cache ca-certificates
RUN mkdir -p /app/certs

ENV DERP_DOMAIN=your-hostname.com
ENV DERP_CERT_MODE=letsencrypt
ENV DERP_CERT_DIR=/app/certs
ENV DERP_ADDR=:443
ENV DERP_STUN=true
ENV DERP_STUN_PORT=3478
ENV DERP_HTTP_PORT=80
ENV DERP_VERIFY_CLIENTS=false
ENV DERP_VERIFY_CLIENT_URL=""
ENV DERP_MESH_PSK_FILE=""
ENV DERP_CONFIG_FILE=""

COPY --from=builder /go/bin/derper /derper

CMD ["/bin/sh", "-c", "/derper \
    -hostname=$DERP_DOMAIN \
    -certmode=$DERP_CERT_MODE \
    -certdir=$DERP_CERT_DIR \
    -a=$DERP_ADDR \
    -stun=$DERP_STUN \
    -stun-port=$DERP_STUN_PORT \
    -http-port=$DERP_HTTP_PORT \
    -verify-clients=$DERP_VERIFY_CLIENTS \
    -verify-client-url=$DERP_VERIFY_CLIENT_URL \
    -mesh-psk-file=$DERP_MESH_PSK_FILE \
    -c=$DERP_CONFIG_FILE"]
