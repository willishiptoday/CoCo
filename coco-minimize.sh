#!/bin/bash
# Cancel pending open if Claude replied before delay expired
if [ -f /tmp/coco_open.pid ]; then
  PID=$(cat /tmp/coco_open.pid)
  rm -f /tmp/coco_open.pid
  kill "$PID" 2>/dev/null || true
  exit 0
fi

# Otherwise minimize Chrome
osascript -e 'tell application "System Events" to tell process "Google Chrome"
  set winCount to count of windows
  repeat with i from 1 to winCount
    set value of attribute "AXMinimized" of window i to true
  end repeat
end tell' 2>/dev/null || true
