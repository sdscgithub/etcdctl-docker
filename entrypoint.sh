#!/bin/bash
set -e

# Look for known command aliases
case "$1" in
  "etcd2env" ) shift; command="/usr/local/bin/etcd2env" "$@";;
  *          ) command="/usr/local/bin/etcdctl" "$@" ;;
esac

exec ${command}
