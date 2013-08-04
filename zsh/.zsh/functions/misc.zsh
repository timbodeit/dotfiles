function cdmkdir {
  if mkdir $1; then
    cd $1
  fi
}

function extract() {
  if [ -f $1 ]; then
    case $1 in
      *.tar.bz2)        tar xvjf $1     ;;
      *.tar.gz)         tar xzvf $1     ;;
      *.bz2)            bunzip2 $1      ;;
      *.rar)            unrar x $1       ;;
      *.gz)             gunzip $1       ;;
      *.tar)            tar xvf $1      ;;
      *.tbz2)           tar xvjf $1     ;;
      *.tgz)            tar xzvf $1     ;;
      *.zip)            unzip $1        ;;
      *.Z)              uncompress $1   ;;
      *.7z)             7z x $1         ;;
      *)                echo "dunno how to extract '$1'..." ;;
    esac
  else
    echo "'$1' is not a valid file!"
  fi
}

function cd() {
  [[ -z "$1" ]] && builtin cd && return
  local dest="$1"
  [[ -f "$dest" ]] && dest="$(dirname $dest)"
  builtin cd $dest
}

# Hook function
function chpwd() {
  [[ -t 1 ]] || return
  command ls -a
}

function minimalPrompt() {
  PS1="$ "
  clear
}

function findhere() {
  local what="$1"
  shift
  find . -iname "*${what}*" $*
}

function sgrep() {
  cat | perl -ne "print \"\$1\\n\" if $1"
}

function pdfmerge() {
  command gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=finished.pdf $*
}

function pdfgrayscale() {
  command gs -sOutputFile=grayscale.pdf -sDEVICE=pdfwrite -sColorConversionStrategy=Gray -dProcessColorModel=/DeviceGray -dCompatibilityLevel=1.4 -dNOPAUSE -dBATCH $*

}

function df() {
  if [[ -z "$*" ]]; then
    command df -h | column -t
  else
    command df $*
  fi
}

function spectrum_ls() {
  for code in {000..255}; do
    print -P -- "$code: %F{$code}Test%f"
  done
}

# Interactively rename files
function imv() {
  local src dst
  for src; do
    [[ -e $src ]] || { print -u2 "$src does not exist"; continue }
    dst=$src
    vared dst
    [[ $src != $dst ]] && mkdir -p $dst:h && mv -n $src $dst
  done
}

function tm() {
  tmux-layout $* 2>/dev/null ||
  tmux-layout $HOME/.tmux-layouts/$1.json 2>/dev/null ||
  tmux $*
}

function lineSelect() {
  local -a lines
  local i=0
  local no

  cat | while read line; do
    lines=($lines $line)
    echo "$i $line"
    (( i += 1 ))
  done >&2
  echo -n "Line: " >&2
  read no </dev/tty
  echo -n "${lines[$no]}"
}

# Less
LESSOPEN="|/usr/bin/lesspipe.sh %s"
export LESSOPEN

