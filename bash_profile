# vim: set syntax=sh:

# shopts

shopt -s histappend
ulimit -n 8192

# Vars
export EDITOR='vim'
export GEMEDITOR='mvim'
export HISTCONTROL='erasedups'
export CLICOLOR=true
export USE_BUNDLER=try
export LESS='-R'
export CC='/usr/bin/gcc'
export PROMPT_DIRTRIM=2
export GREP_OPTIONS='--color=always'
#export PROMPT_COMMAND='history -a; history -n'

# RVM
#[[ -s "/Users/jmoses/.rvm/scripts/rvm" ]] && source "/Users/jmoses/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
export PATH="/usr/local/bin:/usr/local/sbin:/Users/jmoses/.bin:$PATH"

# Datastax
export PATH="/Users/jmoses/dev/datastax/dsc-cassandra-2.1.0/tools/bin:/Users/jmoses/dev/datastax/automaton/bin:$PATH"
export PYTHONPATH="/Users/jmoses/dev/datastax/automaton/:$PYTHONPATH"


ctool_complete=/Users/jmoses/dev/datastax/automaton/bashcomplete/ctool.bash_complete
[ -f $ctool_complete ] && . $ctool_complete

perlbrew=/Users/jmoses/perl5/perlbrew/etc/bashrc
[ -f $perlbrew ] && . $perlbrew

[ -f $HOME/.tokens ] && . $HOME/.tokens
# Prompt
#export PS1='\[\033[G\]\[\033[01;32m\]\u\[\033[00m\][`~/.rvm/bin/rvm-prompt v g`]\[\033[01;36m\]\w\[\033[00m\]\$ '
export PS1='\[\033[G\]\[\033[01;32m\]\u\[\033[00m\]\[\033[01;36m\]\w\[\033[00m\]\$ '

#if [ -f "$(brew --prefix bash-git-prompt)/share/gitprompt.sh" ]; then
#  GIT_PROMPT_THEME=Default
#  source "$(brew --prefix bash-git-prompt)/share/gitprompt.sh"
#fi

if [ -f ~/bin/real_python_exit.py ]; then
  export PYTHONSTARTUP=~/bin/real_python_exit.py
fi

#Aliases
alias login='echo "Stop that."'
alias g='git'
alias ctags="`brew --prefix`/bin/ctags"
alias be="bundle exec"
alias ignore="IGNORE_BRANCH_DB=yes "

# hosts
pi='pi@192.168.1.108'
imac=192.168.1.151
vpn=192.168.1.117

function c {
  slogin ${!1}
}


function opsc_api {
  ip=$(ctool info --hosts $1)

  curl http://$ip:8888/$2
}

export BOOKMARK_FILE="$HOME/.my-stash/bookmarks"
function add_bookmark {
  target=$1
  if [ "${target}x" == "x" ] ; then
    target=`pwd`
  fi

  echo $target >> $BOOKMARK_FILE

  update_bookmarks
}

function update_bookmarks {
  cat $BOOKMARK_FILE | sort | uniq | tee $BOOKMARK_FILE > /dev/null
}

unalias cdg 2> /dev/null
cdg() {
   local dest_dir=$(cat $BOOKMARK_FILE | fzf -1 -q $1)
   if [[ $dest_dir != '' ]]; then
      cd "$dest_dir"
   fi
}
export -f cdg > /dev/null

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

