---
title: "PAI Keyboard Shortcuts — Complete Reference for Sway and Waybar"
description: "Every keyboard shortcut in PAI: app launches, window management, workspaces, screenshots, media, shutdown. Organized for quick lookup."
sidebar:
  label: "Keyboard shortcuts"
  order: 1
tableOfContents:
  minHeadingLevel: 2
  maxHeadingLevel: 3
head:
  - tag: meta
    attrs:
      property: "og:description"
      content: "Every keyboard shortcut in PAI: app launches, window management, workspaces, screenshots, media, shutdown. Organized for quick lookup."
  - tag: meta
    attrs:
      name: "keywords"
      content: "PAI keyboard shortcuts", "Sway keyboard reference", "PAI hotkeys", "bootable Linux shortcuts"
---


Full reference of every keyboard shortcut in PAI — bookmarkable, skimmable, no tutorials. For a guided tour of the desktop, see [Desktop Basics](../first-steps/desktop-basics.md).

The modifier key throughout is **Alt** (set as `Mod1` in the Sway config at `/etc/skel/.config/sway/config`).

## At-a-glance — the 10 shortcuts you'll use daily

| Shortcut | Action |
|---|---|
| `Alt+Return` | Open terminal |
| `Alt+D` | App launcher (all installed apps) |
| `Alt+S` | PAI settings menu |
| `Alt+B` | Firefox → Open WebUI |
| `Alt+E` | File manager |
| `Alt+F4` | Close window |
| `Alt+Arrow` | Switch focus between windows |
| `Alt+1/2/3` | Switch workspaces |
| `Alt+Shift+E` | Shutdown menu |
| `Print` | Screenshot |

## Apps and launcher

| Shortcut | Action |
|---|---|
| `Alt+Return` | Open `foot` terminal |
| `Alt+D` | Wofi app launcher (fuzzy search all installed apps) |
| `Alt+S` | PAI settings menu |
| `Alt+B` | Firefox to Open WebUI |
| `Alt+E` | Thunar file manager |
| `Alt+P` | Drawing image editor |
| `Alt+Shift+B` | Electrum Bitcoin wallet (Crypto and Full profiles) |
| `Alt+Shift+P` | Firefox to phantom.app (Crypto and Full profiles) |
| `Alt+Shift+F` | Firefox to pump.fun (Crypto and Full profiles) |
| `Alt+Shift+T` | Tor Browser (Privacy and Full profiles) |
| `Alt+Shift+G` | Aisleriot solitaire (Full profile only) |
| `Alt+Shift+M` | Feather Wallet (Crypto profile only — requires external install) |

