#!/bin/bash

# Initialize variables
search_in_subdirs=0
file_patterns=()
color_enabled=1
stdout_buffer=""

# Check if output is to terminal
if [ ! -t 1 ]; then
    color_enabled=0
fi

# Color definitions
if [ $color_enabled -eq 1 ]; then
    C_RED='\033[0;31m'
    C_GREEN='\033[1;32m'
    C_YELLOW='\033[0;33m'
    C_BLUE='\033[0;34m'
    C_NOCOLOR='\033[0m'
else
    C_RED=""
    C_GREEN=""
    C_YELLOW=""
    C_BLUE=""
    C_NOCOLOR=""
fi

# Show help function
show_help() {
    cat >&2 <<EOF
${C_BLUE}File2Prompt - Generate code blocks from files${C_NOCOLOR}
${C_GREEN}Usage: $0 [OPTIONS] [FILE_PATTERNS]${C_NOCOLOR}

${C_YELLOW}Options:${C_NOCOLOR}
  -r, --recursive    Search in subdirectories
  -h, --help         Show this help message

${C_YELLOW}Examples:${C_NOCOLOR}
  $0 *.sh               # Process all shell scripts in current directory
  $0 -r *.py *.js       # Recursively process Python and JavaScript files
  $0 Makefile           # Process specific file

${C_YELLOW}Output:${C_NOCOLOR}
  Generated markdown-style code blocks printed to stdout
  Messages and errors printed to stderr
EOF
    exit 0
}

# Parse arguments
while test $# -gt 0; do
    case "$1" in
        -r|--recursive)
            search_in_subdirs=1
            shift
            ;;
        -h|--help)
            show_help
            ;;
        *)
            if [[ "${#file_patterns[@]}" -eq 0 ]]; then
                file_patterns+=(-name "$1")
            else
                file_patterns+=(-o -name "$1")
            fi
            shift
            ;;
    esac
done

# If no file patterns provided, search for all files
if [[ "${#file_patterns[@]}" -eq 0 ]]; then
    file_patterns=(-name "*")
fi

# Search function
search_files() {
    local patterns=("$@")
    if [[ "$search_in_subdirs" == 1 ]]; then
        find . -type f \( "${patterns[@]}" \) -print0 2>/dev/null
    else
        find . -maxdepth 1 -type f \( "${patterns[@]}" \) -print0 2>/dev/null
    fi
}

# Main processing
found=0
while IFS= read -r -d $'\0' file; do
    found=1
    # Print to stderr
    echo -e "${C_YELLOW}Found:${C_NOCOLOR} ${file#./}" >&2

    # Read file content
    content=$(<"$file")

    # Add to stdout buffer
    stdout_buffer+="\`\`\`${file#./}\n$content\n\`\`\`\n\n"
done < <(search_files "${file_patterns[@]}")

# Output results
if [[ $found -eq 0 ]]; then
    echo -e "${C_YELLOW}No matching files found${C_NOCOLOR}" >&2
    exit 1
else
    # Print to stdout with literal newlines
    echo -e "$stdout_buffer"
fi