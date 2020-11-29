#!/usr/bin/env bash

IMAGES=200
LABEL="Sketch\nAvatar\nID:{}"
FILENAME="avatar-{}.png"

LEGACY_BUCKET=sketch-legacy
MODERN_BUCKET=sketch-modern

## Remove buckets
aws s3 rb --force s3://$LEGACY_BUCKET
aws s3 rb --force s3://$MODERN_BUCKET

## Create buckets
aws s3 mb s3://$LEGACY_BUCKET
aws s3 mb s3://$MODERN_BUCKET

## Generate avatars
seq $IMAGES | xargs -P 4 -I '{}' convert -background lightblue -fill blue -size 165x70 -pointsize 18 -gravity center label:$LABEL /tmp/$FILENAME

## Store in S3
seq $(($IMAGES / 2)) | xargs -P 4 -I '{}' aws s3 cp /tmp/$FILENAME "s3://$LEGACY_BUCKET/image/$FILENAME"
seq $(($IMAGES / 2 + 1)) $IMAGES | xargs -P 4 -I '{}' aws s3 cp /tmp/$FILENAME "s3://$MODERN_BUCKET/avatar/$FILENAME"

## Remove local avatar files
rm /tmp/avatar-*.png

# Get list of avatars from both buckets
aws s3 ls s3://$LEGACY_BUCKET/image/ | cut -c32- | xargs -I '{}' echo "image/{}" > /tmp/avatars.txt
aws s3 ls s3://$MODERN_BUCKET/avatar/ | cut -c32- | xargs -I '{}' echo "avatar/{}" >> /tmp/avatars.txt

# Update the database
xargs -a /tmp/avatars.txt -I '{}' sh -c "echo '{\"s3key\": \"{}\"}' | http $(terraform output api_url)"

# Show content of database
http "$(terraform output api_url)"
