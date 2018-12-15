HISTSIZE=1000000
SAVEHIST=100000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt EXTENDED_HISTORY
# HISTTIMEFORMAT="%d/%m/%y %T "
#unalias history
alias hist='fc -li 100'

# System env
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# export LESS="-F"

# Rust
# PATH=$PATH:$HOME/.cargo/bin

# Go
# export GOPATH=$HOME/Development
# export GOBIN=$GOPATH/bin
# PATH=$PATH:$GOPATH/bin

# v8
# PATH=$PATH:/Users/marcbachmann/Development/marcbachmann/depot_tools

# Yarn
# PATH=$PATH:$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin

# General aliases
alias top=htop

export HYPER_LIGHT_THEME='solarized-light'
export SUBLIME_LIGHT_COLOR_SCHEME='"Packages/Boxy Theme/schemes/Boxy Yesterday.tmTheme"'
export SUBLIME_LIGHT_THEME='"Boxy Yesterday.sublime-theme"'
export VSCODE_LIGHT_COLOR_THEME='Visual Studio Light'

export HYPER_DARK_THEME='material'
export SUBLIME_DARK_COLOR_SCHEME='"Packages/Boxy Theme/schemes/Boxy Ocean.tmTheme"'
export SUBLIME_DARK_THEME='"Boxy Ocean.sublime-theme"'
export VSCODE_DARK_COLOR_THEME='Monokai'

darkmode () {
  echo "setDarkMode($1)" | hs

  if [ "$1" = "true" ]; then
    local hyper_theme=$HYPER_DARK_THEME
    local sublime_color_scheme=$SUBLIME_DARK_COLOR_SCHEME
    local sublime_theme=$SUBLIME_DARK_THEME
    local vscode_theme=$VSCODE_DARK_COLOR_THEME
  else
    local hyper_theme=$HYPER_LIGHT_THEME
    local sublime_color_scheme=$SUBLIME_LIGHT_COLOR_SCHEME
    local sublime_theme=$SUBLIME_LIGHT_THEME
    local vscode_theme=$VSCODE_LIGHT_COLOR_THEME
  fi

  # Sublime
  sed -i '' "s|user:.*|user: $(jq -rc . < ~/.hyper_themes/$hyper_theme.json)|g" $HOME/.hyper.js;
  perl -i.bak -pe "s|\"color_scheme\".*|\"color_scheme\": $sublime_color_scheme,|g" "$HOME/Library/Application Support/Sublime Text 3/Packages/User/Preferences.sublime-settings"
  perl -i.bak -pe "s|\"theme\":.*|\"theme\": $sublime_theme,|g" "$HOME/Library/Application Support/Sublime Text 3/Packages/User/Preferences.sublime-settings"

  # VS Code
  perl -i.bak -pe "s|\"workbench\.colorTheme\":.*|\"workbench\.colorTheme\": \"$vscode_theme\",|g" "$HOME/Library/Application Support/Code/User/settings.json"
}

alias dark='darkmode true'
alias light='darkmode false'

alias help="tldr"

# Node
export NVM_DIR=$HOME/.nvm
# [ -s "$NVM_DIR/nvm.sh" ] && . $NVM_DIR/nvm.sh  # This loads nvm
export NVM_SYMLINK_CURRENT=true
PATH=$PATH:$NVM_DIR/current/bin
alias npme='PATH=$PATH:$(npm bin)'
alias npmo='npm install --offline'
alias npmclean="rm -Rf ./node_modules && npm install"
alias n='npm run'

nvm_switch_if_needed () {
  local NVM_RC_FILE=$(nvm_find_nvmrc)
  if [ $NVM_RC_FILE ]; then
    local DESIRED_VERSION=$(nvm_version $(cat $NVM_RC_FILE))
    [ "$(nvm_version_path $DESIRED_VERSION)/bin" == "$NVM_BIN" ] || nvm use $DESIRED_VERSION
  fi
}

cd () { builtin cd "$@"; nvm_switch_if_needed; }

meteo () { curl -4 "http://wttr.in/$(echo ${@:-zurich} | tr ' ' _)" }

# Docker
#export DOCKER_IP=$(ipconfig getifaddr en0)
#export DOCKER_IP="localhost"
# open-docker () { open "http://$DOCKER_IP:${1:-80}" }

