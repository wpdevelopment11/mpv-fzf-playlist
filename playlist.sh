#!/bin/bash

socat - /tmp/mpvsocket <<< '{"command": ["get_property", "playlist"]}' \
    | jq -r ".data | to_entries[] |  [.key, .value.title, .value.filename] | map(values) | @tsv" | sort -bk2,2 -t $'\t'
