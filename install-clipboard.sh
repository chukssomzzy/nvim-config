#!/bin/bash

# Clipboard Utilities Installation Script for Neovim
# This script helps install the necessary clipboard utilities for proper clipboard integration

echo "🔧 Neovim Clipboard Utilities Installation Script"
echo "=================================================="

# Detect the operating system and package manager
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    if command -v apt &> /dev/null; then
        # Debian/Ubuntu
        echo "📋 Installing clipboard utilities for Debian/Ubuntu..."
        if [ -n "$WAYLAND_DISPLAY" ] || [ "$XDG_SESSION_TYPE" = "wayland" ]; then
            echo "🌊 Wayland detected - installing wl-clipboard..."
            sudo apt update && sudo apt install -y wl-clipboard
        else
            echo "🎯 X11 detected - installing xclip and xsel..."
            sudo apt update && sudo apt install -y xclip xsel
        fi
    elif command -v yum &> /dev/null; then
        # RHEL/CentOS/Fedora (older)
        echo "📋 Installing clipboard utilities for RHEL/CentOS..."
        if [ -n "$WAYLAND_DISPLAY" ] || [ "$XDG_SESSION_TYPE" = "wayland" ]; then
            sudo yum install -y wl-clipboard
        else
            sudo yum install -y xclip xsel
        fi
    elif command -v dnf &> /dev/null; then
        # Fedora (newer)
        echo "📋 Installing clipboard utilities for Fedora..."
        if [ -n "$WAYLAND_DISPLAY" ] || [ "$XDG_SESSION_TYPE" = "wayland" ]; then
            sudo dnf install -y wl-clipboard
        else
            sudo dnf install -y xclip xsel
        fi
    elif command -v pacman &> /dev/null; then
        # Arch Linux
        echo "📋 Installing clipboard utilities for Arch Linux..."
        if [ -n "$WAYLAND_DISPLAY" ] || [ "$XDG_SESSION_TYPE" = "wayland" ]; then
            sudo pacman -S --noconfirm wl-clipboard
        else
            sudo pacman -S --noconfirm xclip xsel
        fi
    elif command -v pkg &> /dev/null && [ -n "$PREFIX" ]; then
        # Termux
        echo "📱 Termux detected - clipboard utilities are built-in!"
        echo "   termux-clipboard-get and termux-clipboard-set should work automatically."
    else
        echo "❌ Unsupported package manager. Please install manually:"
        echo "   - For Wayland: wl-clipboard"
        echo "   - For X11: xclip or xsel"
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    echo "🍎 macOS detected - pbcopy and pbpaste are built-in!"
    echo "   No additional installation needed."
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
    # Windows
    echo "🪟 Windows detected - clipboard utilities are built-in!"
    echo "   No additional installation needed."
else
    echo "❓ Unknown operating system. Please install clipboard utilities manually."
fi

echo ""
echo "✅ Installation complete! Test clipboard with:"
echo "   1. Copy some text: echo 'test' | [clipboard-tool]"
echo "   2. Paste in Neovim: use 'p' or '\"*p' / '\"+p'"
echo ""
echo "🔄 Restart Neovim to apply clipboard configuration changes."