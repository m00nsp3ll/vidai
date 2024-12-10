#!/bin/zsh

# Debugging: Trace commands as they are executed
#set -x

# Environment variables
export VIDAI_TOKEN="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjMxMjA2NjIsImVtYWlsIjoic3Ryb2luYW5kcmVAdWtyLm5ldCIsImV4cCI6MTczNTczMDY5NS4zMjcsImlhdCI6MTczMzEzODY5NS4zMjcsInNzbyI6ZmFsc2V9.IU9EB9mFvHelcLHyCPcp33v8FF9dwhRzqBWzptxHAsI"
export VIDAI_MODEL="gen3-turbo"
export VIDAI_INTERPOLATE=true
export VIDAI_WATERMARK=false
export VIDAI_EXPLORE=true
export VIDAI_RATIO="768:1280"
export VIDAI_WIDTH=768
export VIDAI_HEIGHT=1280

# Directories
export IMAGES_DIR="$HOME/Documents/Youtube/images"
export PROCESSED_DIR="$HOME/Documents/Youtube/processed"
export OUTPUT_DIR="$HOME/Documents/Youtube/videos"

# Logs
echo "Starting batch image-to-video processing..."
echo "Images Directory: $IMAGES_DIR"
echo "Processed Directory: $PROCESSED_DIR"
echo "Output Directory: $OUTPUT_DIR"

# Create directories if they do not exist
mkdir -p "$PROCESSED_DIR" || echo "Failed to create $PROCESSED_DIR"
mkdir -p "$OUTPUT_DIR" || echo "Failed to create $OUTPUT_DIR"

# Temporarily disable nomatch to prevent errors if no matches are found
setopt nonomatch

# Loop through all files and filter valid image extensions
for image in "$IMAGES_DIR"/*; do
    case "$image" in
        *.jpg|*.jpeg|*.png|*.JPG|*.JPEG|*.PNG)
            # Generate video output path
            base_name=$(basename "$image")
            output_video="$OUTPUT_DIR/${base_name%.*}.mp4"

            # Logs
            echo "Processing image: $image"
            echo "Output will be saved to: $output_video"

            # Run vidai command
            vidai generate --token $VIDAI_TOKEN --image "$image" --output "$output_video" --model $VIDAI_MODEL --width 768 --height 1024 || {
                echo "Failed to process $image"
                continue
            }

            # Move processed image to the processed folder
            mv "$image" "$PROCESSED_DIR/" || echo "Failed to move $image to $PROCESSED_DIR"

            echo "Completed processing $image -> $output_video"
            ;;
        *)
            echo "Skipping non-image file: $image"
            ;;
    esac
done

# Completion log
echo "Batch processing completed!"


