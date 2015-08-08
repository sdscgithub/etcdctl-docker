#!/bin/bash
set -e

# Set environment variables
ETCD_ENVIRONMENT_VARIABLE_REGEX="^\s*ETCD2ENV_([^=]+)=(.+)\s*$"
OUTPUT_PIPE="${1:-/dev/stdout}"

# Iterate through each matching environment variable and convert it to the output
while read -r env_name etcd_key ; do
  env_value=$(etcdctl get "${etcd_key}" || true)
  if [ -z "${env_value}" ]; then
    echo >&2 "Unable to get value for '${etcd_key}' from etcd."
    exit 1
  fi
  environment=$(printf '%s%s=%s\n' "${environment}" "${env_name}" "${env_value}")
done < <(env | grep -E "${ETCD_ENVIRONMENT_VARIABLE_REGEX}"  | sed -E "s/${ETCD_ENVIRONMENT_VARIABLE_REGEX}/\1\t\2/")

# Send the results to the output pipe
echo -e "${environment}" > "${OUTPUT_PIPE}"
