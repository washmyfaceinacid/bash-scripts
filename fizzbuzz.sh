#!/usr/bin/env bash

for (( number=1; number<=100; number++ )); do
    if (( number % 15 == 0 )); then
        printf 'FizzBuzz\n'
    elif (( number % 3 == 0 )); then
        printf 'Fizz\n'
    elif (( number % 5 == 0 )); then
        printf 'Buzz\n'
    else
        printf '%s\n' "$number"
    fi
done
