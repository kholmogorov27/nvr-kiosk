#!/bin/bash
set -euo pipefail

# --- Configuration ---
read -rp "Enter user name: " KIOSK_USER
if [ -z "$KIOSK_USER" ]; then
  echo User name is not defined
  exit 1
fi
read -rsp "Enter user password: " KIOSK_PASSWORD
if [ -z "$KIOSK_PASSWORD" ]; then
  echo User password is not defined
  exit 1
fi
read -rp "Enter NVR URL: " NVR_URL
if [ -z "$NVR_URL" ]; then
  echo NVR URL is not defined
  exit 1
fi

echo "[+] Creating $KIOSK_USER user..."
if ! id "$KIOSK_USER" > /dev/null 2>&1; then
  sudo useradd -m -s /bin/bash "$KIOSK_USER"
  sudo usermod --password $(echo "$KIOSK_PASSWORD" | openssl passwd -1 -stdin) "$KIOSK_USER"
else
  echo "User $KIOSK_USER already exists"
fi

echo "[+] Installing packages..."
sudo rm -fv /etc/apt/sources.list.d/thorium.list
sudo wget --no-hsts -P /etc/apt/sources.list.d/ http://dl.thorium.rocks/debian/dists/stable/thorium.list

sudo apt update
sudo apt install -y --no-install-recommends \
  cage \
  thorium-browser || true

echo "[+] Configuring kiosk..."
sudo tee -a "/home/$KIOSK_USER/.bash_profile" > /dev/null <<EOF
# Auto-start kiosk on tty1
if [ -z "\$WAYLAND_DISPLAY" ] && [ "\$(tty)" = "/dev/tty1" ]; then
    clear
    exec cage -m last thorium-browser -- --kiosk $NVR_URL --incognito --no-first-run >/dev/null 2>&1
fi
EOF

echo "[+] Configuring permissions..."
sudo chown $KIOSK_USER:$KIOSK_USER /home/$KIOSK_USER/.bash_profile
sudo chmod 644 /home/$KIOSK_USER/.bash_profile

echo
echo "[+] Installation complete!"
