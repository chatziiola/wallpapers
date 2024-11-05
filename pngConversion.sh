#!/bin/zsh

# Define the target directory (use the current directory if not provided)
TARGET_DIR=${1:-.}

# Define the maximum 4K resolution
MAX_WIDTH=3840
MAX_HEIGHT=2160

# Check if ImageMagick is installed
if ! command -v magick &> /dev/null; then
  echo "ImageMagick 'magick' command not found. Please install ImageMagick to continue."
  exit 1
fi

# Loop through all PNG files in the target directory and its subdirectories
for img in "$TARGET_DIR"/*.{jpeg,jpg}; do
  # Check if there are actually any PNG files
  echo $img
  if [[ ! -f "$img" ]]; then
    echo "No PNG files found in the directory: $TARGET_DIR"
    exit 1
  fi

  # Get the dimensions of the image
  dimensions=$(magick identify -format "%w %h" "$img")
  width=$(echo "$dimensions" | awk '{print $1}')
  height=$(echo "$dimensions" | awk '{print $2}')

  # Check if the image is larger than 4K
  if (( width > MAX_WIDTH || height > MAX_HEIGHT )); then
    echo "Resizing $img from ${width}x${height} to 3840x2160"
    # Resize the image to 4K, maintaining aspect ratio
    magick "$img" -resize "${MAX_WIDTH}x${MAX_HEIGHT}>" "$img"
  else
    echo "$img is already 4K or smaller, skipping."
  fi
done

