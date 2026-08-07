#!/usr/bin/env bash

if [[ -z ${C_RESET:-} ]]; then
    readonly C_CYAN=$'\e[36m'
    readonly C_GREEN=$'\e[32m'
    readonly C_RED=$'\e[31m'
    readonly C_RESET=$'\e[0m'
fi

log_success() {
    printf " %s[  %sOK%s  ]%s %s\n" \
        "$C_CYAN" \
        "$C_GREEN" \
        "$C_CYAN" \
        "$C_RESET" \
        "$*"
}

log_error() {
    printf " %s[ %sFAIL%s ]%s %s\n" \
        "$C_CYAN" \
        "$C_RED" \
        "$C_CYAN" \
        "$C_RESET" \
        "$*"
}
