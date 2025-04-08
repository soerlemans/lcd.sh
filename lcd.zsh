#!/usr/bin/env zsh

# This script should be sourced by ZSH.

# Globals:
export LCD_DIR="${HOME}/.bmarks"

# If the dir does not exist yet create it.
[[ -d "$LCD_DIR" ]] || mkdir -p "${LCD_DIR}/"

# Functions:
# Cd to bookmark.
function lcd {
    local dir=${1:?"Usage: lcd <bookmark>"}

    # Cd into the symbolic link.
    cd "${LCD_DIR}/${dir}"
}

# Register a bookmark.
function lcd-reg {
    local dir="${1:-"$PWD"}"
    local name="${2}"

    # Check if it is a directory.
    if [[ ! -d "$dir" ]]; then
	echo "Error: $dir is not a directory." &>2
	exit 1
    fi

    # Create a symbolic link to the directory.
    ln --symbolic "$dir" "${LCD_DIR}/${name}"
}

# List bookmarks.
function lcd-ls {
    ls -l1 --almost-all "${LCD_DIR}"
}

# Remove invalidated bookmarks.
function lcd-rm {
    for b in "${LCD_DIR}"/*; do
	if [[ ! -e "$b" ]]; then
	    echo "$b"
	    rm "$b"
	fi
    done
}

# Completions:
function _lcd_completions {
    local -a symlinks

    # Create completions based on logical links from $LCD_DIR.
    for f in "${LCD_DIR}"/*; do
	local bname="$(basename "$f")"

	symlinks+=("${(q)bname}")
    done

    _arguments "1:directory:(${symlinks[*]})"
}

function _lcd-reg_completions {
    _arguments "1:directory:_dirs"
    _arguments "2:name:_dirs"
}

compdef _lcd_completions lcd
compdef _lcd-reg_completions lcd-reg
