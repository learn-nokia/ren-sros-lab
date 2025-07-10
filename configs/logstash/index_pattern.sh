#!/bin/bash

DASHBOARDS_HOST="http://localhost:5601"
USERNAME="admin"
PASSWORD="Nokia2018!"
INDEX_PATTERN_ID="syslog-*"
INDEX_TITLE="syslog-*"

# Wait for Dashboards to be ready
echo "Waiting for OpenSearch Dashboards to become ready..."

while true; do
  STATUS=$(curl -s -u $USERNAME:$PASSWORD "$DASHBOARDS_HOST/api/status" | jq -r '.status.overall.state')
  if [[ "$STATUS" == "green" ]]; then
    echo "OpenSearch Dashboards is ready (status: $STATUS)"
    break
  else
    echo "Current status: $STATUS... retrying in 5 seconds"
    sleep 5
  fi
done

# Create the index pattern
echo "Creating index pattern: $INDEX_TITLE..."

curl -s -X POST "$DASHBOARDS_HOST/api/saved_objects/index-pattern/$INDEX_PATTERN_ID" \
  -u $USERNAME:$PASSWORD \
  -H 'osd-xsrf: true' \
  -H 'Content-Type: application/json' \
  -d "{
    \"attributes\": {
      \"title\": \"$INDEX_TITLE\",
      \"timeFieldName\": \"timestamp\"
    }
  }" | jq

echo "Index pattern [$INDEX_TITLE] created successfully."

