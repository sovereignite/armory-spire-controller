# Build from the parent workspace so the replaced sibling `controller-libs`
# module (see the `replace ../controller-libs` line in go.mod) is inside the
# build context:
#
#   docker build -f spire-tpm-keymanager-controller/Dockerfile .
#
FROM golang:1.26-bookworm AS build
WORKDIR /src
COPY spire-tpm-keymanager-controller/ ./
COPY controller-libs/ ../controller-libs/
RUN go mod download
RUN CGO_ENABLED=0 go build -trimpath -ldflags="-s -w" -o /out/spire-tpm-keymanager-controller ./cmd/spire-tpm-keymanager-controller

FROM debian:bookworm-slim
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates \
    && rm -rf /var/lib/apt/lists/*
COPY --from=build /out/spire-tpm-keymanager-controller /usr/local/bin/spire-tpm-keymanager-controller
USER 65532:65532
ENTRYPOINT ["/usr/local/bin/spire-tpm-keymanager-controller"]
