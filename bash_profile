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
#export PROMPT_COMMAND='history -a; history -n'

# RVM
#[[ -s "/Users/jmoses/.rvm/scripts/rvm" ]] && source "/Users/jmoses/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
export PATH="/usr/local/bin:/Users/jmoses/bin:$PATH"

# Datastax
export PATH="/Users/jmoses/dev/datastax/dsc-cassandra-2.1.0/tools/bin:/Users/jmoses/dev/datastax/automaton/bin:$PATH"
export PYTHONPATH="/Users/jmoses/dev/datastax/automaton/:$PYTHONPATH"


ctool_complete=/Users/jmoses/dev/datastax/automaton/bashcomplete/ctool.bash_complete
[ -f $ctool_complete ] && . $ctool_complete

perlbrew=/Users/jmoses/perl5/perlbrew/etc/bashrc
[ -f $perlbrew ] && . $perlbrew
# Prompt
#export PS1='\[\033[G\]\[\033[01;32m\]\u\[\033[00m\][`~/.rvm/bin/rvm-prompt v g`]\[\033[01;36m\]\w\[\033[00m\]\$ '
export PS1='\[\033[G\]\[\033[01;32m\]\u\[\033[00m\]\[\033[01;36m\]\w\[\033[00m\]\$ '

#if [ -f "$(brew --prefix bash-git-prompt)/share/gitprompt.sh" ]; then
#  GIT_PROMPT_THEME=Default
#  source "$(brew --prefix bash-git-prompt)/share/gitprompt.sh"
#fi

#Aliases
alias login='echo "Stop that."'
alias g='git'
alias ctags="`brew --prefix`/bin/ctags"
alias be="bundle exec"
alias ignore="IGNORE_BRANCH_DB=yes "

# hosts
pi='pi@192.168.1.108'
imac=192.168.1.151
dl=192.168.1.117

function c {
  slogin ${!1}
}

function opsc_open {
  open "http://$(ctool info $1 --hosts):8888/"
}

function opsc_branch {
  echo "Installing $2 on $1"
  ctool reset $1
  ctool install -b $2 $1 opscenter
  echo "Building agents"
  printf '{"operation":"build_agent_packages", "script":"build-agent-packages.sh"}' | ctool module $1 0 opscenter.py
  #echo "Building static assets"
  #ctool run $1 0 "cd ripcord &&"
  echo "Starting"
  ctool start $1 opscenter
}

function dse_install {
  echo "Installing DSE $2 on $1"
  ctool install -v $2 $1 enterprise
  ctool start $1 enterprise
}

function opsc_api {
  ip=$(ctool info --hosts $1)

  curl http://$ip:8888/$2
}

function opsc_restart {
  ctool stop $1 opscenter
  ctool start $1 opscenter
}

function encode_pattern {
  rate=$1
  pattern=$2
  output=$3

  # Seems like motion can't output fast enough on the pi,
  # so we're getting frame drops, which is mostly fine but
  # it would be great if the previous frame would dupe across
  # the gap.  Maybe not specifiying the output framerate?

  ffmpeg -framerate $rate -pattern_type glob -i "$pattern" -c:v libx264 -pix_fmt yuv420p -r 30 $output

}

function flip_images {
  # Be nice if this used all my cores
  mogrify -rotate 180 $*
}

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

