# shopts

shopt -s histappend

# Vars
export EDITOR='vim'
export GEMEDITOR='mvim'
export HISTCONTROL='erasedups'
export CLICOLOR=true
export USE_BUNDLER=try
export LESS='-R'
export CC='/usr/bin/gcc-4.2'
export PROMPT_COMMAND='history -a; history -n'

# RVM
#[[ -s "/Users/jmoses/.rvm/scripts/rvm" ]] && source "/Users/jmoses/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
export PATH="/usr/local/bin:/Users/jmoses/bin:$PATH"

# Datastax
export PATH="/Users/jmoses/dev/datastax/dsc-cassandra-2.1.0/tools/bin:/Users/jmoses/dev/datastax/automaton/bin:$PATH"
export PYTHONPATH="/Users/jmoses/dev/datastax/automaton/:$PYTHONPATH"
. /Users/jmoses/dev/datastax/automaton/bashcomplete/ctool.bash_complete

source ~/perl5/perlbrew/etc/bashrc
# Prompt
#export PS1='\[\033[G\]\[\033[01;32m\]\u\[\033[00m\][`~/.rvm/bin/rvm-prompt v g`]\[\033[01;36m\]\w\[\033[00m\]\$ '
export PS1='\[\033[G\]\[\033[01;32m\]\u\[\033[00m\]\[\033[01;36m\]\w\[\033[00m\]\$ '

#Aliases
alias login='echo "Stop that."'
alias g='git'
alias ctags="`brew --prefix`/bin/ctags"
alias be="bundle exec"
alias ignore="IGNORE_BRANCH_DB=yes "

function opsc_open {
  open "http://$(ctool info $1 --hosts):8888/"
}

function opsc_branch {
  echo "Installing $2 on $1"
  ctool install -b $2 $1 opscenter
  echo "Building agents"
  printf '{"operation":"build_agent_packages", "script":"build-agent-packages.sh"}' | ctool module $1 0 opscenter.py
  #echo "Building static assets"
  #ctool run $1 0 "cd ripcord &&"
  echo "Starting"
  ctool start $1 opscenter
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


