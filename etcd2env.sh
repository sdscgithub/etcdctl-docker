#!/bin/bash
set -e

# Set environment variables
prefix="${ETCD2ENV_PREFIX:-ETCD2ENV_}"
format="${ETCD2ENV_FORMAT:-DOTENV}"
unset ETCD2ENV_PREFIX
unset ETCD2ENV_FORMAT
ETCD_ENVIRONMENT_VARIABLE_REGEX="^\s*${prefix}([^=]+)=(.+)\s*$"
OUTPUT_PIPE="${1:-/dev/stdout}"

# Iterate through each matching environment variable and convert it to the output
while read -r env_name etcd_key ; do
  env_value=$(etcdctl get "${etcd_key}" || true)
  if [ -z "${env_value}" ]; then
    echo >&2 "Unable to get value for '${etcd_key}' from etcd."
    exit 1
  fi
  [ "${format}" = "DOTENV" ] && environment="${environment}${env_name}=${env_value}\n"
  [ "${format}" = "BASH" ] && environment="${environment}export ${env_name}=\"${env_value}\"\n"
done < <(env | grep -E "${ETCD_ENVIRONMENT_VARIABLE_REGEX}"  | sed -E "s/${ETCD_ENVIRONMENT_VARIABLE_REGEX}/\1\t\2/")

# Send the results to the output pipe
echo -e "${environment}" | grep . > "${OUTPUT_PIPE}"
