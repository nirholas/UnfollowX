#!/usr/bin/env bash
# PAI Auto-Flasher — Download and flash PAI ISO to a USB drive
# Usage: curl -fsSL https://raw.githubusercontent.com/nirholas/pai/main/scripts/flash.sh | sudo bash
#        curl -fsSL https://pai.direct/flash.sh | sudo bash -s -- --local-iso ~/Downloads/pai.iso
set -euo pipefail

GITHUB_API="https://api.github.com/repos/nirholas/pai/releases/latest"
RELEASE_URL="https://get.pai.direct/pai-amd64.iso"
ISO_NAME="pai.iso"
LOCAL_ISO=""
EXPECTED_SHA256=""
SKIP_VERIFY=false
FORCE=false

# --- Parse arguments ---
while [[ $# -gt 0 ]]; do
    case "$1" in
        --local-iso)
            LOCAL_ISO="$2"
            shift 2
            ;;
        --local-iso=*)
            LOCAL_ISO="${1#*=}"
            shift
            ;;
        --sha256)
            EXPECTED_SHA256="$2"
            shift 2
            ;;
        --sha256=*)
            EXPECTED_SHA256="${1#*=}"
            shift
            ;;
        --skip-verify)
            SKIP_VERIFY=true
            shift
            ;;
        --force)
            FORCE=true
            shift
            ;;
        -h|--help)
            echo "Usage: flash.sh [--local-iso PATH] [--sha256 HEX] [--skip-verify --force]"
            echo ""
            echo "Options:"
            echo "  --local-iso PATH   Use a pre-downloaded ISO instead of downloading."
            echo "                     Useful with the browser installer at pai.direct/flash-web."
            echo "  --sha256 HEX       Expected SHA256 of the ISO. If unset, the script"
            echo "                     fetches SHA256SUMS from the latest GitHub release."
            echo "  --skip-verify      Skip SHA256 verification. Dangerous. Requires --force."
            echo "  --force            Acknowledge dangerous operations (e.g. --skip-verify)."
            exit 0
            ;;
        *)
            echo "Unknown option: $1" >&2
            exit 1
            ;;
    esac
done

if [[ "$SKIP_VERIFY" == true && "$FORCE" != true ]]; then
    echo "Error: --skip-verify requires --force. Verification protects you from corrupt or tampered downloads." >&2
    exit 1
fi

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

die() { echo -e "${RED}Error: $1${NC}" >&2; exit 1; }
info() { echo -e "${CYAN}$1${NC}"; }
warn() { echo -e "${YELLOW}$1${NC}"; }
success() { echo -e "${GREEN}$1${NC}"; }

# --- Root check ---
if [[ $EUID -ne 0 ]]; then
    die "This script must be run as root. Use: sudo bash $0"
fi

echo -e "${BOLD}"
echo "╔═══════════════════════════════════════╗"
echo "║       PAI — PAI Flasher         ║"
echo "║   Private AI on a bootable USB drive  ║"
echo "╚═══════════════════════════════════════╝"
echo -e "${NC}"

# --- Detect OS ---
OS="$(uname -s)"
case "$OS" in
    Linux)  info "Detected OS: Linux" ;;
    Darwin) info "Detected OS: macOS" ;;
    *)      die "Unsupported OS: $OS. Use Linux or macOS." ;;
esac

# --- List USB drives ---
info "\nScanning for USB drives...\n"

declare -a DEVICES=()
declare -a DEVICE_INFO=()

if [[ "$OS" == "Linux" ]]; then
    while IFS= read -r line; do
        dev=$(echo "$line" | awk '{print $1}')
        size=$(echo "$line" | awk '{print $2}')
        model=$(echo "$line" | awk '{$1=$2=$3=""; print $0}' | xargs)
        if [[ -n "$dev" ]]; then
            DEVICES+=("/dev/$dev")
            DEVICE_INFO+=("$dev  ${size}  ${model}")
        fi
    done < <(lsblk -d -n -o NAME,SIZE,TRAN,MODEL | grep 'usb' | awk '{print $1, $2, $4, $5, $6, $7}')
elif [[ "$OS" == "Darwin" ]]; then
    while IFS= read -r line; do
        dev=$(echo "$line" | awk '{print $1}')
        if diskutil info "$dev" 2>/dev/null | grep -q "Removable Media.*Yes"; then
            size=$(diskutil info "$dev" | grep "Disk Size" | awk -F'(' '{print $1}' | awk '{print $3, $4}')
            model=$(diskutil info "$dev" | grep "Device / Media Name" | cut -d: -f2 | xargs)
            DEVICES+=("$dev")
            DEVICE_INFO+=("$dev  ${size}  ${model}")
        fi
    done < <(diskutil list | grep '^/dev/disk' | awk '{print $1}')
