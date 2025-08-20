FROM --platform=$BUILDPLATFORM golang:1.21-alpine AS build

WORKDIR /build

COPY go.mod go.sum ./

RUN go mod download

COPY . .

ARG TARGETOS
ARG TARGETARCH

RUN --mount=type=cache,target=/root/.cache/go-build \
    --mount=type=cache,target=/go/pkg \
    CGO_ENABLED=0 GOOS=$TARGETOS GOARCH=$TARGETARCH go build -o krista.su github.com/krispeckt/krista.su

FROM alpine

COPY --from=build /build/krista.su .
COPY config.yml /bin/

COPY templates /templates/
COPY assets /assets/

ENTRYPOINT ["./krista.su", "-config", "/bin/config.yml"]