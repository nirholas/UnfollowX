---
title: Frequently asked questions
description: Answers to common questions about PAI, organized by topic and cross-linked to the glossary and the rest of the docs site.
order: 120
updated: 2026-04-17
---

# Frequently asked questions

You're looking at the docs-site FAQ. The repo-root FAQ lives at
[/FAQ.md](../reference/faq.md) and is kept in sync with this page on every
release. If your question isn't here, check
[known issues](../KNOWN_ISSUES.md), the
[troubleshooting guide](../usage/troubleshooting.md), or ask via
[SUPPORT.md](../../SUPPORT.md).

Terms in **bold-ish** code are links to the [glossary](./glossary.md).

---

## General

### What is PAI?

PAI (Private AI) is a bootable live operating system that bundles
local AI inference, privacy tooling ([Tor](./glossary.md#tor),
hardened browsers), and crypto wallets onto a single USB stick. It
runs entirely from removable media and forgets everything when you
shut down — unless you opt into encrypted
[persistence](./glossary.md#persistence).

See: [overview](../index.md), [quickstart](../quickstart.md).

### How is PAI different from Tails?

Tails focuses on anonymity via Tor and leaves no trace. PAI shares
that amnesic foundation but adds local [LLMs](./glossary.md#llm) (via
[Ollama](./glossary.md#ollama)), GPU-aware model runners, and crypto
wallets preconfigured for offline signing. Think of PAI as "Tails + a
local AI workstation."

See: [editions](../editions.md), [architecture](../architecture/overview.md).

### How is PAI different from Qubes OS?

Qubes is an installed OS that isolates workloads in Xen VMs on your
primary disk. PAI is a live USB that boots on almost any
[AMD64](./glossary.md#amd64) or [ARM64](./glossary.md#arm64) machine
without touching the internal drive. Different threat models,
different workflows.

### How is PAI different from Kodachi?

Kodachi is a privacy-oriented live distro with a heavier desktop and
a different trust model. PAI is narrower in scope (privacy + local
AI + crypto), reproducibly built, and signed with
[minisign](./glossary.md#minisign).

### Is PAI free?

Yes. PAI is free and open source. See [LICENSE](../../LICENSE).

### Who makes PAI?

A small group of maintainers plus community contributors. See
[MAINTAINERS.md](../MAINTAINERS.md) and
[AUTHORS.md](../AUTHORS.md).

---

## Install & boot

### Will installing PAI delete my data?

No. PAI writes to the USB stick you flash, not to your internal
drive. Flashing the USB will erase everything already on that
specific USB — so pick an empty one or back up first.

See: [installation guide](../installation.md).

### What size USB do I need?

Minimum 16 GB for a basic session; 32 GB or larger is recommended if
you plan to enable [persistence](./glossary.md#persistence) and
download [LLM](./glossary.md#llm) models. Fast USB 3.0+ sticks
dramatically improve boot and model load times.

### Can I run PAI on a Raspberry Pi?

Yes, on Pi 5, Pi 4, Pi 400, and Pi Zero 2 W (arm64 models only). The easiest path is Raspberry Pi Imager — add `https://pai.direct/imager.json` as a custom repository and pick PAI from the OS list. See [Install PAI on Raspberry Pi](../first-steps/using-raspberry-pi-imager.md) for the full walkthrough.

### Does PAI support the Raspberry Pi 3?

No. Pi 3 and earlier have 32-bit boot constraints that aren't compatible with the PAI arm64 image.

### Why won't PAI boot on my Mac?

Apple Silicon Macs (M1/M2/M3/M4) require the
[ARM64](./glossary.md#arm64) image and may need *reduced security*
mode. Intel Macs usually work but sometimes need the Option key held
at power-on and Secure Boot disabled in Startup Security.

See: [troubleshooting — won't boot](../usage/troubleshooting.md#wont-boot).

### Can I use PAI on a USB drive without wiping it?

Yes — use [Ventoy](../first-steps/using-ventoy.md). Ventoy installs a small boot loader on the drive once, then lets you add PAI (and other ISOs) by drag-and-drop. Existing files on the drive are preserved in the data partition Ventoy creates.

### Does Ventoy work with PAI's persistence?

Yes, but with caveats. See [Using Ventoy — Persistence](../first-steps/using-ventoy.md#using-pai-persistence-with-ventoy) for the two supported setups.

### What's the tradeoff between Ventoy and flashing directly?

Flashing (`flash.ps1` / `dd` / Rufus / balenaEtcher) gives you a drive that *is* PAI — maximally tamper-evident. Ventoy gives you a drive that *contains* PAI alongside whatever else you want — more convenient, with a tiny extra attack surface (Ventoy's own boot loader). For most users, Ventoy is the better default. For threat models that include "attacker swaps my USB", flash directly.

### Does PAI work with Secure Boot?

Signed shim support is planned but not guaranteed on every firmware.
Disable Secure Boot in your [UEFI](./glossary.md#uefi) settings if
the USB is not detected.

---

## Privacy

### Does PAI send anything to anyone?

No telemetry, no "phone home," no analytics. The only outbound
traffic is what *you* initiate (opening a browser, syncing a wallet,
or pulling an [Ollama](./glossary.md#ollama) model).

See: [architecture — network](../architecture/network.md).

### Does using Tor make me invisible?

No. [Tor](./glossary.md#tor) hides your network location, not your
behavior. Logging into a personal account, using identifying writing
style, or pairing Tor with a non-Tor identity all undermine
anonymity.

See: [threat model](../architecture/threat-model.md).

### What does encrypted persistence actually encrypt?

A single [LUKS](./glossary.md#luks) container on the USB stores any
files you explicitly opt to persist (model weights, wallet files,
GPG keys, browser profiles). Everything outside that container is
re-created at each boot and cannot be recovered.

See: [usage — persistence](../usage/persistence.md).

### Can PAI protect me from a hardware keylogger or compromised firmware?

No live OS can. PAI defends the *software* stack. If your hardware
is compromised, no operating system can save you.

---

## AI

### Which models are included?

PAI ships with a small curated set of [Ollama](./glossary.md#ollama)-compatible
models sized for CPU-only use. Larger models can be pulled after
boot if you have disk space and/or a GPU.

See: [usage — AI](../usage/ai.md).

### Do I need a GPU?

No. CPU-only inference works for small models
([quantized](./glossary.md#quantization) to 4-bit or lower). GPUs
make larger models usable — NVIDIA (CUDA) and AMD (ROCm) are
supported where drivers permit.

### Can I use GPT-4 or Claude from inside PAI?

Yes, via their APIs, but you'll be sending prompts to a third party
and that breaks the local-only threat model. Route through
[Tor](./glossary.md#tor) if you must, and understand the trade-off.

### How do I add a new model?

`ollama pull <model-name>` inside a PAI session. If you want the
model to persist across reboots, enable
[persistence](./glossary.md#persistence) and move the model into the
persistent volume.

See: [usage — AI](../usage/ai.md).

---

## Crypto

### Are the wallets safe on a live USB?

Safer than on a general-purpose OS for signing, because the
environment is amnesic and the network can be fully
[Tor](./glossary.md#tor)-routed. They are *not* a substitute for a
hardware wallet for large holdings.

See: [usage — crypto](../usage/crypto.md).

### How do I back up my wallet?

Enable [persistence](./glossary.md#persistence) and export seed
phrases to paper. Never store seed phrases unencrypted on any
networked device.

---

## Troubleshooting

### My screen is black after boot.

Usually a GPU driver or [Wayland](./glossary.md#wayland) handoff
issue.

See: [known issues](../KNOWN_ISSUES.md),
[troubleshooting — won't boot](../usage/troubleshooting.md#wont-boot).

### Wi-Fi doesn't work.

Likely a missing non-free firmware blob for your chipset.

See: [troubleshooting — Wi-Fi](../usage/troubleshooting.md#wi-fi-doesnt-work).

### Ollama is really slow.

Expected on CPU-only with large models. Try a smaller
[quantization](./glossary.md#quantization), close other apps, or add
a GPU.

### My persistence volume won't unlock.

Double-check the passphrase (case-sensitive, keyboard layout
matters). If still failing, see
[troubleshooting — persistence](../usage/troubleshooting.md#persistence-issues).

---

## Legal & ethical

### Is PAI legal where I live?

In most jurisdictions, yes. A handful of countries restrict privacy
tools like Tor or strong encryption — check your local law. PAI is a
tool; how you use it is your responsibility. See
[ETHICS.md](../ETHICS.md).

### Can I use PAI at work?

Check your employer's acceptable-use policy before booting a live
OS on company hardware. Many policies forbid it regardless of
intent.

### Can I use PAI commercially?

Yes, within the license. See [LICENSE](../../LICENSE) and
[GOVERNANCE.md](../governance.md).

---

### Can I try PAI without flashing a USB?

Yes. Run `curl -fsSL https://pai.direct/try | bash` (Linux/macOS) or `irm https://pai.direct/try.ps1 | iex` (Windows). PAI boots in a local VM in about 30 seconds. See [Try in a VM](../first-steps/try-in-a-vm.md) for details.

## Meta FAQ

### Why does this FAQ exist in two places?

Two audiences, two entry points:

- **[/FAQ.md](../reference/faq.md)** at the repo root is for people
  browsing the source tree on GitHub, a mirror, or a cloned checkout.
  It needs to stand alone without a docs site to link into.
- **This page** (`docs/reference/faq.md`) is for people reading the
  rendered docs site. It enriches each answer with glossary links
  and deep pointers into `docs/`.

The two are kept **semantically identical**. The docs-site copy adds
links; it never adds, removes, or changes answers. PR reviewers
should block any change that diverges the two, and the
[contributing-to-docs](../contributing-to-docs.md) page documents
this convention for authors.

### Where do I propose a new FAQ entry?

Open a PR touching **both** `/FAQ.md` and
`/docs/reference/faq.md`. If you're only comfortable editing one,
that's fine — leave a note in the PR and a maintainer will mirror
the change.

### How current is this page?

The `updated:` field in the frontmatter is the source of truth; it
is bumped on every release and on material content edits.
