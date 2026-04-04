#!/bin/bash
# Coco: open sites only if enabled, prompt is long enough, and Claude takes a while

DELAY=5
MIN_WORDS=10
TOGGLE_FILE="/tmp/coco_enabled"
DISABLED_FILE="/tmp/coco_disabled"

# Check toggle — disabled only if explicitly turned off via double-click
[ -f "$DISABLED_FILE" ] && exit 0

# Check word count
PROMPT=$(cat)
WORD_COUNT=$(echo "$PROMPT" | wc -w | tr -d ' ')
[ "$WORD_COUNT" -ge "$MIN_WORDS" ] || exit 0

echo $$ > /tmp/coco_open.pid
sleep "$DELAY"

if [ -f /tmp/coco_open.pid ]; then
  rm /tmp/coco_open.pid
  open "https://youtube.com"
fi
