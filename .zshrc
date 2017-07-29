#!/usr/local/bin/zsh

#####################################################################
# init
#####################################################################

# load zshrc for os type
case ${OSTYPE} in
    darwin*)
        [[ -f ~/.zshrc.osx ]] && source ~/.dotfiles/.zshrc.osx
        ;;
    linux-gnu*)
        [[ -f ~/.zshrc.linux ]] && source ~/.dotfiles/.zshrc.linux
        ;;
esac

#####################################################################
# path
#####################################################################

typeset -U path
path=(
# bin
/usr/local/bin(N-/)
/usr/bin(N-/)
/bin(N-/)
# sbin
/usr/local/sbin(N-/)
/usr/sbin(N-/)
/sbin(N-/)
#gnubin
/usr/local/opt/coreutils/libexec/gnubin(N-/)
# Java
$JAVA_HOME/bin(N-/)
# Cabal
$HOME/.cabal/bin(N-/)
# rvm(ruby version control)
$HOME/.rvm/bin(N-/)
# Go lang
$GOPATH/bin(N-/)
# pyenv
$PYENV_PATH/bin(N-/)
$PYENV_PATH/shims(N-/)
)

export MANPATH=/usr/local/opt/coreutils/libexec/gnuman:$MANPATH

# Sudo path
typeset -xT SUDO_PATH sudo_path
typeset -U sudo_path
sudo_path=({,/usr/pkg,/usr/local,/usr}/sbin(N-/))

#####################################################################
# auto complete
#####################################################################

# load command completion function
autoload -Uz compinit
# load compinit
compinit

# 補完方法毎にグループ化する。
# 補完方法の表示方法
#   %B...%b: 「...」を太字にする。
#   %d: 補完方法のラベル
zstyle ':completion:*' format '%B%d%b'
zstyle ':completion:*' group-name ''

# 補完侯補をメニューから選択する。
# select=2: 補完候補を一覧から選択する。
#           ただし、補完候補が2つ以上なければすぐに補完する。
zstyle ':completion:*:default' menu select=2

# 補完候補に色を付ける。
# "": 空文字列はデフォルト値を使うという意味。
zstyle ':completion:*:default' list-colors ""

# 補完候補がなければより曖昧に候補を探す。
# m:{a-z}={A-Z}: 小文字を大文字に変えたものでも補完する。
# r:|[._-]=*: 「.」「_」「-」の前にワイルドカード「*」があるものとして補完する。
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z} r:|[._-]=*'

# 補完方法の設定。指定した順番に実行する。
# _oldlist 前回の補完結果を再利用する。
# _complete: 補完する。
# _match: globを展開しないで候補の一覧から補完する。
# _history: ヒストリのコマンドも補完候補とする。
# _ignored: 補完候補にださないと指定したものも補完候補とする。
# _approximate: 似ている補完候補も補完候補とする。
# _prefix: カーソル以降を無視してカーソル位置までで補完する。
zstyle ':completion:*' completer \
    _oldlist _complete _match _history _ignored _approximate _prefix
# 補完候補をキャッシュする。
zstyle ':completion:*' use-cache yes
# 詳細な情報を使う。
zstyle ':completion:*' verbose yes
# sudo時にはsudo用のパスも使う。
zstyle ':completion:sudo:*' environ PATH="$SUDO_PATH:$PATH"

# カーソル位置で補完する。
setopt complete_in_word
# globを展開しないで候補の一覧から補完する。
setopt glob_complete
# 補完時にヒストリを自動的に展開する。
setopt hist_expand
# 補完候補がないときなどにビープ音を鳴らさない。
setopt no_beep
# 辞書順ではなく数字順に並べる。
setopt numeric_glob_sort
# Auto change direcotry
setopt auto_cd
# Saving cd history
setopt auto_pushd
# Teach error of command
setopt correct
# Compact list of complate result
setopt list_packed
# Beep sound off
setopt nolistbeep

#####################################################################
# prompt
#####################################################################
source ~/.dotfiles/zsh/prompt.zsh

#####################################################################
# keybind
#####################################################################
## vi bind
bindkey -v


#####################################################################
# history
#####################################################################
## Limit of history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# Share history
setopt hist_ignore_dups
setopt share_history

# Search history
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end


#####################################################################
# peco selection
#####################################################################
source ~/.dotfiles/zsh/peco.zsh


#####################################################################
# plugin manager
#####################################################################
source ~/.dotfiles/zsh/zplug.zsh


#####################################################################
# Init pyenv
#####################################################################
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
