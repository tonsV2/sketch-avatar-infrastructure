#!/usr/bin/env bash

LEGACY_BUCKET=sketch-legacy

aws s3 ls s3://$LEGACY_BUCKET/image/ | cut -c32- | xargs -P 4 -I '{}' aws sqs send-message --queue-url "$(terraform output sqs_url)" --message-body 'image/{}'
