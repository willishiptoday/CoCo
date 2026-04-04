#!/bin/bash
set -e

echo "Installing Coco..."

# 1. Install Homebrew Python with tkinter
if ! command -v brew &>/dev/null; then
  echo "Error: Homebrew is required. Install from https://brew.sh"
  exit 1
fi

brew install python-tk 2>/dev/null || true

# Find python3 from Homebrew (works on both Apple Silicon and Intel)
PYTHON=$(brew --prefix)/bin/python3
if [ ! -f "$PYTHON" ]; then
  # fallback: find any python3.x in brew prefix
  PYTHON=$(ls $(brew --prefix)/bin/python3.* 2>/dev/null | sort -V | tail -1)
fi

if [ ! -f "$PYTHON" ]; then
  echo "Error: Could not find Homebrew Python. Run: brew install python"
  exit 1
fi

echo "Using Python: $PYTHON"

# 2. Copy files to ~/coco
mkdir -p ~/coco
cp coco.py coco-open.sh coco-minimize.sh ~/coco/
chmod +x ~/coco/coco-open.sh ~/coco/coco-minimize.sh

# 3. Update shebang to local python path
sed -i '' "1s|.*|#!${PYTHON}|" ~/coco/coco.py

# 4. Wire hooks into ~/.claude/settings.json
SETTINGS=~/.claude/settings.json
if [ ! -f "$SETTINGS" ]; then
  echo '{}' > "$SETTINGS"
fi

# Inject hooks using python (avoids jq dependency)
$PYTHON - <<EOF
import json, sys

with open("$SETTINGS") as f:
    cfg = json.load(f)

cfg.setdefault("hooks", {})
cfg["hooks"]["UserPromptSubmit"] = [{"hooks": [{"type": "command", "command": "~/coco/coco-open.sh"}]}]
cfg["hooks"]["Stop"] = [{"hooks": [{"type": "command", "command": "~/coco/coco-minimize.sh"}]}]

with open("$SETTINGS", "w") as f:
    json.dump(cfg, f, indent=2)

print("Hooks added to settings.json")
EOF

# 5. Add Homebrew Python to PATH if needed
if ! grep -q 'homebrew/bin' ~/.zshrc 2>/dev/null; then
  echo 'export PATH="/opt/homebrew/bin:$PATH"' >> ~/.zshrc
  echo "Added Homebrew to PATH in ~/.zshrc"
fi

echo ""
echo "Done! Start Coco with:"
echo "  /opt/homebrew/bin/python3.14 ~/coco/coco.py &"
echo ""
echo "To launch on login, add the above line to your ~/.zshrc"
