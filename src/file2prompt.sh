#!/bin/bash

# Initialize variables
search_in_subdirs=0
file_patterns=()
exclude_dirs=()
exclude_files=()
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
${C_BLUE}File2Prompt - Generate markdown code blocks from files${C_NOCOLOR}
${C_GREEN}Version: 2.0${C_NOCOLOR}

${C_YELLOW}SYNOPSIS${C_NOCOLOR}
    ${C_GREEN}$0 [OPTIONS] [FILE_PATTERNS]${C_NOCOLOR}

${C_YELLOW}DESCRIPTION${C_NOCOLOR}
    File2Prompt searches for files matching specified patterns and outputs their 
    contents as markdown code blocks. This is particularly useful for preparing 
    code snippets to be used with AI prompt engineering.

    Output is sent to stdout, while messages and errors are sent to stderr.

${C_YELLOW}OPTIONS${C_NOCOLOR}
    ${C_GREEN}-r, --recursive${C_NOCOLOR}
        Search recursively in subdirectories
        
    ${C_GREEN}-d, --exclude-dir PATTERN${C_NOCOLOR}
        Exclude directories matching pattern (can be used multiple times)
        
    ${C_GREEN}-x, --exclude FILE_PATTERN${C_NOCOLOR}
        Exclude files matching pattern (can be used multiple times)
        
    ${C_GREEN}-h, --help${C_NOCOLOR}
        Show this help message

${C_YELLOW}EXAMPLES${C_NOCOLOR}
    ${C_GREEN}$0 *.sh${C_NOCOLOR}
        Process all shell scripts in current directory
        
    ${C_GREEN}$0 -r -x *.tmp -d node_modules *.js${C_NOCOLOR}
        Recursively process JavaScript files, excluding node_modules and .tmp files
        
    ${C_GREEN}$0 -d .git -d build Makefile${C_NOCOLOR}
        Process Makefile while excluding .git and build directories

${C_YELLOW}EXIT STATUS${C_NOCOLOR}
    ${C_GREEN}0${C_NOCOLOR} - Success
    ${C_GREEN}1${C_NOCOLOR} - No files found or error

${C_YELLOW}AUTHORS${C_NOCOLOR}
    Developed by the DeepSeek team.
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
        -d|--exclude-dir)
            exclude_dirs+=("$2")
            shift 2
            ;;
        -x|--exclude)
            exclude_files+=("$2")
            shift 2
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

# Search function with exclusion support
search_files() {
    local patterns=("$@")
    local find_args=()
    
    # Base find command
    if [[ "$search_in_subdirs" == 1 ]]; then
        find_args+=(".")
    else
        find_args+=("." -maxdepth 1)
    fi
    
    # Add directory exclusions
    for dir in "${exclude_dirs[@]}"; do
        find_args+=(-not -path "*$dir*")
    done
    
    # Add file type and name patterns
    find_args+=(-type f \( "${patterns[@]}" \))
    
    # Add file exclusions
    for pattern in "${exclude_files[@]}"; do
        find_args+=(-not -name "$pattern")
    done
    
    # Execute find command
    find "${find_args[@]}" -print0 2>/dev/null
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