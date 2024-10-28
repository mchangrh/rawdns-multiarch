FROM alpine:3.19 AS builder
ENV RAWDNS_VERSION=1.10
WORKDIR /tmp/etc/rawdns
RUN \
  apk add --no-cache \
    dpkg \
    wget && \
  dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" && \
  wget -O /tmp/etc/rawdns/rawdns https://github.com/tianon/rawdns/releases/download/$RAWDNS_VERSION/rawdns-$dpkgArch
ADD https://raw.githubusercontent.com/tianon/rawdns/refs/heads/master/example-config.json /tmp/etc/rawdns/example-config.json
RUN chmod +x /tmp/etc/rawdns/rawdns

FROM scratch AS final
WORKDIR /etc/rawdns
COPY --from=builder /tmp/etc/rawdns /etc/rawdns
CMD ["/etc/rawdns/rawdns"]