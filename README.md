lcd.sh
=======
Cd command for bookmarks using symbolic links.
To make use of the scripts just source either:
 - `lcd.sh` (Bash)
 - `lcd.zsh` (ZSH)

## Usage:
  - `lcd <bookmark>`: Jump to bookmark.
  - `lcd-reg <relative directory>`: Register a directory to bookmark (if no relative directory is provided use `$PWD`).
  - `lcd-ls`: List bookmarks.
  - `lcd-rm`: Remove invalid symbolic links.

