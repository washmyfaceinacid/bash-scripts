#!/usr/bin/env bash
set -euo pipefail

usage() {
    printf 'Usage: %s -s <shift> -i <input file> -o <output file>\n' "$(basename "$0")" >&2
    exit 1
}

shift_value=
input_file=
output_file=

while getopts ':s:i:o:' opt; do
    case $opt in
        s) shift_value=$OPTARG ;;
        i) input_file=$OPTARG ;;
        o) output_file=$OPTARG ;;
        :) usage ;;
        \?) usage ;;
    esac
done

shift $((OPTIND - 1))

if [[ -z ${shift_value:-} || -z ${input_file:-} || -z ${output_file:-} || $# -ne 0 ]]; then
    usage
fi

if [[ ! -f $input_file ]]; then
    printf 'Input file not found: %s\n' "$input_file" >&2
    exit 1
fi

SHIFT=$(((shift_value % 26 + 26) % 26)) perl -pe '
    s/([A-Za-z])/
        my $c = $1;
        my $base = lc($c) eq $c ? ord("a") : ord("A");
        chr($base + (ord($c) - $base + $ENV{SHIFT}) % 26);
    /eg;
' "$input_file" > "$output_file"
