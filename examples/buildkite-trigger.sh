#!/bin/bash
set -euo pipefail

# P4 Trigger script that triggers buildkite builds
# Usage:
# my-pipeline change-commit //depot/... "%//depot/scripts/buildkite-trigger.sh% <pipeline> %changelist% %user% %email%"

BUILDKITE_TOKEN="<YOUR_TOKEN>" 

ORG_SLUG=improbable
PIPELINE_SLUG=$1

CHANGELIST=$2
USER=$3
EMAIL=$4

DESCRIPTION=$(p4 -Ztag -F %desc% describe %3)

PAYLOAD="{
    \"commit\": \"@${CHANGELIST}\",
    \"branch\": \"master\",
    \"message\": \"${DESCRIPTION}\",
    \"author\": {
        \"name\": \"${USER}\",
        \"email\": \"${EMAIL}\"
    }
}"

curl --connect-timeout 3 --max-time 3 -H "Authorization: Bearer $BUILDKITE_TOKEN" -X POST "https://api.buildkite.com/v2/organizations/${ORG_SLUG}/pipelines/${PIPELINE_SLUG}/builds" \
  -d "${PAYLOAD}" || true
