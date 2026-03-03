#!/usr/bin/env bash
set -euo pipefail

# encounter-kit installer
# Copies agent definitions and format spec into a target repository.
#
# Usage:
#   ./scripts/install.sh [TARGET_DIR]
#
# If TARGET_DIR is omitted, defaults to current directory.
# Use --symlink to create symlinks instead of copies (for live updates).

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KIT_DIR="$(dirname "$SCRIPT_DIR")"

MODE="copy"
TARGET="."

while [[ $# -gt 0 ]]; do
    case "$1" in
        --symlink) MODE="symlink"; shift ;;
        --help|-h)
            echo "Usage: $0 [--symlink] [TARGET_DIR]"
            echo ""
            echo "Installs encounter-kit agent definitions into a target repository."
            echo ""
            echo "Options:"
            echo "  --symlink    Create symlinks instead of copies"
            echo "  --help       Show this help message"
            echo ""
            echo "Files installed:"
            echo "  docs/encounters/ENCOUNTER-FORMAT.md"
            echo "  .github/prompts/brain-dump.prompt.md"
            echo "  .claude/prompts/brain-dump.md"
            echo "  .cursor/rules/brain-dump.mdc"
            exit 0
            ;;
        *) TARGET="$1"; shift ;;
    esac
done

TARGET="$(cd "$TARGET" 2>/dev/null && pwd || echo "$TARGET")"

echo "encounter-kit installer"
echo "  Source: $KIT_DIR"
echo "  Target: $TARGET"
echo "  Mode:   $MODE"
echo ""

# Create target directories
mkdir -p "$TARGET/docs/encounters"
mkdir -p "$TARGET/.github/prompts"
mkdir -p "$TARGET/.claude/prompts"
mkdir -p "$TARGET/.cursor/rules"

install_file() {
    local src="$1"
    local dst="$2"

    if [ "$MODE" = "symlink" ]; then
        ln -sf "$src" "$dst"
        echo "  linked $dst -> $src"
    else
        cp "$src" "$dst"
        echo "  copied $dst"
    fi
}

install_file "$KIT_DIR/spec/ENCOUNTER-FORMAT.md" \
             "$TARGET/docs/encounters/ENCOUNTER-FORMAT.md"

install_file "$KIT_DIR/agents/github-copilot/brain-dump.prompt.md" \
             "$TARGET/.github/prompts/brain-dump.prompt.md"

install_file "$KIT_DIR/agents/claude-code/brain-dump.md" \
             "$TARGET/.claude/prompts/brain-dump.md"

install_file "$KIT_DIR/agents/cursor/brain-dump.mdc" \
             "$TARGET/.cursor/rules/brain-dump.mdc"

echo ""
echo "Installation complete."
echo ""
echo "The Claude.ai agent (agents/claude-ai/brain-dump.md) must be installed"
echo "manually as Claude Project instructions. Copy its contents into your"
echo "project\'s custom instructions field."
