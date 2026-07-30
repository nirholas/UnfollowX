---
title: Glossary
description: Plain-language definitions of terms used throughout PAI, enriched with cross-links to the relevant docs pages and prompts.
order: 110
updated: 2026-04-17
---

# Glossary

## How to use this glossary

Most entries on this page appear as inline links across the rest of the
docs site. If you landed here from a link, the entry you want is
probably already highlighted; otherwise, Ctrl+F is your friend — terms
are alphabetized. Each entry has a short definition and a **Where it
shows up in PAI** subline that points to the page or prompt where the
concept is discussed in depth. Related terms are listed under
**See also**.

The authoritative short version lives at the repo root in
[GLOSSARY.md](../reference/glossary.md); this docs-site version is identical
in meaning but enriched for in-site navigation. For quick answers to
how these terms apply in practice, see the [FAQ](./faq.md).

---

## AMD64

The 64-bit x86 CPU architecture used by most Intel and AMD laptops and
desktops. PAI ships a dedicated AMD64 ISO for these machines.

**Where it shows up in PAI:** [installation](../installation.md),
[architecture overview](../architecture/overview.md).
**See also:** [ARM64](#arm64), [ISO](#iso), [UEFI](#uefi).

## Argon2id

A memory-hard password hashing function used by [LUKS](#luks) to derive
the encryption key for [persistence](#persistence). Its memory cost
makes GPU brute-force attacks expensive.

**Where it shows up in PAI:** [architecture/security.md](../architecture/security.md),
[prompts/documentation/05-security-privacy-ethics.md](../../prompts/documentation/05-security-privacy-ethics.md).
**See also:** [LUKS](#luks), [persistence](#persistence).

## ARM64

The 64-bit ARM CPU architecture used by Apple Silicon, most Raspberry
Pi 4/5 boards, and many [SBCs](#sbc). PAI ships a separate ARM64 image.

**Where it shows up in PAI:** [installation](../installation.md),
[usage/hardware.md](../usage/hardware.md).
**See also:** [AMD64](#amd64), [SBC](#sbc).

## chroot

A Unix mechanism that runs a process with a different apparent root
directory. PAI's build scripts use chroot to install and configure the
live system before packing it into a [squashfs](#squashfs).

**Where it shows up in PAI:** [development/build.md](../development/build.md).
**See also:** [debootstrap](#debootstrap), [squashfs](#squashfs).

## CoW

Copy-on-write. A storage technique where writes go to new blocks
rather than overwriting. PAI uses CoW via [overlayfs](#overlayfs) to
make the read-only squashfs appear writable.

**Where it shows up in PAI:** [architecture/storage.md](../architecture/storage.md).
**See also:** [overlayfs](#overlayfs), [squashfs](#squashfs).

## debootstrap

A Debian tool that bootstraps a minimal Debian/Ubuntu root filesystem
from scratch. It is the first step of the PAI live build.

**Where it shows up in PAI:** [development/build.md](../development/build.md),
[prompts/documentation/22-docs-dev-setup.md](../../prompts/documentation/22-docs-dev-setup.md).
**See also:** [chroot](#chroot), [squashfs](#squashfs).

## dm-crypt

The Linux kernel's disk encryption subsystem. [LUKS](#luks) is the
standard on-disk format built on top of dm-crypt.

**Where it shows up in PAI:** [architecture/security.md](../architecture/security.md).
**See also:** [LUKS](#luks), [persistence](#persistence).

## ext4

A mature Linux filesystem. PAI uses ext4 inside the
[persistence](#persistence) LUKS container.

**Where it shows up in PAI:** [architecture/storage.md](../architecture/storage.md).
**See also:** [LUKS](#luks), [persistence](#persistence).

## initramfs

A small, in-memory root filesystem the kernel loads before the real
root is ready. PAI's initramfs contains the code that mounts the
squashfs and unlocks persistence.

**Where it shows up in PAI:** [architecture/boot.md](../architecture/boot.md).
**See also:** [squashfs](#squashfs), [overlayfs](#overlayfs).

## ISO

A single-file disk image (originally for CDs) that can be written to a
USB stick to produce a bootable drive. PAI distributes ISO files for
AMD64 and ARM64.

**Where it shows up in PAI:** [installation](../installation.md),
[quickstart](../quickstart.md).
**See also:** [xorriso](#xorriso), [UEFI](#uefi).

## LLM

Large Language Model. The category of AI model served by
[Ollama](#ollama) inside PAI.

**Where it shows up in PAI:** [usage/ai.md](../usage/ai.md),
[architecture/ai-stack.md](../architecture/ai-stack.md).
**See also:** [Ollama](#ollama), [quantization](#quantization).

## LUKS

Linux Unified Key Setup — the on-disk format used to encrypt PAI's
[persistence](#persistence) volume. Backed by [dm-crypt](#dm-crypt)
and keyed with [Argon2id](#argon2id).

**Where it shows up in PAI:** [architecture/security.md](../architecture/security.md),
[usage/persistence.md](../usage/persistence.md).
**See also:** [Argon2id](#argon2id), [dm-crypt](#dm-crypt),
[persistence](#persistence).

## MAC address

A unique identifier burned into network hardware. PAI randomizes MAC
addresses at boot by default, so networks can't track the device
across sessions.

**Where it shows up in PAI:** [architecture/network.md](../architecture/network.md).
**See also:** [Tor](#tor).

## minisign

A small, fast signature tool by the libsodium author. PAI release
artifacts are signed with minisign so you can verify authenticity.

**Where it shows up in PAI:** [installation](../installation.md),
[development/release.md](../development/release.md).
**See also:** [SemVer](#semver).

## Monero

A privacy-preserving cryptocurrency. Its wallet software ships with
PAI.

**Where it shows up in PAI:** [usage/crypto.md](../usage/crypto.md),
[FAQ — crypto](./faq.md#crypto).
**See also:** [persistence](#persistence), [Tor](#tor).

## Ollama

A local LLM runner that exposes a simple HTTP API and manages model
downloads, [quantization](#quantization), and GPU acceleration. PAI
ships Ollama preinstalled.

**Where it shows up in PAI:** [usage/ai.md](../usage/ai.md),
[api/ollama.md](../api/ollama.md).
**See also:** [LLM](#llm), [quantization](#quantization).

## overlayfs

A Linux union filesystem that stacks a writable layer on top of a
read-only one. PAI stacks a tmpfs (or persistent LUKS volume) on top
of the [squashfs](#squashfs) so the system appears fully writable.

**Where it shows up in PAI:** [architecture/storage.md](../architecture/storage.md).
**See also:** [CoW](#cow), [squashfs](#squashfs).

## persistence

PAI's optional encrypted volume — a [LUKS](#luks) container on the USB
stick that stores files you want to keep across reboots (wallets,
models, GPG keys, browser profiles). Off by default.

**Where it shows up in PAI:** [usage/persistence.md](../usage/persistence.md),
[FAQ — privacy](./faq.md#privacy).
**See also:** [LUKS](#luks), [Argon2id](#argon2id), [ext4](#ext4).

## PGP

Pretty Good Privacy — the family of standards (OpenPGP / GnuPG) for
signing and encrypting data and email. PAI ships GnuPG.

**Where it shows up in PAI:** [usage/email-and-pgp.md](../usage/email-and-pgp.md).
**See also:** [minisign](#minisign).

## quantization

Reducing an LLM's weights to lower precision (e.g. 16-bit → 4-bit) so
it fits in less memory and runs faster, at a small quality cost. Most
CPU-usable models in PAI are quantized.

**Where it shows up in PAI:** [usage/ai.md](../usage/ai.md),
[architecture/ai-stack.md](../architecture/ai-stack.md).
**See also:** [LLM](#llm), [Ollama](#ollama).

## SBC

Single-Board Computer (e.g. Raspberry Pi, Rock 5B). PAI's
[ARM64](#arm64) image targets common SBCs.

**Where it shows up in PAI:** [usage/hardware.md](../usage/hardware.md).
**See also:** [ARM64](#arm64).

## SemVer

Semantic Versioning (MAJOR.MINOR.PATCH). PAI follows SemVer for
release numbering.

**Where it shows up in PAI:** [development/release.md](../development/release.md),
[../RELEASE.md](../RELEASE.md).
**See also:** [minisign](#minisign).

## squashfs

A compressed, read-only Linux filesystem. PAI's root filesystem ships
as a squashfs so the whole OS fits on a USB and can be verified by
hash. Paired with [overlayfs](#overlayfs) for writability.

**Where it shows up in PAI:** [architecture/storage.md](../architecture/storage.md).
**See also:** [overlayfs](#overlayfs), [CoW](#cow),
[initramfs](#initramfs).

## SSD wear

The finite write endurance of flash memory. Heavy writes on a live-USB
session shorten USB stick lifespan; PAI minimizes writes by default.

**Where it shows up in PAI:** [usage/hardware.md](../usage/hardware.md).
**See also:** [overlayfs](#overlayfs).

## Sway

A tiling Wayland compositor (i3-compatible). PAI's default desktop.

**Where it shows up in PAI:** [usage/desktop.md](../usage/desktop.md).
**See also:** [Wayland](#wayland).

## Tor

An anonymity network that routes traffic through three relays to hide
your network location. PAI can route all traffic through Tor.

**Where it shows up in PAI:** [architecture/network.md](../architecture/network.md),
[FAQ — privacy](./faq.md#privacy).
**See also:** [MAC address](#mac-address).

## UEFI

The modern firmware standard that has replaced legacy BIOS. PAI boots
via UEFI on most modern machines.

**Where it shows up in PAI:** [installation](../installation.md),
[FAQ — install & boot](./faq.md#install-boot).
**See also:** [ISO](#iso).

## UFW

Uncomplicated Firewall — a friendly frontend for the Linux
`nftables`/`iptables` firewall. PAI ships a default-deny UFW profile.

**Where it shows up in PAI:** [architecture/network.md](../architecture/network.md).
**See also:** [Tor](#tor).

## Wayland

A modern Linux display protocol replacing X11. PAI uses Wayland via
[Sway](#sway). Some older GPUs still fall back to X11.

**Where it shows up in PAI:** [usage/desktop.md](../usage/desktop.md),
[../KNOWN_ISSUES.md](../KNOWN_ISSUES.md).
**See also:** [Sway](#sway).

## xorriso

The tool PAI's build pipeline uses to assemble the final hybrid
[ISO](#iso) that can boot from both CD and USB.

**Where it shows up in PAI:** [development/build.md](../development/build.md).
**See also:** [ISO](#iso).
