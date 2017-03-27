#
# Defines general aliases and functions.
#
# Authors:
#   Robby Russell <robby@planetargon.com>
#   Suraj N. Kurapati <sunaku@gmail.com>
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#   Andrew Bell <andrewbell8@gmail.com>
#

# Load Dependencies
pmodload 'helper' 'spectrum'
setopt CORRECT

#
# Global Aliases
#
alias -g asrc="cd $HOME && source .zshrc && source .zpreztorc"
alias -g C='| wc -l'
alias -g H='| head'
alias -g L="| less"
alias -g DN="| /dev/null"
alias -g S='| sort'
alias -g G='| grep' # now you can do: ls foo G something
alias -g PIPE='|'

#
# Aliases
#

# Disable correction
alias ack='nocorrect ack'
alias cd='nocorrect cd'
alias cp='nocorrect cp'
alias ebuild='nocorrect ebuild'
alias gcc='nocorrect gcc'
alias gist='nocorrect gist'
alias grep='nocorrect grep'
alias heroku='nocorrect heroku'
alias ln='nocorrect ln'
alias man='nocorrect man'
alias mkdir='nocorrect mkdir'
alias mv='nocorrect mv'
alias mysql='nocorrect mysql'
alias rm='nocorrect rm'

# Disable Globbing
alias bower='noglob bower'
alias fc='noglob fc'
alias find='noglob find'
alias ftp='noglob ftp'
alias history='noglob history'
alias locate='noglob locate'
alias rake='noglob rake'
alias rsync='noglob rsync'
alias scp='noglob scp'
alias sftp='noglob sftp'

# Define General Aliases
alias _='sudo'
alias b='${(z)BROWSER}'
alias cp="${aliases[cp]:-cp}"
alias e='${(z)VISUAL:-${(z)EDITOR}}'
alias ln="${aliases[ln]:-ln}"
alias mkdir="${aliases[mkdir]:-mkdir} -p"
alias mv="${aliases[mv]:-mv}"
alias p='${(z)PAGER}'
alias po='popd'
alias pu='pushd'
alias rm="${aliases[rm]:-rm}"
alias type='type -a'
alias tree='tree -FC'
alias dmesg='dmesg --color=always | less'
alias cd..='cd ..'

# LS
if is-callable 'dircolors'; then
  # GNU Core Utilities
  alias l='ls --l --all --group-directories-first --dereference'
  alias ls='ls --group-directories-first'

  if zstyle -t ':prezto:module:utility:ls' color; then
    if [[ -s "$HOME/.dir_colors" ]]; then
      eval "$(dircolors --sh "$HOME/.dir_colors")"
    else
      eval "$(dircolors --sh)"
    fi

    alias ls="${aliases[ls]:-ls} --color=auto"
  else
    alias ls="${aliases[ls]:-ls} -F"
  fi
else
  # BSD Core Utilities =====
  if zstyle -t ':prezto:module:utility:ls' color; then
    # Define colors for BSD ls.
    export LSCOLORS='exfxcxdxbxGxDxabagacad'

    # Define colors for the completion system.
    export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=36;01:cd=33;01:su=31;40;07:sg=36;40;07:tw=32;40;07:ow=33;40;07:'

    alias ls="${aliases[ls]:-ls} -G"
  else
    alias ls="${aliases[ls]:-ls} -F"
  fi
fi

alias l='ls -1A'         # Lists in one column, hidden files.
alias ll='ls -lh'        # Lists human readable sizes.
alias lr='ll -R'         # Lists human readable sizes, recursively.
alias la='ll -A'         # Lists human readable sizes, hidden files.
alias lm='la | "$PAGER"' # Lists human readable sizes, hidden files through pager.
alias lx='ll -XB'        # Lists sorted by extension (GNU only).
alias lk='ll -Sr'        # Lists sorted by size, largest last.
alias lt='ll -tr'        # Lists sorted by date, most recent last.
alias lc='lt -c'         # Lists sorted by date, most recent last, shows change time.
alias lu='lt -u'         # Lists sorted by date, most recent last, shows access time.
alias sl='ls'            # I often screw this up.

# Grep
#
if zstyle -t ':prezto:module:utility:grep' color; then
  export GREP_COLOR='37;45'           # BSD.
  export GREP_COLORS="mt=$GREP_COLOR" # GNU.

  alias grep="${aliases[grep]:-grep} --color=auto"
fi

# Mac OS X Everywhere
#
if [[ "$OSTYPE" == darwin* ]]; then
  alias o='open'
elif [[ "$OSTYPE" == cygwin* ]]; then
  alias o='cygstart'
  alias pbcopy='tee > /dev/clipboard'
  alias pbpaste='cat /dev/clipboard'
