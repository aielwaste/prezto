#
# Defines Mac OS X aliases and functions.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

if [[ -f "~/.zprezto/modules/osx/alias.suffix.zsh" ]]; then
  source "~/.zprezto/modules/osx/alias.suffix.zsh"
fi

# Return if requirements are not found.
if [[ "$OSTYPE" != darwin* ]]; then
  return 1
fi

#
# Aliases
#

# Changes directory to the current Finder directory.
alias cdf='cd "$(pfd)"'

# Pushes directory to the current Finder directory.
alias pushdf='pushd "$(pfd)"'

#
# Finder
#

# Toggle AppleShowAllFiles
toggle_hidden() {
  local ASAF
  ASAF=$(defaults read com.apple.Finder AppleShowAllFiles)
  if [[ '$ASAF' = 'TRUE' ]]; then
    defaults write com.apple.Finder AppleShowAllFiles FALSE
    killall Finder
    echo 'AppleShowAllFiles Disabled.'
  else
    defaults write com.apple.Finder AppleShowAllFiles TRUE
    killall Finder
    echo 'AppleShowAllFiles Enabled.'
  fi
}
