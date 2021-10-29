# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/jmoses/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="dracula"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions asdf)

asdf_dir=$(brew --prefix asdf)

# Autocomplete with files if nothing known
zstyle :completion::::: completer _complete _files

source $ZSH/oh-my-zsh.sh
source /usr/local/opt/kube-ps1/share/kube-ps1.sh

NEWLINE=$'\n'

PROMPT='%(?:%F{green}:%F{red})${DRACULA_ARROW_ICON}%F{green}%B$(dracula_time_segment) %F{magenta}%B$(dracula_context)%F{blue}%B%c $DRACULA_GIT_STATUS%f%b $(kube_ps1)${NEWLINE}> '

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

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#alias g=git
alias per="pipenv run"
alias perp="pipenv run python"
alias gaucmsg="git add --update && git commit -m"
alias glinted="gau && gcn! && ggp"
alias gdmb!='gco $(git_main_branch) && git-dmb --effort=3'
alias grbom='gfo && git rebase origin/$(git_main_branch)'
alias kc=kubectl
alias ldc=logdnactl
export EDITOR=vim
export RIPGREP_CONFIG_PATH=~/.ripgreprc
export LOGDNA_WORKDIR=~/dev/logdna

[ -f ~/.zsh.secrets ] && source ~/.zsh.secrets


PATH=~/.bin/:${HOME}/.krew/bin:$PATH

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
source /usr/local/ibmcloud/autocomplete/zsh_autocomplete

eval $(thefuck --alias)

setopt hist_find_no_dups
bindkey "${key[Up]}" up-line-or-local-history
bindkey "${key[Down]}" down-line-or-local-history

up-line-or-local-history() {
    zle set-local-history 1
    zle up-line-or-history
    zle set-local-history 0
}
zle -N up-line-or-local-history
down-line-or-local-history() {
    zle set-local-history 1
    zle down-line-or-history
    zle set-local-history 0
}
zle -N down-line-or-local-history

function repo() {
    if [ ! -z $1 ]; then
        if [ -d $LOGDNA_WORKDIR/$1 ]; then
            r=$1
        else
            r=$(ls $LOGDNA_WORKDIR | fzf --query "'${1}" --select-1)
        fi
    else
        r=$(ls $LOGDNA_WORKDIR | fzf)
    fi
    if [ -z $r ] ; then
        echo "Nothing selected"
    else
        cd $LOGDNA_WORKDIR/$r
        if [ ! -z $TMUX ]; then
            tmux rename-window $( echo $r | sed s/'\/'//)
        fi
    fi
}
