#!/bin/bash
set -e

# === Paths ===
INDEX_FILE="index.sh"
UTILS_DIR="utils"
LIB_DIR="lib"
OUTPUT_FILE="install.sh"

# Start fresh
cat > "$OUTPUT_FILE" << 'EOT'
#!/bin/bash
set -e

EOT

# === Inline all lib/*.sh ===
if [ -d "$LIB_DIR" ]; then
  for file in "$LIB_DIR"/*.sh; do
    if [ -f "$file" ]; then
      filename=$(basename "$file")
      echo "" >> "$OUTPUT_FILE"
      # Skip shebang line if present
      tail -n +2 "$file" >> "$OUTPUT_FILE" 2>/dev/null || cat "$file" >> "$OUTPUT_FILE"
      echo "" >> "$OUTPUT_FILE"
    fi
  done
else
  echo "⚠️  $LIB_DIR/ directory not found"
fi

# === Inline all utils/*.sh ===
if [ -d "$UTILS_DIR" ]; then
  for file in "$UTILS_DIR"/*.sh; do
    if [ -f "$file" ]; then
      filename=$(basename "$file")
      echo "" >> "$OUTPUT_FILE"
      # Skip shebang line if present
      tail -n +2 "$file" >> "$OUTPUT_FILE" 2>/dev/null || cat "$file" >> "$OUTPUT_FILE"
      echo "" >> "$OUTPUT_FILE"
    fi
  done
else
  echo "⚠️  $UTILS_DIR/ directory not found"
fi

# === Add main index.sh (skip shebang) ===
if [ -f "$INDEX_FILE" ]; then
  tail -n +2 "$INDEX_FILE" >> "$OUTPUT_FILE" 2>/dev/null || cat "$INDEX_FILE" >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"
else
  echo "⚠️  $INDEX_FILE not found — skipping main content"
fi

chmod +x "$OUTPUT_FILE"

echo "Done."
ls -lh "$OUTPUT_FILE"
