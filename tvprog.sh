#!/bin/bash

set -u

# xq-python --xml-force-list 'display-name' . epg.xml > epg.json
epg=epg.json

jq -nr \
 '(input | .tv) as $tv
| (input | .[]) as $channel
| first($tv.channel[]
| select(.["display-name"][]
    | [if type == "object" then .["#text"] end]
    | any(. == $channel))
| {name: $channel, id: .["@id"]})
| . as $ch
| [$ch.name, ($tv.programme[]
| select(.["@channel"] == $ch.id and .["@stop"] >= (now | strflocaltime("%Y%m%d%H%M%S %z")))
| .title
| if type == "object" then .["#text"] end)][:3]
| @tsv' "$epg" <(printf "%s\n" "$@" | jq -R | jq -s) | column -t -s $'\t'
