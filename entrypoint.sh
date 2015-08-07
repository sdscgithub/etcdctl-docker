#!/bin/bash
set -e

# Look for known command aliases
case "$1" in
  "etcd2env" ) shift; exec /usr/local/bin/etcd2env "$@";;
  *          ) exec /usr/local/bin/etcdctl "$@" ;;
esac
