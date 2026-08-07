#!/usr/bin/env bash

source "$(dirname -- "${BASH_SOURCE[0]}")/log.sh"

_show_spinner() {
    local pid="$1"
    local message="$2"
    local frames=("--" "\\\\" "||" "//")
    local index=0
    local c_yellow=$'\e[33m'

    while kill -0 "$pid" 2> /dev/null; do
        printf "\r\e[K %s[  %s%s%s  ]%s %s" \
            "$C_CYAN" \
            "$c_yellow" \
            "${frames[index]}" \
            "$C_CYAN" \
            "$C_RESET" \
            "$message"

        index=$(((index + 1) % 4))
        sleep 0.1
    done
}

_handle_task_error() {
    local message="$1"
    local err_file="$2"
    local status="$3"
    local err_msg="Unknown error"
    local line

    while IFS= read -r line; do
        if [[ -n $line ]]; then
            err_msg="$line"
            break
        fi
    done < "$err_file"

    log_error "$message > $err_msg"
    return "$status"
}

run_task() {
    local message="$1"
    shift

    local err_file
    err_file=$(mktemp)

    trap 'printf "\e[?25h"; rm -f "${err_file:-}"' RETURN

    trap '
        kill "$pid" 2>/dev/null
        printf "\r\e[K\e[?25h"
        log_error "$message > Operation canceled"
        exit 1
    ' INT TERM

    printf "\e[?25l"

    "$@" > /dev/null 2> "$err_file" &
    local pid=$!

    _show_spinner "$pid" "$message"

    local status=0
    wait "$pid" || status=$?

    printf "\r\e[K"

    if ((status != 0)); then
        _handle_task_error "$message" "$err_file" "$status"
        return "$status"
    fi

    log_success "$message"
}