else
  alias o='xdg-open'

  if (( $+commands[xclip] )); then
    alias pbcopy='xclip -selection clipboard -in'
    alias pbpaste='xclip -selection clipboard -out'
  elif (( $+commands[xsel] )); then
    alias pbcopy='xsel --clipboard --input'
    alias pbpaste='xsel --clipboard --output'
  fi
fi

# System arch
arch='$(uname -m)' && export arch
alias pbc='pbcopy'

alias pbp='pbpaste'

# File Download
#
if (( $+commands[curl] )); then
  alias get='curl --continue-at - --location --progress-bar --remote-name --remote-time'
elif (( $+commands[wget] )); then
  alias get='wget --continue --progress=bar --timestamping'
fi

# Resource Usage
#
alias df='df -kh'
alias du='du -kh'

if (( $+commands[htop] )); then
  alias top=htop
else
  if [[ "$OSTYPE" == (darwin*|*bsd*) ]]; then
    alias topc='top -o cpu'
    alias topm='top -o vsize'
  else
    alias topc='top -o %CPU'
    alias topm='top -o %MEM'
  fi
fi

# PS
alias psa='ps aux'
alias psg='ps aux | grep '
alias psr='ps aux | grep ruby'


# PS
#
alias psa='ps aux'
alias psg='ps aux | grep '
alias psr='ps aux | grep ruby'


#
# Miscellaneous
#

# pretty print path
function path(){
  old=$IFS
  IFS=:
  printf "%s\n" $PATH
  IFS=$old
}

# file empty directories
function empty() {
  [ -z $REPLY/*(DN[1]) ]
}

# Open Sublime Text Projects
function sp() {
  subl --command 'close_project' '$1'
  sleep 0.2
  subl --project '/Users/fr1v/Library/Application Support/Sublime Text 3/Packages/User/ProjectManager/$1.sublime-project'
}

# base utility function
function exists() {
  test -x "$(command -v "$1")"
}

# Serves a directory via HTTP.
alias http-serve='python -m SimpleHTTPServer'


#
# mkdcd
#

# Makes a directory and changes to it.
function mkdcd {
  [[ -n "$1" ]] && mkdir -p "$1" && builtin cd "$1"
}

# CDLS
# Changes to a directory and lists its contents.
function cdls {
  builtin cd "$argv[-1]" && ls "${(@)argv[1,-2]}"
}

# pushdls
function pushdls {
  builtin pushd "$argv[-1]" && ls "${(@)argv[1,-2]}"
}

# popdls: Pops an entry off the directory stack and lists its contents.
function popdls {
  builtin popd "$argv[-1]" && ls "${(@)argv[1,-2]}"
}

# slit: prints columns 1 2 3 ... n.
function slit {
  awk "{ print ${(j:,:):-\$${^@}} }"
}

# find-exec: finds files and executes a command on them.
function find-exec {
  find . -type f -iname "*${1:-}*" -exec "${2:-file}" '{}' \;
}

# PSU
function psu {
  ps -U "${1:-$LOGNAME}" -o 'pid,%cpu,%mem,command' "${(@)argv[2,-1]}"
}



#Here's a bit of Korn shell that converts the symbolic permissions produced
#by "ls -l" into octal, using only shell builtins.  How to create a script
#combining this with an "ls -l" is left as an exercise...
#
#
# Converted to Bash v2 syntax by Chet Ramey <chet@po.cwru.edu>
#
# usage: showperm modestring
#
# example: showperm '-rwsr-x--x'
#

function showperm() {
  [ -z "$1" ] && {
    echo "showperm: usage: showperm modestring" >&2
    exit 2
  }

  tmode="$1"

  typeset -i omode sbits
  typeset pmode

  # check for set-uid, etc. bits
  sbits=0
  case $tmode in
  ???[sS]*)       (( sbits += 8#4000 )) ;; # set-uid
  ??????[sSl]*)   (( sbits += 8#2000 )) ;; # set-gid or mand. lock
  ?????????[tT]*) (( sbits += 8#1000 )) ;; # sticky
  esac

  omode=0
  while :
  do
    tmode=${tmode#?}
    case $tmode in
    "")       break ;;
    [-STl]*)  (( omode *= 2 )) ;;
    [rwxst]*) (( omode = omode*2 + 1 )) ;;
    *)    echo "$0: first letter of \"$tmode\" is unrecognized" >&2
            (( omode *= 2 ))
            ;;
    esac
  done

  (( omode += sbits ))

  printf "0%o\n" $omode
}

zmodload zsh/zpty

function pty() {
  zpty pty-${UID} ${1+$@}
  if [[ ! -t 1 ]];then
    setopt local_traps
    trap '' INT
  fi
  zpty -r pty-${UID}
  zpty -d pty-${UID}
}

function ptyless() {
  pty $@ | less
} 

