#!/bin/bash
# ===============================================================
# Miku Dating Sim GRUB Theme Installer
# Modified from: Matrix Morpheus GRUB Theme
#
# Works on Debian/Ubuntu/Mint/Pop/Arch/CachyOS/Fedora/openSUSE
#   - auto-detects grub-mkconfig, grub2-mkconfig or update-grub
#   - auto-detects /boot/grub vs /boot/grub2 layout
#   - auto-aliases the Linux art to whatever your distro's GRUB
#     menu-entry classes are (distro-aware, no hardcoded list)
#   - runnable from anywhere (script dir is resolved automatically)
#   - backs up /etc/default/grub before modifying it
# ===============================================================

THEME_NAME="Miku-Dating-Sim"
GRUB_CFG="/etc/default/grub"

# Run from anywhere: resolve this script's real location
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEME_SRC="$SCRIPT_DIR/$THEME_NAME"

# ---------------- colors (degrade gracefully when piped) ----------------
if [ -t 1 ] && command -v tput >/dev/null 2>&1; then
    GREEN=$(tput setaf 2); RED=$(tput setaf 1); YELLOW=$(tput setaf 3)
    CYAN=$(tput setaf 6); BOLD=$(tput bold); RESET=$(tput sgr0)
else
    GREEN=""; RED=""; YELLOW=""; CYAN=""; BOLD=""; RESET=""
fi

ok()   { echo "  ${GREEN}[ OK ]${RESET}  $*"; }
warn() { echo "  ${YELLOW}[ !! ]${RESET} $*"; }
fail() { echo "  ${RED}[FAIL]${RESET} $*"; }
die()  { echo ""; fail "$*"; echo "  ${RED}Installation aborted.${RESET}"; exit 1; }

# ---------------- banner ----------------
banner() {
    echo ""
    echo "${GREEN} __  __ _        _     __  __       _        ___ ____  ${RESET}"
    echo "${GREEN}|  \/  (_)_ __  (_)_  |  \/  | __ _(_)_ __  |_ _|  _ \ ${RESET}"
    echo "${GREEN}| |\/| | | '_ \ | \ \ | |\/| |/ _\` | | '_ \  | || | | |${RESET}"
    echo "${GREEN}| |  | | | | | | | |\ \| |  | | (_| | | | | | | || |_| |${RESET}"
    echo "${GREEN}|_|  |_|_|_| |_| |_| \_\_|  |_|\__,_|_|_| |_|___|____/ ${RESET}"
    echo "${CYAN}        Miku Dating Sim GRUB Theme Installer${RESET}"
    echo ""
}

distro_greeting() {
    local distro=""
    if [ -f /etc/os-release ]; then
        distro="$(grep -E '^PRETTY_NAME=' /etc/os-release 2>/dev/null | head -1 | \
                  sed 's/^PRETTY_NAME=//; s/^"//; s/"$//')"
    fi
    [ -z "$distro" ] && distro="a GNU/Linux machine"
    echo "${CYAN}  Detected: ${BOLD}${distro}${RESET} -- let's get you themed~"
    echo ""
}

# ---------------- root check (portable) ----------------
require_root() {
    if [ "$(id -u)" -ne 0 ]; then
        fail "This script must be run as root."
        echo "  Run it with:  sudo $0"
        exit 1
    fi
}

# ---------------- detect GRUB config tool ----------------
# Order of preference: update-grub (Debian-family wrapper that knows the
# right output path) -> grub2-mkconfig (Fedora/openSUSE) -> grub-mkconfig.
find_grub_tool() {
    local tool dir
    for tool in update-grub grub2-mkconfig grub-mkconfig; do
        if command -v "$tool" >/dev/null 2>&1; then
            command -v "$tool"
            return 0
        fi
        # root's PATH often omits sbin dirs; check them explicitly
        for dir in /usr/sbin /sbin /usr/local/sbin; do
            if [ -x "$dir/$tool" ]; then
                echo "$dir/$tool"
                return 0
            fi
        done
    done
    return 1
}

# ---------------- detect grub.cfg + theme dir layout ----------------
detect_layout() {
    if [ -f /boot/grub2/grub.cfg ]; then
        GRUB_FILE="/boot/grub2/grub.cfg"
        THEME_DIR="/boot/grub2/themes"
    else
        GRUB_FILE="/boot/grub/grub.cfg"
        THEME_DIR="/boot/grub/themes"
    fi
}

confirm_install() {
    local ans
    echo "${YELLOW}  This will:${RESET}"
    echo "    - install the theme to      ${BOLD}$THEME_DIR/$THEME_NAME${RESET}"
    if [ -f "$GRUB_CFG" ]; then echo "    - back up and modify         ${BOLD}$GRUB_CFG${RESET}"; fi
    echo "    - regenerate                 ${BOLD}$GRUB_FILE${RESET}"
    # Skip the prompt when stdin isn't interactive (piped/automated runs)
    if [ ! -t 0 ]; then
        warn "Non-interactive shell -- continuing automatically"
        return 0
    fi
    read -r -p "  Continue? [Y/n] " ans
    case "$ans" in
        n|N|no|No|NO) die "Cancelled by user." ;;
    esac
}

# ================================================================
# main
# ================================================================
set -u

banner
require_root

detect_layout
THEME_DEST="$THEME_DIR/$THEME_NAME"
distro_greeting

# Fail fast before asking the user to confirm anything
if [ ! -f "$THEME_SRC/theme.txt" ]; then
    die "Could not find theme files next to this script ('$THEME_SRC')."
fi

confirm_install

# ---- 1. install theme files (clean reinstall) ----
echo "  Installing theme..."
if [ -d "$THEME_DEST" ]; then
    rm -rf "$THEME_DEST"
    ok "Removed previous install"
