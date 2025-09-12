FROM --platform=$BUILDPLATFORM golang:alpine AS builder
WORKDIR /app

# Install git and ca-certificates for go modules
RUN apk add --no-cache git ca-certificates

ARG DERP_VERSION=latest
ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH

# Build static binary with explicit CGO disabled
ENV CGO_ENABLED=0
ENV GOOS=${TARGETOS}
ENV GOARCH=${TARGETARCH}

RUN go install tailscale.com/cmd/derper@${DERP_VERSION}

# Verify the binary exists and is executable
RUN ls -la /go/bin/derper

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

# Copy binary and ensure it's executable
COPY --from=builder /go/bin/derper /app/derper
RUN chmod +x /app/derper

# Verify the binary in the final image
RUN ls -la /app/derper

# Use exec form and fix environment variable expansion
CMD ["/bin/sh", "-c", "/app/derper --hostname=$DERP_DOMAIN --certmode=$DERP_CERT_MODE --certdir=$DERP_CERT_DIR --a=$DERP_ADDR --stun=$DERP_STUN --stun-port=$DERP_STUN_PORT --http-port=$DERP_HTTP_PORT --verify-clients=$DERP_VERIFY_CLIENTS --verify-client-url=$DERP_VERIFY_CLIENT_URL"]
