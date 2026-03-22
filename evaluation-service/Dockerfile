FROM golang:1.21-bookworm AS builder

WORKDIR /src
COPY go.mod go.sum ./
COPY . .
RUN go mod tidy
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o /out/evaluation-service .

FROM gcr.io/distroless/static-debian12
WORKDIR /app
COPY --from=builder /out/evaluation-service /app/evaluation-service
USER nonroot:nonroot
EXPOSE 8004
ENTRYPOINT ["/app/evaluation-service"]
