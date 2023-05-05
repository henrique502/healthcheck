FROM --platform=$BUILDPLATFORM golang:1.20 AS builder
WORKDIR $GOPATH/src
COPY . .

ARG TARGETOS
ARG TARGETARCH

ENV GOOS=$TARGETOS
ENV GOARCH=$TARGETARCH

ENV GO111MODULE=auto
ENV GOPRIVATE=gitlab.com
ENV CGO_ENABLED=0

RUN go mod download
RUN go build -o /opt/healthcheck -v main.go
RUN chmod -R +x /opt/

FROM --platform=$BUILDPLATFORM gcr.io/distroless/static-debian11:nonroot
COPY --from=builder --chown=nonroot:nonroot /opt/ /opt/

USER nonroot
WORKDIR /opt/
ENTRYPOINT ["/opt/healthcheck"]
