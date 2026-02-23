#!/bin/bash
set -euo pipefail

# publish-editions.sh
# Auto-publishes new Agent Stack editions from source to robt.uk Hugo blog.
# Detects unpublished editions, converts to Hugo format, builds, and deploys.
#
# Source: ~/Projects/taylored-systems/the-agent-stack/editions/
# Target: ~/Projects/robt-uk/content/the-agent-stack/
#
# Usage:
#   ./publish-editions.sh          # publish new editions + build + deploy
#   ./publish-editions.sh --dry-run  # show what would be published, no changes

# --- Configuration ---
EDITIONS_DIR="$HOME/Projects/taylored-systems/the-agent-stack/editions"
HUGO_DIR="$HOME/Projects/robt-uk"
CONTENT_DIR="$HUGO_DIR/content/the-agent-stack"
LOG_FILE="$HUGO_DIR/scripts/.publish.log"

# Ensure PATH includes homebrew binaries (needed when run via launchd)
export PATH="/opt/homebrew/bin:/usr/local/bin:$HOME/.bun/bin:$PATH"

DRY_RUN=false
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=true

# --- Functions ---
log() {
  local msg="[$(date '+%Y-%m-%d %H:%M:%S')] $*"
  echo "$msg" >> "$LOG_FILE"
  echo "$*"
}

slugify() {
  echo "$1" | tr '[:upper:]' '[:lower:]' | \
    sed -E "s/['\"]//g" | \
    sed -E 's/[^a-z0-9]+/-/g' | \
    sed -E 's/^-|-$//g'
}

extract_description() {
  # First non-empty, non-formatting line from body, cleaned up, max 160 chars
  echo "$1" | sed '/^$/d' | sed '/^---$/d' | sed '/^\*\*/d' | head -1 | \
    sed 's/\*//g' | sed 's/\[//g' | sed 's/\]//g' | cut -c1-160
}

# --- Main ---
mkdir -p "$CONTENT_DIR"
mkdir -p "$(dirname "$LOG_FILE")"

published=0
new_files=()

for src in "$EDITIONS_DIR"/*.md; do
  [ -f "$src" ] || continue

  # Parse edition number from first line: "# Edition 001 — Monday Build"
  first_line=$(head -1 "$src")
  edition_num=$(echo "$first_line" | grep -oE '[0-9]{3}' | head -1)
  [ -z "$edition_num" ] && { log "SKIP: No edition number found in $src"; continue; }

  # Check if already published (look for matching edition reference in Hugo content)
  if grep -rl "The Agent Stack #${edition_num}" "$CONTENT_DIR" >/dev/null 2>&1; then
    continue
  fi

  # Parse edition type from first line (everything after " — ")
  edition_type=$(echo "$first_line" | sed -E 's/.*— //')

  # Parse title from second line: "# Subject: Title here"
  title=$(sed -n '2p' "$src" | sed 's/^# Subject: //')

  # Use today's date
  pub_date=$(date '+%Y-%m-%d')

  # Generate slug
  slug=$(slugify "$title")

  # Extract body: everything after the first "---" line
  body=$(awk 'found{print} /^---$/ && !found{found=1}' "$src")

  # Clean up body
  body=$(echo "$body" | sed 's/GBP /£/g')

  # Generate description
  description=$(extract_description "$body")
  description=$(echo "$description" | sed 's/"/\\"/g')

  # Tags: always "The Agent Stack" plus a category based on edition type
  case "$edition_type" in
    "Monday Build")    extra_tag="Builds" ;;
    "Wednesday Stack") extra_tag="Tools" ;;
    "Friday Signal")   extra_tag="Industry" ;;
    *)                 extra_tag="" ;;
  esac

  if [ -n "$extra_tag" ]; then
    tags="[\"The Agent Stack\", \"$extra_tag\"]"
  else
    tags="[\"The Agent Stack\"]"
  fi

  # Target file
  hugo_file="$CONTENT_DIR/${pub_date}-${slug}.md"

  if $DRY_RUN; then
    log "DRY RUN: Would publish edition #${edition_num} → ${hugo_file}"
    published=$((published + 1))
    continue
  fi

  # Write Hugo markdown file
  {
    echo "---"
    echo "title: \"$title\""
    echo "date: $pub_date"
    echo "draft: false"
    echo "description: \"$description\""
    echo "tags: $tags"
    echo "---"
    echo ""
    echo "*The Agent Stack #${edition_num} — ${edition_type}*"
    echo ""
    echo "---"
    echo ""
    echo "$body"
  } > "$hugo_file"

  new_files+=("$hugo_file")
  log "Published edition #${edition_num}: $(basename "$hugo_file")"
  published=$((published + 1))
done

if [ "$published" -eq 0 ]; then
  log "No new editions to publish"
  exit 0
fi

if $DRY_RUN; then
  log "DRY RUN complete. $published edition(s) would be published."
  exit 0
fi

# Build Hugo
log "Building Hugo site..."
cd "$HUGO_DIR"
hugo --quiet 2>&1 | tail -5 >> "$LOG_FILE" || true
log "Hugo build complete"

# Deploy to Cloudflare Pages
log "Deploying to Cloudflare Pages..."
(unset CF_API_TOKEN && unset CLOUDFLARE_API_TOKEN && \
  npx wrangler pages deploy public --project-name=robt-uk --commit-dirty=true 2>&1) | \
  tail -10 >> "$LOG_FILE" || {
    log "ERROR: Cloudflare deploy failed"
    exit 1
  }

log "Done. Published $published new edition(s) to robt.uk"

# Send notification if voice server is available
curl -s -X POST http://localhost:8888/notify \
  -H "Content-Type: application/json" \
  -d "{\"message\": \"Published $published new Agent Stack edition to robt.uk\"}" \
  > /dev/null 2>&1 || true
