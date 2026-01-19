# Wayland Kiosk Browser Installer

This installer sets up a **minimal Wayland-based kiosk environment** that automatically launches **Thorium Browser** in fullscreen kiosk mode using **Cage**, a lightweight Wayland compositor.

## Features

- Lightweight Wayland compositor (Cage)
- Thorium Browser in true kiosk mode
- Automatic launch on user login
- Minimal package installation (no recommends)

## How It Works

1. Creates a dedicated kiosk user (`nvr`) with a predefined password.
2. Adds the Thorium APT repository.
3. Installs required packages:
   - `cage`
   - `thorium-browser`
4. Appends an autorun command to the kiosk user’s `.bash_profile`.
5. On login, the kiosk user automatically starts:
   - Cage (Wayland compositor)
   - Thorium Browser in fullscreen kiosk mode
6. The browser launches with:
   - Kiosk mode
   - Incognito mode
   - No first-run dialogs
   - Predefined NVR URL

## Requirements

- Debian / Ubuntu (or compatible)
- `sudo` access
- Internet access during installation
- Wayland-capable system (no X11 required)

## Usage

- Log in as the kiosk user to use NVR
- To exit: <kbd>Ctrl</kbd> + <kbd>W</kbd>