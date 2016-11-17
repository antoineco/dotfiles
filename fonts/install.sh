#!/bin/bash

# Set source and target directories
fonts_dir=$( cd "$( dirname "$0" )" && pwd )

find_command="find \"$fonts_dir\" -name '*.[o,t]tf' -type f -print0"

if [[ $(uname -s) == 'Darwin' ]]; then
  # MacOS
  font_dir="$HOME/Library/Fonts"
else
  # Linux
  font_dir="$HOME/.local/share/fonts"
  mkdir -p $font_dir
fi

# Copy all fonts to user fonts directory
echo "Copying fonts..."
eval $find_command | xargs -0 -I % cp -v "%" "$font_dir/"

# Reset font cache on Linux
if command -v fc-cache @>/dev/null ; then
    echo "Resetting font cache..."
    fc-cache -f $font_dir
fi

echo "All fonts installed to $font_dir"