fi
mkdir -p "$THEME_DIR" || die "Failed to create $THEME_DIR."
cp -r "$THEME_SRC" "$THEME_DIR/" || die "Failed to copy theme files."
for f in theme.txt font.pf2 icons/arch.png icons/windows.png; do
    [ -f "$THEME_DEST/$f" ] || die "Missing file after copy: $f"
done
ok "Installed to $THEME_DEST"

# ---- 1b. icon aliases for the universal Linux entry classes ----
# GRUB resolves a menu entry's icon by filename: it looks for
# icons/<class>.png matching the entry's --class tags. A fresh Linux
# entry is classed e.g. 'cachyos/gnu-linux/gnu/os' -- never literally
# 'arch' -- so alias arch.png to the classes that every Linux distro
# shares. Distro-specific classes are detected later from the
# generated grub.cfg (step 3b). Hardlinks use zero extra disk space;
# cp is the fallback for FAT filesystems.
ICON_SRC="$THEME_DEST/icons"
for cls in gnu-linux gnu os linux; do
    [ -e "$ICON_SRC/$cls.png" ] && continue
    if ln "$ICON_SRC/arch.png" "$ICON_SRC/$cls.png" 2>/dev/null || \
       cp -p "$ICON_SRC/arch.png" "$ICON_SRC/$cls.png"; then
        :
    else
        warn "Could not create icon alias for class '$cls'"
    fi
done
ok "Created aliases for universal Linux classes"

# ---- 2. backup + update /etc/default/grub ----
if [ -f "$GRUB_CFG" ]; then
    BAK="${GRUB_CFG}.bak.$(date +%Y%m%d%H%M%S)"
    cp -a "$GRUB_CFG" "$BAK" || die "Failed to back up $GRUB_CFG -- aborting to avoid editing it unprotected."
    ok "Backed up $GRUB_CFG -> $BAK"
else
    warn "$GRUB_CFG not found -- creating a new one"
    : > "$GRUB_CFG"
fi

THEME_LINE="GRUB_THEME=\"${THEME_DEST}/theme.txt\""
if grep -q '^GRUB_THEME=' "$GRUB_CFG"; then
    if grep -Fq "GRUB_THEME=\"${THEME_DEST}/theme.txt\"" "$GRUB_CFG"; then
        ok "GRUB_THEME already points at Miku Dating Sim"
    else
        sed -i '/^GRUB_THEME=/d' "$GRUB_CFG" || die "Failed to update $GRUB_CFG."
        printf '\n%s\n' "$THEME_LINE" >> "$GRUB_CFG" || die "Failed to write $GRUB_CFG."
        ok "Updated GRUB_THEME -> Miku Dating Sim"
    fi
else
    printf '\n%s\n' "$THEME_LINE" >> "$GRUB_CFG" || die "Failed to write $GRUB_CFG."
    ok "Added GRUB_THEME to $GRUB_CFG"
fi

# ---- 3. regenerate grub.cfg ----
GRUB_TOOL="$(find_grub_tool || true)"
[ -n "$GRUB_TOOL" ] || die "No GRUB config tool found (tried update-grub, grub2-mkconfig, grub-mkconfig)."

echo "  Rebuilding GRUB with ${BOLD}$(basename "$GRUB_TOOL")${RESET}..."
case "$(basename "$GRUB_TOOL")" in
    update-grub)
        "$GRUB_TOOL" || die "$(basename "$GRUB_TOOL") failed."
        ;;
    *)
        "$GRUB_TOOL" -o "$GRUB_FILE" || die "$(basename "$GRUB_TOOL") failed."
        ;;
esac
ok "GRUB configuration regenerated"

# ---- 3b. distro-aware icon aliases ----
# Read the freshly generated grub.cfg and alias arch.png to every
# menu entry class that does not have its own icon yet. This covers
# ANY distro -- whatever the running OS or os-prober entries are
# classed as -- with no hardcoded distro list to maintain.
for cls in $(grep -oE -- '--class [a-zA-Z0-9_-]+' "$GRUB_FILE" 2>/dev/null | awk '{print $2}' | sort -u); do
    # windows keeps its dedicated art; skip it and miscellaneous classes
    case "$cls" in
        windows|uefi-firmware|firmware|efi|poweroff|reboot|halt) continue ;;
    esac
    [ -e "$ICON_SRC/$cls.png" ] && continue
    if ln "$ICON_SRC/arch.png" "$ICON_SRC/$cls.png" 2>/dev/null || \
       cp -p "$ICON_SRC/arch.png" "$ICON_SRC/$cls.png"; then
        ok "Aliased arch.png -> icons/$cls.png"
    else
        warn "Could not create icon alias for class '$cls'"
    fi
done

# ---- 4. verify ----
if [ -f "$GRUB_FILE" ]; then
    if grep -Fq "$THEME_NAME/theme.txt" "$GRUB_FILE"; then
        ok "Theme reference found in $GRUB_FILE"
    else
        warn "Theme reference not found in $GRUB_FILE - check manually"
    fi
else
    warn "Could not find $GRUB_FILE to verify"
fi

echo ""
echo "${GREEN}  ==================================================${RESET}"
echo "${GREEN}   Installation complete!${RESET}"
echo "    Theme   : ${BOLD}$THEME_DEST${RESET}"
echo "    GRUB cfg: ${BOLD}$GRUB_CFG${RESET}"
[ -n "${BAK:-}" ] && echo "    Backup  : ${BOLD}$BAK${RESET}"
echo ""
echo "${CYAN}  Reboot to see your new Miku Dating Sim GRUB theme.${RESET}"
echo "${GREEN}  ==================================================${RESET}"
echo ""