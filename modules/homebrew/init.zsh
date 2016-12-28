#
# Defines Homebrew aliases.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Return if requirements are not found.
if [[ "$OSTYPE" != (darwin|linux)* ]]; then
  return 1
fi

#
# Aliases
#

# Homebrew
alias brewc='brew cleanup'
alias brewC='brew cleanup --force'
alias brewi='brew install'
alias brewl='brew list'
alias brews='brew search'
alias brewu='brew update && brew upgrade --all'
alias brewx='brew remove'
alias brewe='brew edit'
alias brewmd='brew doctor'

# Homebrew Cask
alias cask='brew cask'
alias caskc='brew cask cleanup --outdated'
alias caskC='brew cask cleanup'
alias caski='brew cask install'
alias caskl='brew cask list'
alias casks='brew cask search'
alias caskx='brew cask uninstall'

# Update Homebrew
alias brewu='brew update && brew upgrade --all && brew cleanup && brew prune && brew doctor'