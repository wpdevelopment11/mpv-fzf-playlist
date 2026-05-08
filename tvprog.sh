#!/bin/bash

set -u

# xq-python --xml-force-list 'display-name' . epg.xml > epg.json
epg=epg_one.json

chanid=$(jq -r --arg channel "$1" 'first(.tv.channel[] | select(.["display-name"][] | [if type == "object" then .["#text"] end] | any(. == $channel)) | .["@id"])' "$epg")
if [[ ! $chanid ]]; then
    echo "Channel '$1' is not found!" >&2
    exit 1
fi

jq --arg chanid "$chanid" '[.tv.programme[] | select(.["@channel"] == $chanid and .["@stop"] >= (now | strflocaltime("%Y%m%d%H%M%S %z")))][:2]' "$epg"
