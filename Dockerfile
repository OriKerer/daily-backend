# Use base golang image from Docker Hub
FROM golang:1.19 AS build

WORKDIR /src

# Install dependencies in go.mod and go.sum
COPY go.mod go.sum ./
RUN go mod download

COPY . ./

ARG SKAFFOLD_GO_GCFLAGS
RUN echo "Go gcflags: ${SKAFFOLD_GO_GCFLAGS}"
RUN go build -gcflags="${SKAFFOLD_GO_GCFLAGS}" -mod=readonly -v -o /app

# Now create separate deployment image
FROM debian:11-slim

# Definition of this variable is used by 'skaffold debug' to identify a golang binary.
# Default behavior - a failure prints a stack trace for the current goroutine.
# See https://golang.org/pkg/runtime/
ENV GOTRACEBACK=single

# Copy template & assets
WORKDIR /daily
COPY --from=build /app ./app

EXPOSE 8080
ENTRYPOINT ["./app"]
