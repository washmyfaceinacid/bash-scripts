#!/usr/bin/env bash

usage() {
    printf 'Usage: %s -o <op> -n <numbers...> [-d]\n' "$(basename "$0")" >&2
}

calculate() {
    local operation=$1
    shift

    local result=$1
    shift

    local number
    for number in "$@"; do
        case $operation in
            '+') result=$(( result + number )) ;;
            '-') result=$(( result - number )) ;;
            '*') result=$(( result * number )) ;;
            '%') result=$(( result % number )) ;;
            *) return 1 ;;
        esac
    done

    printf '%s\n' "$result"
}

operation=
debug=0
numbers=()

while (($#)); do
    case $1 in
        -o)
            [[ $# -ge 2 ]] || { usage; exit 1; }
            operation=$2
            shift 2
            ;;
        -n)
            shift
            while (($#)) && [[ $1 != -d ]]; do
                numbers+=("$1")
                shift
            done
            ;;
        -d)
            debug=1
            shift
            ;;
        *)
            usage
            exit 1
            ;;
    esac
done

if [[ -z $operation || ${#numbers[@]} -lt 1 ]]; then
    usage
    exit 1
fi

case $operation in
    '+'|'-'|'*'|'%') ;;
    *)
        usage
        exit 1
        ;;
esac

if (( debug )); then
    printf 'User: %s\n' "$(whoami)"
    printf 'Script: %s\n' "$(basename "$0")"
    printf 'Operation: %s\n' "$operation"
    printf 'Numbers: %s\n' "${numbers[*]}"
fi

result=$(calculate "$operation" "${numbers[@]}") || exit 1
printf 'Result: %s\n' "$result"
