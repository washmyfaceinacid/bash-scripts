#!/usr/bin/env bash
set -euo pipefail

usage() {
    printf 'Usage: %s [-v|-r|-l|-u|-s <old> <new>] -i <input file> -o <output file>\n' "${0##*/}" >&2
    exit 1
}

escape() { printf '%s' "$1" | sed 's/[\/&|]/\\&/g'; }

input_file=
output_file=
ops=()
arg1=()
arg2=()

while (($#)); do
    case $1 in
        -v|-r|-l|-u) ops+=("${1#-}"); arg1+=(""); arg2+=(""); shift ;;
        -s)
            [[ $# -ge 3 ]] || usage
            ops+=(s); arg1+=("$2"); arg2+=("$3"); shift 3 ;;
        -i) [[ $# -ge 2 ]] || usage; input_file=$2; shift 2 ;;
        -o) [[ $# -ge 2 ]] || usage; output_file=$2; shift 2 ;;
        *) usage ;;
    esac
done

[[ -n ${input_file:-} && -n ${output_file:-} && ${#ops[@]} -gt 0 ]] || usage
[[ -f $input_file ]] || { printf 'Input file not found: %s\n' "$input_file" >&2; exit 1; }

tmp=$(mktemp)
cp "$input_file" "$tmp"
trap 'rm -f "$tmp"' EXIT

for i in "${!ops[@]}"; do
    next=$(mktemp)
    case ${ops[$i]} in
        v) tr '[:lower:][:upper:]' '[:upper:][:lower:]' < "$tmp" > "$next" ;;
        l) tr '[:upper:]' '[:lower:]' < "$tmp" > "$next" ;;
        u) tr '[:lower:]' '[:upper:]' < "$tmp" > "$next" ;;
        r) awk '{ a[NR] = $0 } END { for (i = NR; i; i--) print a[i] }' "$tmp" > "$next" ;;
        s)
            old=$(escape "${arg1[$i]}")
            new=$(escape "${arg2[$i]}")
            sed "s|$old|$new|g" "$tmp" > "$next"
            ;;
        *)
            usage
            ;;
    esac
    mv "$next" "$tmp"
done

mv "$tmp" "$output_file"
trap - EXIT
