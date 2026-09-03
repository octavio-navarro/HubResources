#!/usr/bin/env bash

# Helper to print script usage
usage() {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  -a, --author <name/email>  Filter by author upfront"
    echo "  -s, --since <date>         Filter commits since date (e.g., '2026-01-01' or '2 weeks ago')"
    echo "  -u, --until <date>         Filter commits until date"
    echo "  -h, --help                 Display this help message"
    exit 0
}

# Parse Command Line Arguments
AUTHOR=""
SINCE=""
UNTIL=""

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -a|--author) AUTHOR="$2"; shift ;;
        -s|--since)  SINCE="$2"; shift ;;
        -u|--until)  UNTIL="$2"; shift ;;
        -h|--help)   usage ;;
        *) echo "Unknown parameter passed: $1"; usage; exit 1 ;;
    esac
    shift
done

# 1. Interactive Author Selection (Looks across ALL branches)
if [ -z "$AUTHOR" ]; then
    echo "--> Fetching repository contributors from all branches..."
    AUTHOR=$(git log --all --format="%an <%ae>" | sort | uniq -c | sort -nr | sed 's/^[[:space:]]*[0-9]*[[:space:]]*//' | \
        fzf --ansi \
            --prompt="Select a contributor to audit > " \
            --header="Type to filter | Press Enter to select | Esc to exit")
    
    if [ -z "$AUTHOR" ]; then
        echo "No author selected. Exiting."
        exit 0
    fi
    echo "Selected Author: $AUTHOR"
fi

# 2. Interactive Date Selection
if [ -z "$SINCE" ]; then
    echo "--------------------------------------------------"
    echo "Enter a starting date filter (Optional)."
    echo "Supports formats like '2026-01-01', '1 month ago', 'yesterday'."
    echo "--------------------------------------------------"
    read -p "Since date [Leave blank for all history]: " SINCE
fi

# 3. Build the Git Log command dynamically
# Note: Added '--source' and '%C(bold magenta)[%S]' to explicitly label the source branch of EVERY line
git_args=(log --all --source --color=always --format='%C(auto)%h %C(bold magenta)[%S]%d %s %C(green)(%cd) %C(blue)[%an]' --date=short)

if [ -n "$AUTHOR" ]; then
    git_args+=(--author="$AUTHOR")
fi

if [ -n "$SINCE" ]; then
    git_args+=(--since="$SINCE")
fi

if [ -n "$UNTIL" ]; then
    git_args+=(--until="$UNTIL")
fi

# 4. Stream results into FZF with dynamic branch visibility
git "${git_args[@]}" | fzf --ansi \
    --no-sort \
    --header "Use Arrows to browse | Enter to open full patch in less | Esc to exit" \
    --prompt="Filter Commits (Type branch name or keyword) > " \
    --preview "echo -e '\033[1;35m=== ALL BRANCHES CONTAINING THIS COMMIT ===\033[0m'; \
              git branch -a --contains {1} | sed 's/^/  /'; \
              echo; \
              echo -e '\033[1;36m=== COMMIT PATCH DETAILS ===\033[0m'; \
              git show --color=always {1}" \
    --bind "enter:execute(git show --color=always {1} | less -R)"
