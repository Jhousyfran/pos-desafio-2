#!/usr/bin/env bash
set -euo pipefail

awslocal sqs create-queue --queue-name togglemaster-events >/dev/null
awslocal dynamodb create-table \
  --table-name ToggleMasterAnalytics \
  --attribute-definitions AttributeName=event_id,AttributeType=S \
  --key-schema AttributeName=event_id,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST >/dev/null
