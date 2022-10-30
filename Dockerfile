FROM golang:1.19 AS build

WORKDIR /src

COPY go.mod go.sum ./
RUN go mod download

COPY . ./

RUN go build -mod=readonly -v -o /app


# Now create separate deployment image
FROM debian:11-slim

WORKDIR /daily
COPY --from=build /app ./app

EXPOSE 8080
ENTRYPOINT ["./app"]
