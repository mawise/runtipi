#!/usr/bin/env bash
set -euo pipefail

source "${BASH_SOURCE%/*}/common.sh"

ensure_pwd
ensure_root

ROOT_FOLDER="${PWD}"
ENV_FILE="${ROOT_FOLDER}/.env"
STORAGE_PATH=$(grep -v '^#' "${ENV_FILE}" | xargs -n 1 | grep STORAGE_PATH | cut -d '=' -f2)

export DOCKER_CLIENT_TIMEOUT=240
export COMPOSE_HTTP_TIMEOUT=240

# Stop all installed apps if there are any
apps_folder="${ROOT_FOLDER}/apps"
if [ "$(find "${apps_folder}" -maxdepth 1 -type d | wc -l)" -gt 1 ]; then
  apps_names=($(ls -d ${apps_folder}/*/ | xargs -n 1 basename | sed 's/\///g'))

  for app_name in "${apps_names[@]}"; do
    # if folder ${ROOT_FOLDER}/app-data/app_name exists, then stop app
    if [[ -d "${STORAGE_PATH}/app-data/${app_name}" ]]; then
      echo "Stopping ${app_name}"
      "${ROOT_FOLDER}/scripts/app.sh" stop "$app_name"
    fi
  done
else
  echo "No app installed that can be stopped."
fi

echo "Stopping Docker services..."
echo
docker compose down --remove-orphans --rmi local