!!! note "Profile-dependent shortcuts"

    Shortcuts in the second half of the table depend on which profile PAI booted
    into. The default is `full`, which enables all of them. See
    [Boot Options](../advanced/boot-options.md#full-kernel-option-reference) for how to
    choose a different profile.


## Window management

### Focus

| Shortcut | Action |
|---|---|
| `Alt+Left` | Focus window to the left |
| `Alt+Right` | Focus window to the right |
| `Alt+Up` | Focus window above |
| `Alt+Down` | Focus window below |

### Move windows

| Shortcut | Action |
|---|---|
| `Alt+Shift+Left` | Move window to the left |
| `Alt+Shift+Right` | Move window to the right |
| `Alt+Shift+Up` | Move window up |
| `Alt+Shift+Down` | Move window down |

### Close

| Shortcut | Action |
|---|---|
| `Alt+F4` | Close focused window |

### Resize

| Shortcut | Action |
|---|---|
| `Alt+R` | Enter resize mode |

In resize mode:
| Shortcut | Action |
|---|---|
| `Left` | Shrink width by 10px |
| `Right` | Grow width by 10px |
| `Up` | Shrink height by 10px |
| `Down` | Grow height by 10px |
| `Return` or `Escape` | Exit resize mode |

## Workspaces

| Shortcut | Action |
|---|---|
| `Alt+1` | Switch to workspace 1 |
| `Alt+2` | Switch to workspace 2 |
| `Alt+3` | Switch to workspace 3 |
| `Alt+Shift+1` | Move focused window to workspace 1 |
| `Alt+Shift+2` | Move focused window to workspace 2 |
| `Alt+Shift+3` | Move focused window to workspace 3 |

Three workspaces are defined by default. Typical usage: workspace 1 for browser/Open WebUI, 2 for terminal, 3 for files/notes.

## Screenshots

| Shortcut | Action |
|---|---|
| `Print` | Full-screen screenshot → `~/Pictures/screenshot-YYYYMMDD-HHMMSS.png` |
| `Shift+Print` | Region screenshot (click and drag to select) |

Screenshots use `grim` (full-screen) and `grim -g "$(slurp)"` (region). Results go to the Pictures folder. On a live system without persistence, they're RAM-only and lost at shutdown — save to an external drive if you need to keep them.

## System

| Shortcut | Action |
|---|---|
| `Alt+L` | Lock screen (swaylock, black screen, password to unlock) |
| `Alt+Shift+E` | Shutdown menu (`pai-shutdown`) |
| `XF86PowerOff` | Shutdown menu (hardware power button) |

See [Shutting Down](../first-steps/shutting-down.md) for the shutdown menu options, including memory wipe.

## Media and volume

These work on keyboards with media keys (most modern laptops) via `XF86` key codes.

| Shortcut | Action |
|---|---|
| `XF86AudioPlay` | Play/pause (via `playerctl`) |
| `XF86AudioNext` | Next track |
| `XF86AudioPrev` | Previous track |
| `XF86AudioRaiseVolume` | Volume up 5% |
| `XF86AudioLowerVolume` | Volume down 5% |
| `XF86AudioMute` | Mute toggle |

## Brightness (laptops)

| Shortcut | Action |
|---|---|
| `XF86MonBrightnessUp` | Brightness up 5% |
| `XF86MonBrightnessDown` | Brightness down 5% |

Uses `brightnessctl`. If your laptop's brightness keys don't work, it's usually a driver / kernel module issue, not a PAI configuration issue.

## Wofi shortcuts (inside the launcher)

| Shortcut | Action |
|---|---|
| Type to filter | Fuzzy search installed apps |
| `Up/Down` or `Tab` | Navigate |
| `Return` | Launch selected |
| `Escape` | Close without launching |

## Terminal (foot) shortcuts

| Shortcut | Action |
|---|---|
| `Ctrl+Shift+C` | Copy |
| `Ctrl+Shift+V` | Paste |
| `Ctrl+Shift+N` | New terminal window |
| `Ctrl+Shift+U` | Unicode input |
| `Ctrl+Shift++` / `Ctrl+Shift+-` | Increase / decrease font size |
| `Ctrl+Shift+0` | Reset font size |

## Firefox shortcuts (standard)

Firefox uses its default Firefox shortcuts. Non-exhaustive highlights:

| Shortcut | Action |
|---|---|
| `Ctrl+T` | New tab |
| `Ctrl+W` | Close tab |
| `Ctrl+Shift+T` | Reopen closed tab |
| `Ctrl+L` | Focus address bar |
| `Ctrl+Shift+P` | Private browsing window |
| `F11` | Fullscreen toggle |

Note: Firefox's `Ctrl+Shift+T` shortcut conflicts with the Sway `Alt+Shift+T` for Tor Browser launch. Sway's keybinding fires first because it uses `Alt`, so there's no actual conflict.

## Customizing shortcuts

PAI's Sway config lives at `/etc/skel/.config/sway/config`. On a live system, changes require rebuilding the ISO to persist — see [Building from Source](../advanced/building-from-source.md).

Alternative: with persistence enabled (v0.2+), you can override specific bindings in `~/.config/sway/config` without rebuilding.

## What you cannot do with keyboard alone

Some actions still require mouse or terminal:
- Right-click in Thunar
- Dragging files between windows
- Sizing the terminal to exact pixel dimensions

This is a normal tradeoff in tiling window managers — they optimize for keyboard-driven workflows.

## Related documentation

- [**Desktop Basics**](../first-steps/desktop-basics.md) — Guided tour of the desktop
- [**First Boot Walkthrough**](../first-steps/first-boot-walkthrough.md) — Starting out
- [**How PAI Works**](../general/how-pai-works.md) — Architecture context
- [**Sway upstream docs**](https://github.com/swaywm/sway/wiki) — All Sway features
