# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/matteocodogno/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
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
# under VCS as dirty. This makes repository stas check for large repositories
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
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    docker
    docker-compose
    git
    nmap
    golang
    # gcloud
    kubectl
    terraform
    zsh-autosuggestions
    zsh-syntax-highlighting
		python
		pipenv
    z
)

source $ZSH/oh-my-zsh.sh

# User configuration
 
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='ewrap'
else
  export EDITOR='vim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

#--------------------- ALIAS
# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
alias settings='code ~/.zshrc'
alias reload='source ~/.zshrc'
alias lr='watch -d ls -l'
alias ip1="ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1'"
alias ip='curl ifconfig.co'

# Android
alias apkinstall='adb devices | tail -n +2 | cut -sf 1 | xargs -I X adb -s X install -r $1'
alias rmapp='adb devices | tail -n +2 | cut -sf 1 | xargs -I X adb -s X uninstall $1'
alias clearapp='adb devices | tail -n +2 | cut -sf 1 | xargs -I X adb -s X shell pm clear $1'
alias startintent='adb devices | tail -n +2 | cut -sf 1 | xargs -I X adb -s X shell am start $1'

# K8S
alias mongopod='kubectl run --rm -i --tty mongo-shell --image=mongo --restart=Never -- sh'
alias getippod='kubectl run --rm -i --tty get-ip-address --image=dwdraju/alpine-curl-jq --restart=Never'
alias busyboxpod='kubectl run --rm -i --tty busybox --image=busybox --restart=Never -- sh'
alias kustomizepod='kubectl run --rm -i --tty kustomize --image=k8s.gcr.io/kustomize/kustomize:v3.8.7 --restart=Never -- sh'
alias nodeltspod='kubectl run --rm -i --tty nodealpine --image=node:lts --restart=Never -- sh'
alias mavenjdk13pod='kubectl run --rm -i --tty mavenjdk13 --image=maven:3-jdk-13 --restart=Never -- sh'
alias postgrespod='kubectl run --rm -i --tty postgresql-client --image=postgres:12.7-alpine --restart=Never -- sh'

alias tpfsense='ssh -L 8377:localhost:8377 -f -C -N pfsense'

# GCP
alias gssh='gcloud compute ssh'

#--------------------- FUNCTION
function kdeljob() {
  k delete pods --force --grace-period 0 $(k get pods | awk 'match($1,/^runner-/) && match($5,/[0-9]+h/) {print $1}')
}

# kubectl command to delete the evicted pods
function kdelev() {
  kubectl get pods --all-namespaces | grep Evicted | awk '{print $2 " --namespace=" $1}' | xargs kubectl delete pod
}

function kdeler() {
  kubectl get pods --all-namespaces | grep Error | awk '{print $2 " --namespace=" $1}' | xargs kubectl delete pod
}

function kseal_create_secret() {
  echo -n $1 | kubectl create secret generic $2 --dry-run=client --from-file=$3=/dev/stdin -o yaml | kubeseal --format yaml > $4
}

function kseal_update_secret() {
  echo -n $1 | kubectl create secret generic mysecret --dry-run=client --from-file=$2=/dev/stdin -o yaml | kubeseal --format yaml --merge-into $3
}

function sp() {
    ( sudo lsof -n -i:$1 )
    #( sudo lsof -n -i:$1 | grep LISTEN )
}

function port_scanner() {
  first_port=${1:-1000}
  last_port=${2:-65535}

  for ((port=$first_port; port<=$last_port; port++))
  do
    lsof -n -i:$port &>/dev/null && echo $port busy || echo $port free
  done
}

function random_string() {
  local length=${1:-8}
  openssl rand -base64 $length
}

function weather() {
  local country=${1:=lugano}
  curl wttr.in/$country
}

function d() {
	dd=$(date +%Y%m%d%H%M%S)
	echo -n $dd
}

function dp() {
	d | pbcopy
}

docker-ip() {
  docker inspect --format '{{ .NetworkSettings.IPAddress }}' "$@"
}

function random_string() {
  local length=${1:-8}
  openssl rand -base64 $length
}

