#!/bin/bash
set -e

# Start fresh
cat > install.sh << 'EOT'
#!/bin/bash
set -e

EOT

# === Add main index.sh (skip shebang) ===
if [ -f "index.sh" ]; then
  tail -n +2 "index.sh" >> install.sh 2>/dev/null || cat "index.sh" >> install.sh
  echo "" >> install.sh
else
  echo "⚠️  index.sh not found — skipping main content"
fi

# === Inline all utils/*.sh ===
if [ -d "utils" ]; then
  for file in utils/*.sh; do
    if [ -f "$file" ]; then
      filename=$(basename "$file")
      echo "" >> install.sh
      # Skip shebang line if present
      tail -n +2 "$file" >> install.sh 2>/dev/null || cat "$file" >> install.sh
      echo "" >> install.sh
    fi
  done
else
  echo "⚠️  utils/ directory not found"
fi

chmod +x install.sh

echo "Done."
ls -lh install.sh
