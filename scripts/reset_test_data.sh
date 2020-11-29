#!/usr/bin/env bash

LEGACY_BUCKET=sketch-legacy
MODERN_BUCKET=sketch-modern

# Remove legacy avatars from the modern bucket
aws s3 ls s3://$LEGACY_BUCKET/image/ | cut -c32- | xargs -I '{}' aws s3 rm "s3://$MODERN_BUCKET/avatar/{}"

# Get all avatars
aws s3 ls s3://$LEGACY_BUCKET/image/ | cut -c32- | xargs -I '{}' echo "image/{}" > /tmp/avatars.txt
aws s3 ls s3://$MODERN_BUCKET/avatar/ | cut -c32- | xargs -I '{}' echo "avatar/{}" >> /tmp/avatars.txt

## Delete database entries
http delete "$(terraform output api_url)/delete-avatars"

# Update the database
xargs -a /tmp/avatars.txt -I '{}' sh -c "echo '{\"s3key\": \"{}\"}' | http $(terraform output api_url)"

# Show content of database
http "$(terraform output api_url)"
