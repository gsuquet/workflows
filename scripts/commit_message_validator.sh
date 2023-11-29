#!/bin/bash

function parse_commit_message() {
    if echo "$1" | grep -Pq "^:[a-z_]+: [a-z_]+(!)?(: .*)?$"; then
        return 0
    else
        return 1
    fi
}

# Parse the commit message passed as an argument
if parse_commit_message "$1"; then
    echo "'$1' is valid"
else
    echo "'$1' is invalid"
    exit 1
fi
