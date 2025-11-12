FROM golang:1.25-alpine AS builder
ADD https://github.com/tianon/rawdns.git /usr/local/src/rawdns
WORKDIR /usr/local/src/rawdns
ENV CGO_ENABLED=0
RUN go mod download
RUN go build -o /tmp/rawdns -trimpath -o /output/usr/bin/rawdns ./cmd/rawdns
ADD https://raw.githubusercontent.com/tianon/rawdns/refs/heads/master/example-config.json /output/etc/rawdns/example-config.json

FROM scratch AS final
WORKDIR /etc/rawdns
COPY --from=builder /output/ /
CMD ["rawdns"]