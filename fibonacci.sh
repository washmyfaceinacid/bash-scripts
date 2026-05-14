#!/usr/bin/env bash

fib() {
	local n=$1 a=0 b=1 t

	while (( n-- > 0 )); do
		t=$a
		a=$b
		b=$(( t + b ))
	done

	printf '%s\n' "$a"
}

if [[ ${BASH_SOURCE[0]} == "$0" ]]; then
	if [[ $# -ne 1 ]]; then
		printf 'Usage: %s <non-negative integer>\n' "$0" >&2
		exit 1
	fi

	fib "$1"
fi
