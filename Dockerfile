#
# Simple etcdctl client
#
# http://github.com/tenstartups/etcdctl
#

FROM alpine:latest

MAINTAINER Marc Lennox <marc.lennox@gmail.com>

# Set environment variables.
ENV \
  TERM=xterm-color \
  ETCD_VERSION=2.1.1

# Install packages.
RUN \
  apk --update add bash nano wget && \
  rm /var/cache/apk/*

# Install etcdctl from repository.
RUN \
  cd /tmp && \
  wget --no-check-certificate https://github.com/coreos/etcd/releases/download/v${ETCD_VERSION}/etcd-v${ETCD_VERSION}-linux-amd64.tar.gz && \
  tar zxvf etcd-*-linux-amd64.tar.gz && \
  cp etcd-*-linux-amd64/etcdctl /usr/local/bin/etcdctl && \
  rm -rf etcd-*-linux-amd64 && \
  chmod +x /usr/local/bin/etcdctl

# Add files to the container.
COPY entrypoint.sh /entrypoint
COPY etcd2env.sh /usr/local/bin/etcd2env

# Set the entrypoint script.
ENTRYPOINT ["/entrypoint"]
