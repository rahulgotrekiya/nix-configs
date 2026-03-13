#!/usr/bin/env sh

# Check for required commands
check_command() {
    if ! command -v "$1" &> /dev/null; then
        notify-send "Screenshot Error" "$1 is not installed. Please install it to use this feature."
        return 1
    fi
    return 0
}

# Shader management functions (only used if hyprshade is available)
restore_shader() {
    if [ -n "$shader" ] && check_command "hyprshade"; then
        hyprshade on "$shader"
    fi
}

save_shader() {
    if check_command "hyprshade"; then
        shader=$(hyprshade current)
        hyprshade off
        trap restore_shader EXIT
    fi
}

# Set up directories
if [ -z "$XDG_PICTURES_DIR" ]; then
    XDG_PICTURES_DIR="$HOME/Pictures"
fi

# Define configuration directories
save_dir="${2:-$XDG_PICTURES_DIR/Screenshots}"
save_file=$(date +'%y%m%d_%Hh%Mm%Ss_screenshot.png')
temp_screenshot="/tmp/screenshot.png"

mkdir -p $save_dir

# Check for swappy and set up its config if available
if check_command "swappy"; then
    swpy_dir="$HOME/.config/swappy"
    mkdir -p $swpy_dir
    echo -e "[Default]\nsave_dir=$save_dir\nsave_filename_format=$save_file" > $swpy_dir/config
fi

# Screenshot functions
take_screenshot_full() {
    if check_command "grimblast"; then
        save_shader
        grimblast copysave screen $temp_screenshot
        if [ -f "$temp_screenshot" ]; then
            if check_command "swappy"; then
                swappy -f $temp_screenshot
            else
                mv $temp_screenshot "${save_dir}/${save_file}"
                wl-copy < "${save_dir}/${save_file}"
            fi
        fi
    fi
}

take_screenshot_area() {
    if check_command "grimblast"; then
        save_shader
        grimblast copysave area $temp_screenshot
        if [ -f "$temp_screenshot" ]; then
            if check_command "swappy"; then
                swappy -f $temp_screenshot
            else
                mv $temp_screenshot "${save_dir}/${save_file}"
                wl-copy < "${save_dir}/${save_file}"
            fi
        fi
    fi
}

take_screenshot_frozen() {
    if check_command "grimblast"; then
        save_shader
        grimblast --freeze copysave area $temp_screenshot
        if [ -f "$temp_screenshot" ]; then
            if check_command "swappy"; then
                swappy -f $temp_screenshot
            else
                mv $temp_screenshot "${save_dir}/${save_file}"
                wl-copy < "${save_dir}/${save_file}"
            fi
        fi
    fi
}

take_screenshot_monitor() {
    if check_command "grimblast"; then
        save_shader
        grimblast copysave output $temp_screenshot
        if [ -f "$temp_screenshot" ]; then
            if check_command "swappy"; then
                swappy -f $temp_screenshot
            else
                mv $temp_screenshot "${save_dir}/${save_file}"
                wl-copy < "${save_dir}/${save_file}"
            fi
        fi
    fi
}

view_screenshots() {
    if ! check_command "rofi"; then
        notify-send "Error" "rofi is not installed"
        return 1
    fi
    
    # Create formatted list of screenshots with dates
    screenshots_list=""
    while IFS= read -r file; do
        filename=$(basename "$file")
        date_str=$(date -r "$file" "+%Y-%m-%d %H:%M:%S")
        size=$(du -h "$file" | cut -f1)
        screenshots_list="${screenshots_list}${date_str} (${size}) - ${filename}\n"
    done < <(find "$save_dir" -type f -name "*.png" | sort -r)
    
    if [ -z "$screenshots_list" ]; then
        notify-send "Screenshots" "No screenshots found"
        return
    fi
    
    # Show rofi menu with screenshots
    selected=$(echo -e "$screenshots_list" | rofi -dmenu -i -p "🖼️ Select Screenshot" -theme-str 'window {width: 65%;}')
    
    if [ -n "$selected" ]; then
        # Extract filename from selection
        filename=$(echo "$selected" | sed 's/.*- \(.*\)$/\1/')
        file_path="${save_dir}/${filename}"
        
        if [ -f "$file_path" ]; then
            action=$(echo -e "🔍 Open\n📋 Copy to clipboard\n🗑️ Delete" | rofi -dmenu -i -p "Action" -theme-str 'window {width: 20%;}')
            
            case "$action" in
                *"Open"*)
                    if check_command "xdg-open"; then
                        xdg-open "$file_path"
                    fi ;;
                *"Copy"*)
                    if check_command "wl-copy"; then
                        wl-copy < "$file_path"
                        notify-send "Screenshot" "Copied to clipboard" -i "$file_path"
                    fi ;;
                *"Delete"*)
                    rm "$file_path"
                    notify-send "Screenshot" "Deleted successfully" ;;
            esac
        fi
    fi
}

# Handle direct flag execution or show rofi menu
if [ -n "$1" ]; then
    # Flag provided - execute command directly
    case $1 in
        p) # print all outputs
            take_screenshot_full ;;
        s) # drag to manually snip an area
            take_screenshot_area ;;
        sf) # frozen screen
            take_screenshot_frozen ;;
        m) # print focused monitor
            take_screenshot_monitor ;;
        v) # view screenshots
            view_screenshots ;;
        *)
            echo "Invalid option: $1"
            echo "Valid options: p (full), s (area), sf (frozen area), m (monitor), v (view)"
            exit 1 ;;
    esac
else
    # No flag - show rofi menu
    if check_command "rofi"; then
        # Menu option using rofi with emoji icons
        option=$(echo -e "📷 Full Screenshot\n🖱️ Area Screenshot\n❄️ Area Frozen\n🖥️ Active Monitor\n🖼️ View Screenshots" | rofi -dmenu -i -p "Screenshot" -theme-str 'window {width: 20%;}')

        case "$option" in
            *"Full"*)
                take_screenshot_full ;;
            *"Area Screenshot"*)
                take_screenshot_area ;;
            *"Area Frozen"*)
                take_screenshot_frozen ;;
            *"Active Monitor"*)
                take_screenshot_monitor ;;
            *"View Screenshots"*)
                view_screenshots ;;
            *)
                exit 0 ;;
        esac
    else
        # Rofi not available
        notify-send "Screenshot Error" "rofi is not installed. Please install it or use command line flags."
        exit 1
    fi
fi

# Clean up temp file
rm -f "$temp_screenshot"

# Notify user if screenshot was saved
if [ -f "${save_dir}/${save_file}" ]; then
    if command -v notify-send &> /dev/null; then
        notify-send -i "${save_dir}/${save_file}" "Screenshot saved in ${save_dir}"
    fi
fi