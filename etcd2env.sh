#!/bin/bash
set -e

# Set environment variables
ETCD_ENVIRONMENT_VARIABLE_REGEX="^\s*ETCD2ENV_([^=]+)=(.+)\s*$"

# Convert values in the environment
while read -r env_name etcd_key ; do
  env_value=$(etcdctl get "${etcd_key}" || true)
  if [ -z "${env_value}" ]; then
    echo >&2 "Unable to get value for '${etcd_key}' from etcd."
  fi
  echo "${env_name}=${env_value}"
done < <(env | grep -E "${ETCD_ENVIRONMENT_VARIABLE_REGEX}"  | sed -E "s/${ETCD_ENVIRONMENT_VARIABLE_REGEX}/\1\t\2/")
