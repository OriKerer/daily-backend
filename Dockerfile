FROM golang:1.19-alpine AS build

WORKDIR /src

COPY go.mod go.sum ./
RUN go mod download

COPY . ./

RUN go build -mod=readonly -v -o /app


# Now create separate deployment image
FROM alpine

RUN adduser --disabled-password go
USER go

WORKDIR /daily
COPY --from=build /app ./app

# TODO: remove gttp port after testing
EXPOSE 80 
EXPOSE 443

ENTRYPOINT ["./app"]