fi

if [[ ${#DEVICES[@]} -eq 0 ]]; then
    die "No USB drives found. Plug in a USB drive and try again."
fi

echo -e "${BOLD}Found USB drives:${NC}\n"
for i in "${!DEVICE_INFO[@]}"; do
    echo -e "  ${BOLD}[$((i+1))]${NC} ${DEVICE_INFO[$i]}"
done

# --- Select drive ---
echo ""
read -rp "Select drive number to flash [1-${#DEVICES[@]}]: " choice

if ! [[ "$choice" =~ ^[0-9]+$ ]] || [[ "$choice" -lt 1 ]] || [[ "$choice" -gt ${#DEVICES[@]} ]]; then
    die "Invalid selection: $choice"
fi

TARGET="${DEVICES[$((choice-1))]}"
TARGET_INFO="${DEVICE_INFO[$((choice-1))]}"

# --- macOS: use raw disk for speed ---
if [[ "$OS" == "Darwin" ]]; then
    RAW_TARGET="${TARGET/disk/rdisk}"
else
    RAW_TARGET="$TARGET"
fi

# --- Confirm ---
echo ""
warn "╔══════════════════════════════════════════════════╗"
warn "║  WARNING: ALL DATA ON THIS DEVICE WILL BE LOST  ║"
warn "╚══════════════════════════════════════════════════╝"
echo ""
echo -e "  Target: ${RED}${BOLD}${TARGET_INFO}${NC}"
echo ""
read -rp "Type 'YES' to confirm: " confirm

if [[ "$confirm" != "YES" ]]; then
    echo "Aborted."
    exit 0
fi

# --- Unmount ---
info "\nUnmounting $TARGET..."
if [[ "$OS" == "Linux" ]]; then
    umount "${TARGET}"* 2>/dev/null || true
elif [[ "$OS" == "Darwin" ]]; then
    diskutil unmountDisk "$TARGET" 2>/dev/null || true
fi

# --- Helpers ---
sha256_of() {
    local f="$1"
    if command -v sha256sum &>/dev/null; then
        sha256sum "$f" | awk '{print $1}'
    elif command -v shasum &>/dev/null; then
        shasum -a 256 "$f" | awk '{print $1}'
    else
        die "Neither sha256sum nor shasum found — cannot verify ISO."
    fi
}

verify_sha256() {
    local file="$1" expected="$2"
    info "Verifying SHA256..."
    local actual
    actual=$(sha256_of "$file" | tr 'A-Z' 'a-z')
    expected=$(echo "$expected" | tr 'A-Z' 'a-z' | tr -d '[:space:]')
    if [[ "$actual" == "$expected" ]]; then
        success "SHA256 OK: $actual"
        return 0
    fi
    echo "Expected: $expected" >&2
    echo "Actual:   $actual"   >&2
    return 1
}

# Check that the release host is reachable before attempting a multi-GB
# download, so a dead host fails with an actionable message instead of a
# cryptic curl/wget error. Tries a HEAD request first, then a 1-byte
# ranged GET for hosts that reject HEAD.
check_release_host() {
    if command -v curl &>/dev/null; then
        curl -fsIL --max-time 20 -o /dev/null "$RELEASE_URL" 2>/dev/null && return 0
        curl -fsL --max-time 20 -r 0-0 -o /dev/null "$RELEASE_URL" 2>/dev/null && return 0
    elif command -v wget &>/dev/null; then
        wget -q --spider --timeout=20 "$RELEASE_URL" 2>/dev/null && return 0
    fi
    return 1
}

# Fetch expected SHA256 from the latest GitHub release's SHA256SUMS asset
# when the caller did not pass --sha256. Writes the hash to stdout.
fetch_expected_sha256() {
    local iso_name="$1"
    command -v curl &>/dev/null || return 1
    local release_json
    release_json=$(curl -fsSL "$GITHUB_API" 2>/dev/null) || return 1
    local sums_url
    if command -v jq &>/dev/null; then
        sums_url=$(echo "$release_json" | jq -r '[.assets[] | select(.name == "SHA256SUMS")] | first | .browser_download_url // empty')
    else
        sums_url=$(echo "$release_json" | grep -o '"browser_download_url"[[:space:]]*:[[:space:]]*"[^"]*SHA256SUMS"' | head -1 | sed 's/.*"browser_download_url"[[:space:]]*:[[:space:]]*"//;s/"$//')
    fi
    [[ -n "$sums_url" ]] || return 1
    local sums
    sums=$(curl -fsSL "$sums_url" 2>/dev/null) || return 1
    # Match by filename (strip any leading '*' digest-type marker)
    local line
    line=$(echo "$sums" | awk -v f="$iso_name" '{
        name = $2; sub(/^\*/, "", name);
        if (name == f) { print $1; exit }
    }')
    [[ -n "$line" ]] || return 1
    echo "$line"
}

# --- Source selection: pre-downloaded vs. download+verify ---
TMP_ISO=""
cleanup_tmp_iso() { [[ -n "$TMP_ISO" && -f "$TMP_ISO" ]] && rm -f "$TMP_ISO"; }
trap cleanup_tmp_iso EXIT

if [[ -n "$LOCAL_ISO" ]]; then
    if [[ ! -f "$LOCAL_ISO" ]]; then
        die "Local ISO not found: $LOCAL_ISO"
    fi
    SOURCE_ISO="$LOCAL_ISO"
    if [[ "$SKIP_VERIFY" == true ]]; then
        warn "Skipping SHA256 verification (--skip-verify --force)."
    elif [[ -n "$EXPECTED_SHA256" ]]; then
        verify_sha256 "$SOURCE_ISO" "$EXPECTED_SHA256" || die "SHA256 mismatch on local ISO."
    else
        warn "No --sha256 provided for --local-iso; skipping verification."
        warn "Re-run with --sha256 HEX to verify integrity of the local file."
    fi
else
    info "\nDownloading PAI ISO..."
    info "Source: $RELEASE_URL"

    if ! check_release_host; then
        echo "" >&2
        warn "Cannot reach the release host: $RELEASE_URL"
        warn "Hosted downloads may be temporarily offline (the pai.direct site is moving hosts)."
        echo "" >&2
        echo "You can still flash PAI:" >&2
        echo "  1. Build the ISO from source (see 'Build from Source' in the README):" >&2
        echo "       git clone https://github.com/nirholas/pai.git && cd pai" >&2
        echo "       docker build -f Dockerfile.build -t pai-builder ." >&2
        echo "       docker run --privileged --rm -v \"\$PWD/output:/output\" pai-builder" >&2
        echo "  2. Re-run this script pointing at the built (or otherwise obtained) ISO:" >&2
        echo "       sudo bash flash.sh --local-iso output/live-image-amd64.hybrid.iso" >&2
        echo "" >&2
        die "Release host unreachable. Use --local-iso with a locally built ISO, or retry once hosting is restored."
    fi

    TMP_ISO=$(mktemp -t pai-iso.XXXXXX) || die "Failed to create temp file"
    if command -v curl &>/dev/null; then
        curl -L --fail --progress-bar -o "$TMP_ISO" "$RELEASE_URL" \
            || die "Download failed. Check network and retry."
    elif command -v wget &>/dev/null; then
        wget -q --show-progress -O "$TMP_ISO" "$RELEASE_URL" \
            || die "Download failed. Check network and retry."
    else
        die "Neither curl nor wget found. Install one and try again."
    fi

    if [[ "$SKIP_VERIFY" == true ]]; then
        warn "Skipping SHA256 verification (--skip-verify --force)."
    else
        if [[ -z "$EXPECTED_SHA256" ]]; then
            info "Fetching SHA256SUMS from latest GitHub release..."
            EXPECTED_SHA256=$(fetch_expected_sha256 "$ISO_NAME" || true)
        fi
        if [[ -z "$EXPECTED_SHA256" ]]; then
            rm -f "$TMP_ISO"
            die "Could not determine expected SHA256. Pass --sha256 HEX or --skip-verify --force."
        fi
        if ! verify_sha256 "$TMP_ISO" "$EXPECTED_SHA256"; then
            rm -f "$TMP_ISO"
            die "SHA256 mismatch — download corrupt or tampered. Aborting."
        fi
    fi

    SOURCE_ISO="$TMP_ISO"
fi

info "\nFlashing to $TARGET..."
info "Source: $SOURCE_ISO\n"
dd if="$SOURCE_ISO" of="$RAW_TARGET" bs=4M status=progress 2>&1

# --- Sync ---
info "\nSyncing..."
sync

# --- Done ---
echo ""
success "╔═══════════════════════════════════════╗"
success "║         PAI flashed successfully!     ║"
success "╚═══════════════════════════════════════╝"
echo ""
info "Next steps:"
echo "  1. Remove the USB drive"
echo "  2. Plug it into the target machine"
echo "  3. Boot from USB (usually F12/F2/DEL at startup)"
echo "  4. PAI will auto-login → Sway → Firefox → Chat UI"
echo ""
