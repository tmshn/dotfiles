# Completion補完
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _list _expand _complete _ignored _match _correct _approximate
zstyle ':completion:*' completions 1
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' file-sort access
zstyle ':completion:*' glob 1
zstyle ':completion:*' group-name ''
zstyle ':completion:*' ignore-parents parent pwd ..
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' menu select=2
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'l:|=* r:|=*' 'r:|[._-,;]=* r:|=*'
zstyle ':completion:*' match-original both
zstyle ':completion:*' max-errors 2
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' prompt '#%e'
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' substitute 1
zstyle ':completion:*' verbose true
zstyle ':completion:*' word true
# sudo の後ろでコマンド名を補完する
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                            /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin
# ps コマンドのプロセス名補完
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'

autoload -Uz compinit
compinit

setopt list_packed ## 保管結果をできるだけ詰める
setopt auto_menu ## タブによるファイルの順番切り替えをしない
setopt auto_param_keys ## カッコの対応などを自動的に補完
setopt auto_param_slash # ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt mark_dirs # ファイル名の展開でディレクトリにマッチした場


## 入力しているコマンド名が間違っている場合にもしかして：を出す。
setopt correct

# ビープを鳴らさない
setopt nobeep

## PCRE Regular Expression
## setopt re_match_pcre

## ^Dでログアウトしない。
setopt ignoreeof

## バックグラウンドジョブが終了したらすぐに知らせる。
setopt no_tify

## enable expansion like {a..x}
setopt brace_ccl


# ディレクトリ名を入力するだけでcdできるようにする
setopt auto_cd
# cd -[tab]で過去のディレクトリにひとっ飛びできるようにする
setopt auto_pushd
# 重複したディレクトリを追加しない
setopt pushd_ignore_dups

# Avoid "nomatch"
setopt nonomatch



# グローバルエイリアス
alias -g L='| less'
alias -g G='| grep'

# ヒストリの設定
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=$HISTSIZE
## 直前と同じコマンドをヒストリに追加しない
setopt hist_ignore_dups
## スペースで始まるコマンドラインはヒストリに追加しない。
setopt hist_ignore_space
## すぐにヒストリファイルに追記する。
setopt inc_append_history
## zshプロセス間でヒストリを共有する。
setopt share_history
## C-sでのヒストリ検索が潰されてしまうため、出力停止・開始用にC-s/C-qを使わない。
setopt no_flow_control
# ヒストリにhistoryコマンドを記録しない
setopt hist_no_store
# ヒストリを呼び出してから実行する間に一旦編集できる状態になる
setopt hist_verify
## 補完時にヒストリを自動的に展開する。
setopt hist_expand


# 日本語関係
export LANG=ja_JP.UTF-8
export LOCALE=ja_Jutf8
export LANGVAR=ja_JP.UTF-8
export GDM_LANG=ja_JP.UTF-8
setopt print_eight_bit
# SSHで接続した先で日本語が使えるようにする
export LC_CTYPE=ja_JP.UTF-8
export LC_ALL=ja_JP.UTF-8
# GCC in English
export LC_MESSAGES=C

# '#' 以降をコメントとして扱う
setopt interactive_comments

# -------------------------------------
# 環境変数
# -------------------------------------


# エディタ
export EDITOR='vim'
# ページャ
export MANPAGER='less -MN'
if type lv > /dev/null 2>&1; then
    export PAGER="lv"
else
    export PAGER="less -MN"
fi

if [ "$PAGER" = "lv" ]; then
    export LV="-c -l"
else
    alias lv="$PAGER"
fi


# -------------------------------------
# パス
# -------------------------------------

# 重複する要素を自動的に削除
typeset -U path cdpath fpath manpath

path=(
    $HOME/bin(N-/)
    /usr/local/bin(N-/)
    /usr/local/sbin(N-/)
    $path
)

# -------------------------------------
# プロンプト
# -------------------------------------

autoload -U promptinit; promptinit
autoload -Uz colors; colors
autoload -Uz vcs_info
autoload -Uz is-at-least
setopt prompt_subst

# -------------------------------------
# エイリアス
# -------------------------------------

# -n 行数表示, -I バイナリファイル無視, svn関係のファイルを無視
alias grep="grep --color -n -I --exclude='*.svn-*' --exclude='entries' --exclude='*/cache/*'"

# ls
alias ls="ls --color=auto --show-control-chars --classify --human-readable" # color for darwin

# grep
alias grep="grep --color=auto" # color for darwin

# tree
alias tree="tree -NC" # N: 文字化け対策, C:色をつける

# tar
alias untargz="tar xvf"
alias -s tar.gz=untargz
function targz() {
    target=${1%\/}
    tar czvf $target.tar.gz $target
}

# cd
function cd() {
    if builtin cd "$@"; then
        ls
        # ls　| head
    else
        return $?
    fi
}
# alias cd="builtin cd \"$@\" && ls;"

function mylatexmk() {
    sed -e "s/、/，/g" -e "s/。/．/g" -i *.tex
    latexmk $1
}

alias -s tex=mylatexmk
alias -s py=python
alias -s txt="head -20"


alias cyg-fast="cyg-fast -m http://ftp.jaist.ac.jp/pub/cygwin/"

# -------------------------------------
# キーバインド
# -------------------------------------

# vim風キーバインドにする
bindkey -v

function cdup() {
   echo
   cd ..
   zle reset-prompt
}
zle -N cdup
bindkey '^K' cdup

bindkey "^R" history-incremental-search-backward

stty stop undef



# exec 2>>( while read line; do echo -e "\e[33m$line\e[0m"; done )
# alias rederror_off="exec 2> /dev/tty"

RPROMPT="%{${fg[blue]}%}[%. %n@%m]%{${reset_color}%}"
case ${UID} in
0)
    ;;
    PROMPT="%(?.%{${fg_bold[green]}%}( '_'.%{${fg_bold[red]}%}(;>o<)) #  %{${reset_color}%}"
    PROMPT2="%(?.%{${fg_bold[green]}%}( '_'.%{${fg_bold[red]}%}(;>o<)) #> %{${reset_color}%}"
    SPROMPT="%{${fg_bold[green]}%}( '~') Did you mean '%{${reset_color}%}%r%{${fg[green]}%}'? [%UY%ues/%UN%uo/%UA%ubort/%UE%udit]$ %{${reset_color}%}"
*)
    PROMPT="%(?.%{${fg[green]}%}(*'_'.%{${fg[red]}%}(;>o<)) $  %{${reset_color}%}"
    PROMPT2="%(?.%{${fg[green]}%}(*'_'.%{${fg[red]}%}(;>o<)) $> %{${reset_color}%}"
    SPROMPT="%{${fg[green]}%}(*'~') Did you mean '%{${reset_color}%}%r%{${fg[green]}%}'? [%UY%ues/%UN%uo/%UA%ubort/%UE%udit]$ %{${reset_color}%}"
    ;;
esac
