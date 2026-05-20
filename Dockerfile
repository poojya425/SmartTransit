FROM golang:1.24-alpine AS builder
WORKDIR /app
RUN apk add --no-cache git
COPY backend/go.mod backend/go.sum ./
RUN go mod download
COPY backend/ .
RUN CGO_ENABLED=0 GOOS=linux go build -o smarttransit-api .

FROM alpine:latest
RUN apk --no-cache add ca-certificates
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
WORKDIR /app
COPY --from=builder /app/smarttransit-api .
RUN chown -R appuser:appgroup /app
USER 10014
EXPOSE 8080
CMD ["./smarttransit-api"]