#!/bin/bash
set -e

# Set environment variables
ETCD_ENVIRONMENT_VARIABLE_REGEX="^\s*ETCD2ENV_([^=]+)=(.+)\s*$"
OUTPUT_PIPE="${1:-/dev/stdout}"

# Make sure we blank out the pipe if it's a file
printf '' > "${OUTPUT_PIPE}"

# Iterate through each matching environment variable and convert it to the output
while read -r env_name etcd_key ; do
  env_value=$(etcdctl get "${etcd_key}" || true)
  if [ -z "${env_value}" ]; then
    echo >&2 "Unable to get value for '${etcd_key}' from etcd."
  fi
  printf '%s=%s\n' "${env_name}" "${env_value}" >> "${OUTPUT_PIPE}"
done < <(env | grep -E "${ETCD_ENVIRONMENT_VARIABLE_REGEX}"  | sed -E "s/${ETCD_ENVIRONMENT_VARIABLE_REGEX}/\1\t\2/")
