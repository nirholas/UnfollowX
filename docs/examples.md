# PAI examples

Private AI on a bootable USB drive. Your secure, offline-first AI assistant — carry it anywhere, leave no trace.

## Example 1

```bash
> git clone https://github.com/nirholas/pai.git && cd pai
> docker build -f Dockerfile.build -t pai-builder .
> docker run --privileged --rm -v "$PWD/output:/output" pai-builder
> # ISO appears at output/live-image-amd64.hybrid.iso
>
```

## Example 2

```bash
# One-command download and flash (Linux/macOS):
curl -fsSL https://raw.githubusercontent.com/nirholas/pai/main/scripts/flash.sh | sudo bash
```

## Example 3

```bash
# Download the ISO
curl -LO https://github.com/nirholas/pai/releases/latest/download/pai.iso

# Flash to USB (replace /dev/sdX with your USB device)
sudo dd if=pai.iso of=/dev/sdX bs=4M status=progress && sync
```

## Example 4

```text
USB plugged in → BIOS/UEFI selects USB → GRUB/ISOLINUX loads kernel
    → Debian live-boot mounts squashfs from USB
    → systemd starts services:
        1. MAC address randomization (pai-mac-spoof.service)
        2. UFW firewall (deny incoming, allow outgoing, localhost only)
        3. Ollama LLM server (localhost:11434)
        4. Chat UI web server (localhost:8080)
        5. NetworkManager (Wi-Fi/Ethernet)
    → Auto-login on tty1 → Sway (Wayland) launches
    → Firefox ESR opens to localhost:8080 (Chat UI)
```

## Example 5

```text
┌─────────────────────────────────────────────┐
│              Security Defaults              │
├─────────────────────────────────────────────┤
│ ✓ MAC randomized on every boot              │
│ ✓ Firewall: deny incoming, localhost only   │
│ ✓ No SSH server enabled by default          │
│ ✓ GPG configured with SHA-512 + AES-256     │
│ ✓ Tor pre-configured (opt-in activation)    │
│ ✓ WireGuard available for VPN tunnels       │
│ ✓ LUKS available for encrypted volumes      │
│ ✓ No telemetry, no analytics, no phoning    │
│   home — ever                               │
│ ✓ Firefox ESR with hardened policies        │
│ ✓ Automatic memory wipe on shutdown         │
└─────────────────────────────────────────────┘
```

## Example 6

```bash
qemu-system-x86_64 \
  -cdrom pai.iso \
  -m 4096 \
  -smp 2 \
  -enable-kvm    # Linux only; omit on macOS/Windows
```

## Example 7

```bash
curl -fsSL https://raw.githubusercontent.com/nirholas/pai/main/scripts/flash.sh | sudo bash
```

## Example 8

```bash
# Find your USB device
lsblk -d -o NAME,SIZE,MODEL,TRAN | grep usb

# Unmount if mounted
sudo umount /dev/sdX*

# Flash
sudo dd if=pai.iso of=/dev/sdX bs=4M status=progress && sync
```


Every snippet above is taken from the [repository documentation](https://github.com/nirholas/PAI#readme).
