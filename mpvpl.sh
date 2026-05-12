#!/bin/bash

RELOAD='join -a 1 -1 2 -t $'"'\t'"' <(./playlist.sh) <(./tv.sh) | awk -F"\t" '"'"'BEGIN{OFS="\t"} {tmp=$1; $1=$2; $2=tmp; print}'"'"' | column -t -s $'"'\t'"

fzf --layout=reverse-list \
    --bind "start,ctrl-r:reload:$RELOAD" \
    --bind 'enter:execute-silent(socat - /tmp/mpvsocket <<< "{ \"command\": [\"playlist-play-index\", "{1}"] }" > /dev/null)'

