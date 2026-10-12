#!/usr/bin/env bash
# =============================================================================
# gen-commit-msg.sh
# Git context collector script for `commit` and `commit-push` skills.
# Collects repository state, branch information, status, and diffs.
#
# Usage:
#   bash gen-commit-msg.sh
#   bash gen-commit-msg.sh --unstaged
# =============================================================================

set -euo pipefail

MODE="${1:-}"

echo "========================================"
echo "  GIT CONTEXT COLLECTOR"
echo "========================================"
echo ""

# --- Branch ---
echo "## CURRENT BRANCH"
git branch --show-current 2>/dev/null || echo "(detached HEAD)"
echo ""

# --- Status ---
echo "## STATUS"
git status --short
echo ""

# --- Recent Commit History ---
echo "## RECENT COMMITS (last 10)"
git log --oneline -10 2>/dev/null || echo "(no commits yet)"
echo ""

# --- Remotes ---
echo "## REMOTES"
git remote -v 2>/dev/null || echo "(no remotes configured)"
echo ""

# --- Diff ---
STAGED_STAT=$(git diff --staged --stat 2>/dev/null)

if [[ -z "$MODE" && -n "$STAGED_STAT" ]]; then
  echo "## DIFF STAT (staged)"
  echo "$STAGED_STAT"
  echo ""
  echo "## DIFF FULL (staged)"
  git diff --staged
else
  echo "## DIFF STAT (unstaged / working tree)"
  git diff --stat
  echo ""
  echo "## DIFF FULL (unstaged / working tree)"
  git diff
fi

echo ""
echo "========================================"
echo "  END OF CONTEXT"
echo "========================================"
