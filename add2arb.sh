#!/bin/bash

# Check if parameter is provided
if [ -z "$1" ]; then
    echo "Error: Missing key parameter. Usage: $0 \"your_key\""
    exit 1
fi

KEY="$1"
ENTRY="  \"$KEY\": \"placeholder\""

find lib/l10n/ -type f -name "*.arb" | while read -r file; do
    # Skip if key already exists
    if grep -q "\"$KEY\":" "$file"; then
        echo "Key '$KEY' already exists in $file (skipped)"
        continue
    fi

    # Get the last key-value line (before closing brace)
    LAST_LINE=$(grep -n '^  "[^"]*"' "$file" | tail -1 | cut -d: -f1)

    if [ -n "$LAST_LINE" ]; then
        # Check if the last key-value line ends with a comma
        if ! sed -n "${LAST_LINE}p" "$file" | grep -q ',$'; then
            # Add comma to the last key-value line
            sed -i '' "${LAST_LINE}s/$/,/" "$file"
        fi
    fi

    # Insert new entry before the closing brace
    sed -i '' "/^}/i\\
$ENTRY
" "$file"

    echo "Added '$KEY' to $file"
done
echo "All done!"