alias dockerattach='screen ~/Library/Containers/com.docker.docker/Data/vms/0/tty'
alias dc='docker-compose'
alias dcr='docker-compose run'
alias dcu='docker-compose up'
alias dcps='docker-compose ps'
alias dcd='docker-compose down'

# Dev
export EDITOR='nano'
alias gcb='git checkout -b'
alias gp='git pull'
alias gpu='git push -u origin $(git rev-parse --abbrev-ref HEAD)'
alias gpuf='gpu -f'
alias gpom='git pull --rebase origin master'
alias gcom='git checkout master'
alias github='hub browse'
alias opentcp="lsof -iTCP -sTCP:LISTEN"

# git pull-request requires hub: https://github.com/github/hub
export git='hub'
function gpr () { hub pull-request -m "$1" | tail -1 | pbcopy; }
alias gpur='gpu && gpr'
alias gr='git reset --hard'
grh () { git reset --hard "HEAD~$1"; }

# commit & pull-request require gitbub-remote-commit: https://www.npmjs.com/package/github-remote-commit
alias commit='commit -t $(/usr/bin/security find-generic-password -s github-token -a $USER -w)'
alias pull-request='pull-request -t $(/usr/bin/security find-generic-password -s github-token -a $USER -w)'


# Livingdocs DroneCI
export DRONE_SERVER=https://ci.livingdocs.io

# TODO, support a secrets file or use $(/usr/bin/security find-generic-password -s drone-token -a $USER -w)
export DRONE_TOKEN=token

alias git-branch-cleanup='git branch --merged | grep -v "\*" | grep -v master | xargs -n 1 git branch -d'
alias prunelocal='git branch --merged | ~/Development/marcbachmann/trim | xargs -n 1 git branch -d'
alias pruneremotes='git gc --prune=now'
alias gco='git checkout'
alias gb='git branch'
# git config --global alias.prune '!prunelocal && pruneremotes'
alias cleargit='git clean -fdx'

alias cask='brew cask'
alias harmony='~/Development/marcbachmann/harmony/index.coffee'

# experimental
# alias s='subl .'
function s () { subl ${1:-./} }
alias t='./task.(js|coffee)'
alias task=t
alias g='grunt '
alias p='projects'
alias a='open -a'
alias gs='git status'
alias package='nano package.json'

# alias psql='docker run --rm postgres psql'
# alias pg_restore='docker run --rm postgres pg_restore'
# alias pg_dump='docker run --rm postgres pg_dump'
# alias dropdb='docker exec -it postgres dropdb -Upostgres'
# alias createdb='docker exec -it postgres createdb -Upostgres'
alias dockerip='docker inspect --format "{{ .NetworkSettings.IPAddress }}" '

# tmux, that's really, really advanced
alias tsplit='tmux split-window'
alias tsplith='tsplit && tmux select-layout even-horizontal'
alias ttail='tmux split -d tail -f'
alias texec='tmux split -d'
alias trun=texec

nodeexec () { node -e "console.log($(printf '%s' $@))"; }
alias neval=nodeexec

# that's experimental
alias ubuntu='docker run -it --rm -v $(pwd):/directory -w /directory ubuntu'
alias noded="docker run -it --rm -v $(pwd):/directory -w /directory node:4 node"
alias npmd="docker run -it --rm -v $(pwd):/directory -w /directory node:4 npm"
alias rund="docker run -it --rm -v $(pwd):/directory -w /directory node:4"
alias currentsha='git rev-parse --short HEAD'

# definitely do that
alias grunt="npme grunt"
alias npms="npm install --save"

alias markdown='cli-md'
export HISTTIMEFORMAT="%y-%m-%d %T "

# itunes aliases
# https://github.com/mischah/itunes-remote
alias playnow="osascript -e 'tell application \"iTunes\" to play'"
alias pausenow="osascript -e 'tell application \"iTunes\" to pause'"
alias next="osascript -e 'tell application \"iTunes\" to next track'"
alias previous="osascript -e 'tell application \"iTunes\" to previous track'"


alias betwixtenable='sudo networksetup -setsecurewebproxy Wi-Fi localhost 8006 off && sudo networksetup -setwebproxy Wi-Fi localhost 8008 off'
alias betwixtdisable='sudo networksetup -setwebproxystate Wi-Fi off && sudo networksetup -setsecurewebproxystate Wi-Fi off'

