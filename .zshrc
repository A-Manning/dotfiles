# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$HOME/.local/bin:$HOME/.cabal/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes

# Need to set a symlink in $ZSH/custom/themes called theme.zsh-theme
ZSH_THEME="theme"

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=1

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  colored-man-pages
  cp
  completions
  extract
  git
  history
  #mouse
  nuget
  per-directory-history
)

source $ZSH/oh-my-zsh.sh

# load completions
autoload -U compinit && compinit

# mouse on
# zle-toggle-mouse

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# apt
alias ad='sudo apt update'
alias ag='sudo apt upgrade'
alias ai='sudo apt install'
alias alu='apt list --upgradable'

# atom
alias ab='atom-beta -n'
alias ab.='atom-beta -n .'
alias abe='atom-beta' #use existing instance

# chmod
alias chmodr='chmod +r'
alias chmodw='chmod +w'
alias chmodx='chmod +x'

# cp
alias cpr='cp -r'

# dpkg
alias dpkgi='sudo dpkg -i'

# fsharpi
alias fsi='fsharpi'

# fstar
alias fstar='fstar.exe'

# git
alias gaa='git add -A' #git add all tracked and untracked files
alias gat='git add -u' #git add all tracked files
alias gc='git commit'
alias gcm='git commit -m'
alias gdiff='git diff'
alias glf='git ls-files' #git list files
alias glfd='git ls-files --deleted' #gld deleted
alias glfm='git ls-files --modified' #glf modified
alias glfu='git ls-files --others --exclude-standard' #glf untracked
alias gpull='git pull'
alias gpush='git push'
alias gstat='git status'

# less
alias less='less -N'

# msbuild
alias msbd='msbuild /p:Configuration=Debug'
alias msbr='msbuild /p:Configuration=Release'

# nano
alias nzsh='nano ~/.zshrc'

# ocamlformat
alias ofi='ocamlformat --inplace'

# opam
alias od='opam update'
alias og='opam upgrade'

# paket
alias paket='.paket/paket.exe'
alias paketx='chmod +x .paket/paket.exe'
alias paketbs='mv .paket/paket.bootstrapper.exe .paket/paket.exe'

# ps
alias psg='ps aux | head -1; ps aux | grep'

# r
# This command is dangerous! It has no manpage and does not appear as an alias, so it should be unset
alias r='echo "This command has been unset in \`~/.zshrc\`."'

# reset
alias rst="reset"

# rm
alias rmr='rm -r'

# source
alias szsh="source ~/.zshrc"

# thanks
alias thanks="echo \"You're welcome!\""

# -is eval to start zsh with a command
if [[ $1 == eval ]]
then
    "$@"
set --
fi

# Disable dotnet telemetry
DOTNET_CLI_TELEMETRY_OPTOUT=true

# opam configuration
test -r $HOME/.opam/opam-init/init.zsh && . $HOME/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

# Don't write command history if there is a preceding space in the command
setopt hist_ignore_space

# nvm config
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
