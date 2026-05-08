#!/bin/bash

set -u

# xq-python . epg.xml > epg.json
epg=epg.json

chanid=$(jq -r --arg channel "$1" '.tv.channel[] | select(.["display-name"] == $channel) | .["@id"]' "$epg")
if [[ ! $chanid ]]; then
    echo "Channel '$1' is not found!" >&2
    exit 1
fi

jq --arg chanid "$chanid" 'last(.tv.programme[] | select(.["@channel"] == $chanid and .["@start"] <= (now | strflocaltime("%Y%m%d%H%M%S %z"))))' "$epg"
jq --arg chanid "$chanid" 'first(.tv.programme[] | select(.["@channel"] == $chanid and .["@start"] > (now | strflocaltime("%Y%m%d%H%M%S %z"))))' "$epg"
