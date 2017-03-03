#
# Defines Pacman aliases.
#
# Authors:
#   Benjamin Boudreau <dreurmail@gmail.com>
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#
# Tips:
#   https://wiki.archlinux.org/index.php/Pacman_Tips
#

# Return if requirements are not found.
if (( ! $+commands[pacman] )); then
  return 1
fi

#
# Frontend
#

# Get the Pacman frontend.
zstyle -s ':prezto:module:pacman' frontend '_pacman_frontend'
zstyle -s ':prezto:module:pacman' noconfirm '_pacman_noconfirm'

if (( $+commands[$_pacman_frontend] )); then
  alias pacman="$_pacman_frontend"

  if [[ -s "${0:h}/${_pacman_frontend}.zsh" ]]; then
    source "${0:h}/${_pacman_frontend}.zsh"
  fi
else
  _pacman_frontend='pacman'
  _pacman_sudo='sudo '
fi

if (( $+commands[$_pacman_noconfirm] )); then
  _pacman_noconfirm='--noconfirm'
fi

#
# Aliases
#

# Pacman.
alias pac="${_pacman_frontend}"

# Installs packages from repositories.
alias paci="${_pacman_sudo}${_pacman_frontend}${_pacman_noconfirm} --sync"

# Installs packages from files.
alias pacI="${_pacman_sudo}${_pacman_frontend}${_pacman_noconfirm} --upgrade"

# Removes packages and unneeded dependencies.
alias pacx="${_pacman_sudo}${_pacman_frontend}${_pacman_noconfirm} --remove"

# Removes packages, their configuration, and unneeded dependencies.
alias pacX="${_pacman_sudo}${_pacman_frontend}${_pacman_noconfirm} --remove --nosave --recursive"

# Displays information about a package from the repositories.
alias pacq="${_pacman_frontend} --sync --info"

# Displays information about a package from the local database.
alias pacQ="${_pacman_frontend} --query --info"

# Searches for packages in the repositories.
alias pacs="${_pacman_frontend} --sync --search"

# Searches for packages in the local database.
alias pacS="${_pacman_frontend} --query --search"

# Lists orphan packages.
alias pacman-list-orphans="${_pacman_sudo}${_pacman_frontend} --query --deps --unrequired"

# Removes orphan packages.
alias pacman-remove-orphans="${_pacman_sudo}${_pacman_frontend} --remove --recursive \$(${_pacman_frontend} --quiet --query --deps --unrequired)"

# Synchronizes the local package and Arch Build System databases against the
# repositories.
if (( $+commands[abs] )); then
  alias pacu="${_pacman_sudo}${_pacman_frontend}${_pacman_noconfirm} --sync --refresh && sudo abs"
else
  alias pacu="${_pacman_sudo}${_pacman_frontend}${_pacman_noconfirm} --sync --refresh"
fi

# Synchronizes the local package database against the repositories then
# upgrades outdated packages.
alias pacU="${_pacman_sudo}${_pacman_frontend}${_pacman_noconfirm} --sync --refresh --sysupgrade"

unset _pacman_{frontend,sudo}

function paclist() {
  # Source: https://bbs.archlinux.org/viewtopic.php?id=93683
  LC_ALL=C pacman -Qei $(pacman -Qu | cut -d " " -f 1) | \
    awk 'BEGIN {FS=":"} /^Name/{printf("\033[1;36m%s\033[1;37m", $2)} /^Description/{print $2}'
}

function pacdisowned() {
  emulate -L zsh

  tmp=${TMPDIR-/tmp}/pacman-disowned-$UID-$$
  db=$tmp/db
  fs=$tmp/fs

  mkdir "$tmp"
  trap  'rm -rf "$tmp"' EXIT

  pacman -Qlq | sort -u > "$db"

  find /bin /etc /lib /sbin /usr ! -name lost+found \
    \( -type d -printf '%p/\n' -o -print \) | sort > "$fs"

  comm -23 "$fs" "$db"
}

function pacmanallkeys() {
  emulate -L zsh
  curl -s https://www.archlinux.org/people/{developers,trustedusers}/ | \
    awk -F\" '(/pgp.mit.edu/) { sub(/.*search=0x/,""); print $1}' | \
    xargs sudo pacman-key --recv-keys
}

function pacmansignkeys() {
  emulate -L zsh
    for key in $*; do
      sudo pacman-key --recv-keys $key
      sudo pacman-key --lsign-key $key
      printf 'trust\n3\n' | sudo gpg --homedir /etc/pacman.d/gnupg \
        --no-permission-warning --command-fd 0 --edit-key $key
    done
}