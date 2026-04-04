#!/opt/homebrew/bin/python3.14
"""Coco - pixel buddy that sits on your notch ledge"""
import tkinter as tk
import os

DISABLED_FILE = "/tmp/coco_disabled"

GHOST = [
    "  XXX  ",
    " XXXXX ",
    "XXXXXXX",
    "XX X XX",
    "XXXXXXX",
    "XXXXXXX",
    "X X X X",
    "  X X  ",
]

CELL = 6
W = len(GHOST[0]) * CELL
H = len(GHOST) * CELL


def draw_ghost(canvas, enabled):
    canvas.delete("all")
    color = "#E8D5FF" if enabled else "#555555"
    for r, row in enumerate(GHOST):
        for c, ch in enumerate(row):
            if ch == "X":
                x0, y0 = c * CELL, r * CELL
                canvas.create_rectangle(x0, y0, x0 + CELL, y0 + CELL,
                                        fill=color, outline="")


def main():
    # Start enabled — clean up any leftover disabled flag
    try: os.remove(DISABLED_FILE)
    except: pass
    enabled = [True]

    root = tk.Tk()
    root.title("Coco")
    root.attributes("-topmost", True)
    root.config(bg="black")

    sw = root.winfo_screenwidth()
    root.geometry(f"{W}x{H}+{(sw - W) // 2}+4")
    root.update()
    root.overrideredirect(True)

    canvas = tk.Canvas(root, width=W, height=H, bg="black", highlightthickness=0)
    canvas.pack()
    draw_ghost(canvas, enabled[0])

    # Toggle on double-click
    def on_double_click(e):
        enabled[0] = not enabled[0]
        if enabled[0]:
            try: os.remove(DISABLED_FILE)
            except: pass
        else:
            open(DISABLED_FILE, "w").close()
        draw_ghost(canvas, enabled[0])

    canvas.bind("<Double-Button-1>", on_double_click)

    # Drag to reposition
    def start_drag(e): root._dx, root._dy = e.x, e.y
    def do_drag(e):
        x = root.winfo_x() + e.x - root._dx
        y = root.winfo_y() + e.y - root._dy
        root.geometry(f"+{x}+{y}")

    canvas.bind("<ButtonPress-1>", start_drag)
    canvas.bind("<B1-Motion>", do_drag)

    root.mainloop()


if __name__ == "__main__":
    main()
