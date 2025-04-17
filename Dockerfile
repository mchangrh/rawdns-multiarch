FROM alpine:3.21 AS builder
ENV RAWDNS_VERSION=1.10
WORKDIR /tmp/
RUN \
  apk add --no-cache \
    dpkg \
    wget && \
  dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" && \
  mkdir -p /tmp/usr/local/bin && \
  wget -O /tmp/usr/local/bin/rawdns https://github.com/tianon/rawdns/releases/download/$RAWDNS_VERSION/rawdns-$dpkgArch && \
  chmod +x /tmp/usr/local/bin/rawdns
ADD https://raw.githubusercontent.com/tianon/rawdns/refs/heads/master/example-config.json /tmp/etc/rawdns/example-config.json

FROM scratch AS final
WORKDIR /etc/rawdns
COPY --from=builder /tmp/ /
CMD ["rawdns"]