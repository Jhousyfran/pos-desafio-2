FROM golang:1.21-bookworm AS builder

WORKDIR /src
COPY go.mod ./
COPY . .
RUN go mod tidy
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o /out/auth-service .

FROM gcr.io/distroless/static-debian12
WORKDIR /app
COPY --from=builder /out/auth-service /app/auth-service
USER nonroot:nonroot
EXPOSE 8001
ENTRYPOINT ["/app/auth-service"]
