# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Coco is a macOS-only pixel ghost widget that lives near the MacBook notch. It integrates with Claude Code CLI via hooks to open browser tabs while Claude is "thinking" on long prompts, then minimizes the browser when Claude finishes replying.

**Tech stack:** Python 3 (tkinter for the GUI), Bash shell scripts, AppleScript (for Chrome control), Claude Code `~/.claude/settings.json` hooks.

## Running Coco

```bash
# Start the ghost widget (runs in background)
/opt/homebrew/bin/python3 ~/coco/coco.py &

# Install (copies files to ~/coco and wires Claude Code hooks)
./install.sh
```

The shebang in `coco.py` is rewritten by `install.sh` to point to the local Homebrew Python path, so running it directly from the repo requires Homebrew Python with tkinter (`brew install python-tk`).

## Architecture

All four files are standalone — there are no imports between them and no dependencies beyond Python stdlib + tkinter.

**`coco.py`** — tkinter window with `overrideredirect(True)` (no title bar), always on top, positioned near the notch. State is communicated to the shell scripts entirely via a flag file `/tmp/coco_disabled`. Double-clicking toggles enabled/disabled; dragging repositions.

**`coco-open.sh`** — Fired by the Claude Code `UserPromptSubmit` hook. Reads the submitted prompt from stdin, checks word count against `MIN_WORDS`, writes its own PID to `/tmp/coco_open.pid`, sleeps `DELAY` seconds, then opens URLs. The PID file is the cancellation mechanism.

**`coco-minimize.sh`** — Fired by the Claude Code `Stop` hook. If `/tmp/coco_open.pid` exists (Claude replied before the delay expired), it kills the pending `coco-open.sh` sleep and exits without opening anything. Otherwise it runs AppleScript to minimize all Chrome windows.

**`install.sh`** — Copies files to `~/coco/`, rewrites `coco.py`'s shebang to the resolved Homebrew Python path, and injects the two hooks into `~/.claude/settings.json` using Python's `json` module (no `jq` dependency).

## Key Details

- Sites to open are hardcoded in `coco-open.sh` — edit that file to change them.
- `DELAY` and `MIN_WORDS` are variables at the top of `coco-open.sh`.
- The `~/coco/` install directory is separate from this repo; `install.sh` copies files there.
- AppleScript in `coco-minimize.sh` requires Accessibility permission for the terminal app (System Settings → Privacy & Security → Accessibility).
- The hooks are written to the **global** `~/.claude/settings.json`, not a project-level file.
