#!/bin/bash

RELOAD='
playlist=$(socat - /tmp/mpvsocket <<< "{\"command\": [\"get_property\", \"playlist\"]}")
err=$(jq -r .error <<< $playlist)
if [[ $err != "success" ]]; then
    [[ "$err" ]] && echo "Error: $err"
    exit 1
fi
jq -r ".data[] | [.title, .filename] | map(values) | @tsv" <<< $playlist | column -t -s '"$'\t'"

fzf --layout=reverse-list \
    --bind "start,ctrl-r:reload:$RELOAD" \
    --bind 'enter:execute-silent(socat - /tmp/mpvsocket <<< "{ \"command\": [\"playlist-play-index\", "{n}"] }" > /dev/null)'

