#!/usr/bin/env bash

#TODO: Send messages in batch - https://docs.aws.amazon.com/cli/latest/reference/sqs/send-message-batch.html

LEGACY_BUCKET=sketch-legacy
CONCURRENT_PROCESSES=8

aws s3 ls s3://$LEGACY_BUCKET/image/ | cut -c32- | xargs -P $CONCURRENT_PROCESSES -I '{}' aws sqs send-message --queue-url "$(terraform output sqs_url)" --message-body 'image/{}'
