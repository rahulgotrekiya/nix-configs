#!/usr/bin/env bash

# Clipboard History Manager using rofi with auto-paste functionality and centered display
# Usage: clipboard-manager.sh [action]
#   c, -c, --copy    : Display clipboard history, copy selected item and paste it
#   d, -d, --delete  : Display clipboard history and delete selected item
#   w, -w, --wipe    : Clear the entire clipboard history database

# ------ Configuration ------
# Get script directory for relative paths
SCRIPT_DIR=$(dirname "$(realpath "$0")")

# Configuration paths
CONFIG_DIR="${HOME}/.config"
ROFI_CONFIG="${CONFIG_DIR}/rofi/clipboard.rasi"

# Rofi scaling
ROFI_SCALE=${ROFI_SCALE:-10}
ROFI_FONT_CONFIG="configuration {font: \"JetBrainsMono Nerd Font ${ROFI_SCALE}\";}"

# Border settings
HYPR_BORDER=${HYPR_BORDER:-1}
WINDOW_BORDER=$((HYPR_BORDER * 3 / 2))
ELEMENT_BORDER=$([ $HYPR_BORDER -eq 0 ] && echo "5" || echo $HYPR_BORDER)

# ------ Center Positioning for Rofi ------
# Force rofi to be centered on screen
CENTER_OVERRIDE="window {location: center; anchor: center; x-offset: 0; y-offset: 0;}"

# ------ Helper Functions ------
show_rofi_menu() {
    local placeholder="$1"
    local history_items=$(cliphist list)
    
    # Check if clipboard history is empty
    if [ -z "$history_items" ]; then
        # Show notification when clipboard is empty
        if command -v notify-send &> /dev/null; then
            notify-send "Clipboard Manager" "Clipboard history is empty. Please copy something first."
        else
            echo "Clipboard history is empty. Please copy something first." >&2
        fi
        return 1
    fi
    
    echo "$history_items" | rofi -dmenu \
        -theme-str "entry { placeholder: \"$placeholder\";}" \
        -theme-str "$ROFI_FONT_CONFIG" \
        -theme-str "$CENTER_OVERRIDE" \
        -config "$ROFI_CONFIG"
}

show_notification() {
    local title="$1"
    local message="$2"
    
    if command -v notify-send &> /dev/null; then
        notify-send "$title" "$message"
    else
        echo "$title: $message" >&2
    fi
}

# Function to get the active window ID
get_active_window() {
    if command -v hyprctl &> /dev/null; then
        # For Hyprland
        hyprctl activewindow -j | jq -r '.address'
    elif command -v xdotool &> /dev/null; then
        # For X11
        xdotool getactivewindow
    else
        echo ""
    fi
}

# Function to simulate paste in the active window
simulate_paste() {
    # Get active window
    local window_id=$(get_active_window)
    
    if [ -n "$window_id" ]; then
        if command -v wtype &> /dev/null; then
            # For Wayland
            wtype -M ctrl v -m ctrl
        elif command -v xdotool &> /dev/null; then
            # For X11
            xdotool key --clearmodifiers ctrl+v
        else
            show_notification "Clipboard Manager" "No tool found for simulating paste (wtype or xdotool required)"
            return 1
        fi
    else
        show_notification "Clipboard Manager" "No active window to paste into"
        return 1
    fi
}

show_help() {
    echo "Clipboard History Manager with Auto-Paste"
    echo "Usage: clipboard-manager.sh [action]"
    echo "  c, -c, --copy    : Display clipboard history, copy selected item and paste it"
    echo "  d, -d, --delete  : Display clipboard history and delete selected item"
    echo "  w, -w, --wipe    : Clear the entire clipboard history database"
    exit 1
}

# Check if required programs are installed
if ! command -v cliphist &> /dev/null; then
    show_notification "Clipboard Manager Error" "cliphist is not installed. Please install it first."
    echo "Error: cliphist is not installed. Please install it first." >&2
    exit 1
fi

if ! command -v wl-copy &> /dev/null; then
    show_notification "Clipboard Manager Error" "wl-clipboard is not installed. Please install it first."
    echo "Error: wl-clipboard is not installed. Please install it first." >&2
    exit 1
fi

# Check for paste simulator
if ! command -v wtype &> /dev/null && ! command -v xdotool &> /dev/null; then
    show_notification "Clipboard Manager Warning" "Neither wtype nor xdotool found. Auto-paste functionality will not work."
    echo "Warning: Neither wtype (Wayland) nor xdotool (X11) found. Auto-paste functionality will not work." >&2
fi

# ------ Initialize cliphist if needed ------
# Try to ensure cliphist daemon is running by checking if there's any clipboard history
if [ -z "$(cliphist list 2>/dev/null)" ]; then
    # If there's nothing in the history, try to add current clipboard content
    current_clipboard=$(wl-paste 2>/dev/null)
    if [ -n "$current_clipboard" ]; then
        echo "$current_clipboard" | wl-copy > /dev/null 2>&1
        # Wait a moment for cliphist to update
        sleep 0.5
    fi
fi

# ------ Main Script ------
case "$1" in
    c|-c|--copy)
        # Display history, copy selected item, and auto-paste
        selected=$(show_rofi_menu "Copy & Paste...")
        if [ -n "$selected" ]; then
            # Decode and copy to clipboard
            content=$(echo "$selected" | cliphist decode)
            echo "$content" | wl-copy
            
            # Small delay to ensure copy completes
            sleep 0.1
            
            # Attempt to automatically paste
            simulate_paste
        fi
        ;;
    d|-d|--delete)
        # Display history and delete selected item
        selected=$(show_rofi_menu "Delete...")
        if [ -n "$selected" ]; then
            echo "$selected" | cliphist delete
            show_notification "Clipboard Manager" "Item deleted from clipboard history"
        fi
        ;;
    w|-w|--wipe)
        # Check if there's any history before showing the confirmation dialog
        if [ -z "$(cliphist list 2>/dev/null)" ]; then
            show_notification "Clipboard Manager" "Clipboard history is already empty"
        else
            # Confirm and wipe the history
            if [ "$(echo -e "Yes\nNo" | rofi -dmenu \
                -theme-str "entry { placeholder: \"Clear Clipboard History?\";}" \
                -theme-str "$ROFI_FONT_CONFIG" \
                -theme-str "$CENTER_OVERRIDE" \
                -config "$ROFI_CONFIG")" == "Yes" ]; then
                cliphist wipe
                show_notification "Clipboard Manager" "Clipboard history cleared"
            fi
        fi
        ;;
    *)
        show_help
        ;;
esac

exit 0