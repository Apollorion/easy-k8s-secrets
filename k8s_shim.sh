#!/usr/bin/env bash

SCRIPT=$(realpath "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
ORIGINAL_KUBECTL=$(which kubectl)

kubectl(){
  PATH_TO_SECRET_EXECUTABLE="${SCRIPTPATH}/secret"

  case "$@" in
    *"get"*"secret"* | *"edit"*"secret"* | *"create"*"secret"*)
        # ignore if "secrets" instead of "secret"
        # shellcheck disable=SC2199
        if [[ "$@" == *"secrets"* ]]; then
          echo "Ignoring easy k8s secrets command, string 'secrets' found in command"
          $ORIGINAL_KUBECTL "$@"
        else
          $PATH_TO_SECRET_EXECUTABLE "${@}"
        fi
    ;;
    *)
      $ORIGINAL_KUBECTL "$@"
    ;;

  esac
}

alias k=kubectl
