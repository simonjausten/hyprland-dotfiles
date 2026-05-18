#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$HOME/dotfiles"

echo "==> Installing core packages (Hyprland stack)…"
sudo pacman -S --needed --noconfirm \
  hyprland hyprpaper hypridle hyprlock \
  waybar kitty fuzzel \
  brightnessctl light \
  grim slurp grimblast \
  wl-clipboard

echo "==> Creating config directories…"
mkdir -p \
  "$HOME/.config/hypr" \
  "$HOME/.config/hypr/scripts" \
  "$HOME/.config/waybar" \
  "$HOME/.config/kitty" \
  "$HOME/.config/fuzzel" \
  "$HOME/.config/systemd/user" \
  "$HOME/.local/state/hypridle"

echo "==> Deploying Hyprland configs…"
cp -f "$REPO_DIR/hypr/hyprland.conf"      "$HOME/.config/hypr/hyprland.conf"
cp -f "$REPO_DIR/hypr/monitors.conf"     "$HOME/.config/hypr/monitors.conf"
cp -f "$REPO_DIR/hypr/input.conf"        "$HOME/.config/hypr/input.conf"
cp -f "$REPO_DIR/hypr/binds.conf"        "$HOME/.config/hypr/binds.conf"
cp -f "$REPO_DIR/hypr/windowrules.conf"  "$HOME/.config/hypr/windowrules.conf"
cp -f "$REPO_DIR/hypr/animations.conf"   "$HOME/.config/hypr/animations.conf"

echo "==> Deploying Hypridle config + scripts…"
cp -f "$REPO_DIR/hypr/hypridle.conf"     "$HOME/.config/hypr/hypridle.conf"
cp -f "$REPO_DIR/hypr/scripts/"*.sh      "$HOME/.config/hypr/scripts/"
chmod +x "$HOME/.config/hypr/scripts/"*.sh

echo "==> Deploying systemd user services…"
cp -f "$REPO_DIR/systemd/hypridle.service" "$HOME/.config/systemd/user/hypridle.service"

echo "==> (Optional) Deploying Waybar, Kitty, Fuzzel configs if present…"
[ -f "$REPO_DIR/waybar/config.jsonc" ] && cp -f "$REPO_DIR/waybar/config.jsonc" "$HOME/.config/waybar/config.jsonc"
[ -f "$REPO_DIR/waybar/style.css" ]    && cp -f "$REPO_DIR/waybar/style.css"    "$HOME/.config/waybar/style.css"
[ -f "$REPO_DIR/kitty/kitty.conf" ]    && cp -f "$REPO_DIR/kitty/kitty.conf"    "$HOME/.config/kitty/kitty.conf"
[ -f "$REPO_DIR/fuzzel/fuzzel.ini" ]   && cp -f "$REPO_DIR/fuzzel/fuzzel.ini"   "$HOME/.config/fuzzel/fuzzel.ini"

echo "==> Enabling user services…"
systemctl --user daemon-reload
systemctl --user enable --now hypridle.service

echo "==> Done."
echo "Log out to a TTY and start Hyprland with:  Hyprland"
