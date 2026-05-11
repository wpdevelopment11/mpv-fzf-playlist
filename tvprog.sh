#!/bin/bash

set -u

# xq-python --xml-force-list 'display-name' . epg.xml > epg.json
epg=epg.json

channels=$(jq --argjson channels "$(printf "%s\n" "$@" | jq -R | jq -s)" '[$channels[] as $channel | first(.tv.channel[] | select(.["display-name"][] | [if type == "object" then .["#text"] end] | any(. == $channel)) | {name: $channel, id: .["@id"]})]' "$epg")

jq -r --argjson channels "$channels" '$channels[] as $ch | [$ch.name, (.tv.programme[] | select(.["@channel"] == $ch.id and .["@stop"] >= (now | strflocaltime("%Y%m%d%H%M%S %z"))) | .title | if type == "object" then .["#text"] end)][:3] | @tsv' "$epg" | column -t -s $'\t'
