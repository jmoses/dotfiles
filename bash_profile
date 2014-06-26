# Vars
export EDITOR='vim'
export GEMEDITOR='mvim'
export HISTCONTROL='erasedups'
export CLICOLOR=true
export USE_BUNDLER=try
export LESS='-R'
export CC='/usr/bin/gcc-4.2'

# Prompt
export PS1='\[\033[G\]\[\033[01;32m\]\u\[\033[00m\][`~/.rvm/bin/rvm-prompt v g`]\[\033[01;36m\]\w\[\033[00m\]\$ '

#Aliases
alias login='echo "Stop that."'
alias g='git'
alias ctags="`brew --prefix`/bin/ctags"
alias be="bundle exec"
alias ignore="IGNORE_BRANCH_DB=yes "


# RVM
[[ -s "/Users/jmoses/.rvm/scripts/rvm" ]] && source "/Users/jmoses/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
export PATH="/usr/local/bin:/usr/local/heroku/bin:/Users/jmoses/bin:$PATH"

source ~/perl5/perlbrew/etc/bashrc
