#!/usr/bin/env bash
# ==============================================================================
# Universal Agent Skills Installer (AI)
# https://github.com/luishrmc/ai
# ==============================================================================
set -euo pipefail

# Visual formatting
BOLD="\033[1m"
GREEN="\033[0;32m"
BLUE="\033[0;34m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
CYAN="\033[0;36m"
RESET="\033[0m"

REPO_URL="https://github.com/luishrmc/ai.git"
DEFAULT_GLOBAL_TARGET="$HOME/.gemini/config/skills"
TARGET_DIR=""
MODE="copy" # "copy" or "symlink"
INSTALL_ALL=true
SELECTED_SKILLS=()

# Determine script root or handle curl execution
TEMP_DIR=""
cleanup() {
  if [ -n "$TEMP_DIR" ] && [ -d "$TEMP_DIR" ]; then
    rm -rf "$TEMP_DIR"
  fi
}
trap cleanup EXIT

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || echo "")"

if [ -z "$SCRIPT_DIR" ] || [ ! -d "$SCRIPT_DIR/skills" ]; then
  # Executed via pipe (curl | bash)
  echo -e "${CYAN}==>${RESET} Detected pipe execution. Cloning repository to temporary workspace..."
  TEMP_DIR="$(mktemp -d /tmp/ai-skills-XXXXXX)"
  git clone --depth 1 -q "$REPO_URL" "$TEMP_DIR"
  SKILLS_SOURCE="$TEMP_DIR/skills"
else
  SKILLS_SOURCE="$SCRIPT_DIR/skills"
fi

usage() {
  cat << EOF
${BOLD}Universal Agent Skills Installer (AI)${RESET}

Usage:
  ./install.sh [options] [skill1 skill2 ...]

Options:
  -t, --target <path>     Target installation directory
                          (Default: $DEFAULT_GLOBAL_TARGET)
  -s, --symlink           Create symbolic links instead of copying (active development)
  -c, --copy              Copy skill files directly (default)
  -a, --all               Install all available skills
  -l, --list              List all available skills with descriptions
  -h, --help              Show this help message

Preset Targets:
  --global-gemini         Install to ~/.gemini/config/skills (Antigravity / Gemini CLI)
  --global-claude         Install to ~/.claude/skills (Claude Code)
  --project-agents        Install to ./.agents/skills (Current workspace .agents/)
  --project-skills        Install to ./skills (Current workspace skills/)

Examples:
  ./install.sh                                 # Install all skills globally (copy)
  ./install.sh --symlink                       # Symlink all skills globally
  ./install.sh shape-grill dev-implement       # Install only selected skills
  ./install.sh --project-agents                # Install all skills into current project
  ./install.sh -t ~/my-agent-skills -s         # Symlink all skills into custom dir
EOF
  exit 0
}

list_skills() {
  echo -e "${BOLD}Available Agent Skills in AI:${RESET}\n"
  for skill_dir in "$SKILLS_SOURCE"/*; do
    if [ -d "$skill_dir" ]; then
      skill_name="$(basename "$skill_dir")"
      desc="No description"
      if [ -f "$skill_dir/SKILL.md" ]; then
        desc="$(sed -n -e '/^description:/ { s/^description:[[:space:]]*[>-]*//; p; q; }' "$skill_dir/SKILL.md" | tr -d '\n' | sed 's/^[[:space:]]*//')"
        if [ -z "$desc" ]; then
          # Multi-line description check
          desc="$(awk '/^description:/{flag=1; next} /^[a-zA-Z0-9_-]+:/{flag=0} flag{gsub(/^[ \t]+/, ""); printf "%s ", $0}' "$skill_dir/SKILL.md" | head -c 120)"
        fi
      fi
      printf "  ${GREEN}%-24s${RESET} %s\n" "$skill_name" "${desc:-No description available}"
    fi
  done
  echo ""
  exit 0
}

# Parse Arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    -t|--target)
      TARGET_DIR="$2"
      shift 2
      ;;
    --global-gemini)
      TARGET_DIR="$HOME/.gemini/config/skills"
      shift
      ;;
    --global-claude)
      TARGET_DIR="$HOME/.claude/skills"
      shift
      ;;
    --project-agents)
      TARGET_DIR="$(pwd)/.agents/skills"
      shift
      ;;
    --project-skills)
      TARGET_DIR="$(pwd)/skills"
      shift
      ;;
    -s|--symlink)
      MODE="symlink"
      shift
      ;;
    -c|--copy)
      MODE="copy"
      shift
      ;;
    -a|--all)
      INSTALL_ALL=true
      shift
      ;;
    -l|--list)
      list_skills
      ;;
    -h|--help)
      usage
      ;;
    -*)
      echo -e "${RED}Unknown option: $1${RESET}" >&2
      usage
      ;;
    *)
      INSTALL_ALL=false
      SELECTED_SKILLS+=("$1")
      shift
      ;;
  esac
done

# Fallback target
if [ -z "$TARGET_DIR" ]; then
  TARGET_DIR="$DEFAULT_GLOBAL_TARGET"
fi

mkdir -p "$TARGET_DIR"

echo -e "${BOLD}${CYAN}=== Universal Agent Skills Installer ===${RESET}"
echo -e "Source: ${BLUE}$SKILLS_SOURCE${RESET}"
echo -e "Target: ${GREEN}$TARGET_DIR${RESET}"
echo -e "Mode:   ${YELLOW}$MODE${RESET}\n"

# Collect skills to install
declare -a SKILLS_TO_INSTALL=()
if [ "$INSTALL_ALL" = true ] || [ ${#SELECTED_SKILLS[@]} -eq 0 ]; then
  for d in "$SKILLS_SOURCE"/*; do
    if [ -d "$d" ]; then
      SKILLS_TO_INSTALL+=("$(basename "$d")")
    fi
  done
else
  SKILLS_TO_INSTALL=("${SELECTED_SKILLS[@]}")
fi

INSTALLED_COUNT=0
for skill in "${SKILLS_TO_INSTALL[@]}"; do
  src_path="$SKILLS_SOURCE/$skill"
  dest_path="$TARGET_DIR/$skill"

  if [ ! -d "$src_path" ]; then
    echo -e "  ${RED}✗${RESET} Skill ${BOLD}$skill${RESET} not found in repository. Skipping."
    continue
  fi

  if [ "$MODE" = "symlink" ]; then
    # Resolve absolute path for symlink
    abs_src="$(cd "$src_path" && pwd -P)"
    ln -sfn "$abs_src" "$dest_path"
    echo -e "  ${GREEN}✓${RESET} Symlinked: ${BOLD}$skill${RESET} -> $dest_path"
  else
    # Copy
    rm -rf "$dest_path"
    cp -r "$src_path" "$dest_path"
    echo -e "  ${GREEN}✓${RESET} Copied:    ${BOLD}$skill${RESET} -> $dest_path"
  fi
  INSTALLED_COUNT=$((INSTALLED_COUNT + 1))
done

echo -e "\n${BOLD}${GREEN}Successfully installed $INSTALLED_COUNT skill(s) into $TARGET_DIR!${RESET}"
if [ "$TARGET_DIR" = "$DEFAULT_GLOBAL_TARGET" ]; then
  echo -e "${BLUE}These skills are now active globally in Antigravity / Gemini CLI.${RESET}"
fi