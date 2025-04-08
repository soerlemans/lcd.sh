#!/usr/bin/env bash

# This script should be sourced by bash.

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

    local cur
    cur="${COMP_WORDS[COMP_CWORD]}"

    # Create completions based on logical links from $LCD_DIR.
    for b in "${LCD_DIR}"/*; do
	local bname="$(basename "$b")"

	symlinks+=("\"${bname}\"")
    done

    COMPREPLY=( $(compgen -W "${symlinks[*]}" -- "$cur") )
}

function _lcd-reg_completions {
    local dirs="$(ls -1 | xargs)"

    local cur
    cur="${COMP_WORDS[COMP_CWORD]}"

    COMPREPLY=( $(compgen -W "$dirs" -- "$cur") )
}

complete -F _lcd_completions lcd
complete -F _lcd-reg_completions lcd-reg
