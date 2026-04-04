# Coco 🐾

A pixel ghost buddy that lives on your MacBook notch and opens your social media sites while Claude thinks — then hides them when Claude replies.

Built for Claude Code CLI users who want a browse break while waiting for long responses.

---

## How it works

1. You type a prompt in Claude CLI and hit Enter
2. If your prompt is **10+ words** and Claude takes **5+ seconds** to reply, Coco opens your sites in the default browser
3. When Claude finishes replying, the browser minimizes automatically
4. If Claude replies quickly (under 5 seconds), the sites never open — no interruption

The ghost sits at the top-center of your screen near the notch:
- **Purple** = Coco is active
- **Grey** = Coco is paused
- **Double-click** the ghost to toggle on/off
- **Click and drag** to reposition

---

## Requirements

- macOS (tested on macOS Sequoia / macOS 16)
- [Homebrew](https://brew.sh)
- Claude Code CLI (`claude` command)

---

## Installation

```bash
git clone https://github.com/yourname/coco.git
cd coco
chmod +x install.sh
./install.sh
```

### Manual permissions required after install

**1. Accessibility access** (needed to minimize Chrome)

System Settings → Privacy & Security → Accessibility → add and enable your terminal app (Terminal or iTerm2)

**2. Homebrew Python in PATH** (so `python3` works correctly)

The installer adds this automatically, but if not:
```bash
echo 'export PATH="/opt/homebrew/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

---

## Launch Coco

```bash
/opt/homebrew/bin/python3.14 ~/coco/coco.py &
```

To launch on every login, add the above to your `~/.zshrc`.

---

## Customize

Edit `~/coco/coco-open.sh` to change which sites open:

```bash
open "https://youtube.com"
open "https://twitter.com"
open "https://reddit.com"
```

Change the delay (default 5s) or minimum word count (default 10) at the top of `coco-open.sh`:

```bash
DELAY=5
MIN_WORDS=10
```

---

## Files

| File | Purpose |
|------|---------|
| `coco.py` | Pixel ghost UI |
| `coco-open.sh` | Opens sites on prompt submit |
| `coco-minimize.sh` | Minimizes browser on Claude reply |
| `install.sh` | One-command installer |

Hooks are stored in `~/.claude/settings.json` under `UserPromptSubmit` and `Stop`.