# general purpose
# seq 10 | parallel --jobs 1 curl -s --globoff "localhost:3001/commands/CreateUser?aggregateId=test-{}&data[email]=user-{}@upfront.io&data[name]=user-{}" -w "\n"

show-desktop () {
  local show=true
  if [ "$1" == "false" ]; then show=false; fi
  defaults write com.apple.finder CreateDesktop $show
  killall Finder
}

alias hide-desktop='show-desktop false'

stashgrep() {
  IFS=$'\n'
  for i in `git stash list --format="%gd"`; do
    git stash show -p $i | grep -H --label="$i" "$1"
  done
}

function perf {
  curl -o /dev/null -s -w "%{time_connect} + %{time_starttransfer} = %{time_total}\n" "$1"
}

popline () {
  sed -i '' -e '$ d' $1
}

function ensure-global-module {
  /usr/bin/which "${2:-$1}" &> /dev/null || npm install -g $1
}

function execute-global {
  ensure-global-module $1 && command $@
}

alias http-server="ensure-global-module spa-http-server http-server && command http-server"
alias pophost="popline ~/.ssh/known_hosts"
alias gti="git"
alias got="git"

# brew install trash
alias rm="trash"
alias localtunnel="ensure-global-module localtunnel lt && command lt"
alias readme="execute-global readme"
alias npmoutdated="execute-global npmoutdated"
alias gb='for k in `git branch | perl -pe s/^..//`; do echo -e `git show --pretty=format:"%Cgreen%ci %Cblue%cr%Creset" $k -- | head -n 1`\\t$k; done | sort -r'
# alias wombat="ensure-global-module wombat && command wombat"
alias nodemon="execute-global nodemon"
alias autocannon="execute-global autocannon"
alias enterdocker="docker run --rm -it --privileged --pid=host walkerlee/nsenter -t 1 -m -u -i -n sh"
alias 0x="execute-global 0x"
alias now="execute-global now"
alias nativetime="/usr/bin/time"
alias browserify="execute-global browserify"
alias uglifyjs="execute-global uglifyjs"
alias exposify="execute-global exposify"
alias standard="execute-global standard"

function sigstop () { kill -SIGSTOP `pgrep $1`; }
function sigcont () { kill -SIGCONT `pgrep $1`; }

function mb () {
  local dir=~/Development/marcbachmann
  [ -d "$dir/marcbachmann-$1" ] && cd "$dir/marcbachmann-$1" && return
  [ -d "$dir/$1" ] && cd "$dir/$1" && return
  echo "Failed to go to $dir/$1"
}

function li () {
  local dir=~/Development/livingdocsIO
  [ -d "$dir/livingdocs-$1/master" ] && cd "$dir/livingdocs-$1/master" && return
  [ -d "$dir/$1/master" ] && cd "$dir/$1/master" && return
  [ -d "$dir/livingdocs-$1" ] && cd "$dir/livingdocs-$1" && return
  [ -d "$dir/$1" ] && cd "$dir/$1" && return
  echo "Failed to go to $dir/$1"
}

function nzz () {
  local dir=~/Development/nzzdev
  [ -d "$dir/livingdocs-$1" ] && cd "$dir/livingdocs-$1" && return
  [ -d "$dir/$1" ] && cd "$dir/$1" && return
  echo "Failed to go to $dir/$1"
}

function announce-greenkeeper () {
  curl -H "Content-Type: application/json" -X POST -d "{\"name\":\"$1\",\"version\":\"$2\"}" https://api.greenkeeper.io/webhooks/npm
}

function decaf () {
  execute-global decaffeinate --disable-suggestion-comment --disable-babel-constructor-workaround $1 && execute-global eslint --fix $(echo $1 | sed 's/\.coffee/\.js/');
}

function dc_trace_cmd () {
  local parent=`docker inspect -f '{{ .Parent }}' $1` 2>/dev/null
  declare -i level=$2
  echo ${level}: `docker inspect -f '{{ .ContainerConfig.Cmd }}' $1 2>/dev/null`
  level=level+1
  if [ "${parent}" != "" ]; then
    echo ${level}: $parent
    dc_trace_cmd $parent $level
  fi
}

export PATH
