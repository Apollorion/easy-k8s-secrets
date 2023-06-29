#!/usr/bin/env bash

SCRIPT=$(realpath "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
ORIGINAL_KUBECTL=$(which kubectl)

ez_k8s_log(){
  if [ -n "$EZ_K8S_SECRETS_DEBUG" ]; then
    echo "$@"
  fi
}

kubectl(){
  PATH_TO_SECRET_EXECUTABLE="${SCRIPTPATH}/secret"

  case "$@" in
    *"get"*" secret"* | *"edit"*" secret"* | *"create"*" secret"*)
        # ignore if "secrets" instead of "secret"
        # shellcheck disable=SC2199
        if [[ "$@" == *"--no-easy-k8s-secrets "* ]]; then
          ez_k8s_log "INFO: Ignoring easy k8s secrets command, '--no-easy-k8s-secrets' found in command"
          # shellcheck disable=SC2001
          # shellcheck disable=SC2207
          # shellcheck disable=SC2006
          removedPassthrough=(`echo "$@"| sed "s/--no-easy-k8s-secrets //"`)
          $ORIGINAL_KUBECTL "${removedPassthrough[@]}"
        else
          if [[ "$@" == *"secrets"* ]]; then
            ez_k8s_log "INFO: Ignoring easy k8s secrets command, string 'secrets' found in command"
            $ORIGINAL_KUBECTL "${@}"
          else
            $PATH_TO_SECRET_EXECUTABLE "${@}"
          fi
        fi
    ;;
    *)
      $ORIGINAL_KUBECTL "$@"
    ;;

  esac
}

alias k=kubectl