function renew_corner_apple_certificates() {
  bundle exec fastlane match import \
    --username dev@welld.ch \
    --git_url https://gitlab.welld.io/corner/certificates.git \
    --app_identifier ch.corner.bank.mobile.cornerbank,ch.corner.card.mobile.cornercard \
    --team_name "X6CYHFS2QL" \
    --type appstore
}

function terraform_remote_config() {
  terraform remote config \
    -backend
}

## connect to VPN
function vpn() {
    vpnName=$1
    case $vpnName in
    ovh)
      sudo openvpn --config /Users/matteocodogno/LAB/vpn/welld-ovh/welld-ovh.ovpn --daemon
    ;;
    siemens)
      sudo openvpn --config /Users/matteocodogno/LAB/vpn/siemens/pfSense-udp-1194-codo.ovpn --daemon
    ;;
    esac
}

#--------------------- EXPORT
export ANDROID_HOME=/Users/matteocodogno/Library/Android/sdk
export ANDROID_SDK_ROOT=$ANDROID_HOME
export ANDROID_PLATFORM_TOOL=$ANDROID_HOME/platform-tools/
export ANDROID_TOOLS=$ANDROID_HOME/tools/bin/
export ANDROID_EMULATOR=$ANDROID_HOME/emulator/
export GRAALVM_HOME=/Users/matteocodogno/.sdkman/candidates/java/19.3.1.r11-grl
export BREW=/usr/local/bin:/opt/local/sbin:/usr/local/sbin
export KREW=~/.krew/bin/
export NODE=/Users/matteocodogno/.fnm/current/bin/
export PYTHON=$(brew --prefix)/opt/python/libexec/bin/
export PIPENV_VENV_IN_PROJECT="enabled"
export PIPENV_VERBOSITY=-1
export SONAR_HOST_URL=https://sonar.welld.io
export UTILITIES=/Users/matteocodogno/bin/
export FABRIC=/Users/matteocodogno/bin/fabric
export CLOUDSDK_HOME=/Users/matteocodogno/google-cloud-sdk/
# export GOOGLE_APPLICATION_CREDENTIALS=/Users/matteocodogno/LAB/devops/gcp/service-accounts/groovy-form-266609-24d04c9557a5.json # packer
# export GOOGLE_APPLICATION_CREDENTIALS=/Users/matteocodogno/LAB/devops/gcp/service-accounts/groovy-form-266609-ba6e3a79d20d.json # flyingbull
export GOOGLE_APPLICATION_CREDENTIALS=/Users/matteocodogno/LAB/devops/gcp/service-accounts/groovy-form-266609-0bcdca4078e7.json # terraform
# export GOOGLE_APPLICATION_CREDENTIALS=/Users/matteocodogno/LAB/devops/gcp/service-accounts/groovy-form-266609-a285502b2616.json
export CLOUDSDK_PYTHON=python2
export KUBE_EDITOR="code -w"
export GOPATH=/Users/matteocodogno/go

export PATH=${GRAALVM_HOME}/bin:$GOPATH/bin:$ANDROID_TOOLS:$ANDROID_HOME:$ANDROID_EMULATOR:$ANDROID_PLATFORM_TOOL:$BREW:$KREW:$NODE:$PYTHON:$UTILITIES:$RUBY:$GEM:$FABRIC:$PATH

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

# https://github.com/pypa/pipenv/issues/4576#issuecomment-751639556
export SYSTEM_VERSION_COMPAT=1

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# fluxcd
command -v flux >/dev/null && . <(flux completion zsh) && compdef _flux flux

eval "$(fnm env)"

eval "$(rbenv init -)"

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ff00ff,bold,underline"
if [ -e /Users/matteocodogno/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/matteocodogno/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/matteocodogno/.sdkman"
[[ -s "/Users/matteocodogno/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/matteocodogno/.sdkman/bin/sdkman-init.sh"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/matteocodogno/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/matteocodogno/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/matteocodogno/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/matteocodogno/google-cloud-sdk/completion.zsh.inc'; fi
