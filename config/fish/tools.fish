function addpath
    set -l uniq
    for arg in $argv
        if [ ! -d "$arg" ]
            echo "'$arg' is not a valid directory; ignored"
            continue
        end
        set -l new_item (realpath "$arg")
        set -l old_index (contains --index "$new_item" $PATH)
        if [ -n "$old_index" ]
            set -e PATH[$old_index]
        end
        set -gx PATH "$new_item" $PATH
    end
end


addpath "$XDG_CONFIG_HOME/../bin"
addpath "$HOME/bin"

# ==========================================================
# Aliases/tools
# ----------------------------------------------------------
alias ssh 'set -l SHELL /bin/sh; command ssh'
alias scp 'set -l SHELL /bin/sh; command scp'

set -x LESS '--tabs=4 --RAW-CONTROL-CHARS --ignore-case --no-init --quit-if-one-screen --quit-on-intr --LONG-PROMPT --hilite-search'

set -x CLOUDSDK_PYTHON python3

set -x FZF_DEFAULT_OPTS '--border --cycle --height 40% --layout reverse --exit-0 --select-1 --marker="✓ "'

alias ll 'exa --git --long --group --classify --header --tree --level=1 --created --modified --accessed --time-style=iso'
alias tree 'exa --tree'

function __label_candidate
    sort -u | sed -E "s/\$/\x00$argv/"
end

function __my_complete
    set -l command (commandline -po)
    set -l query (commandline -t)
    set -l result (
        begin
            # Custom completion for each command
            switch "$command[1]"
                case cd pushd
                    ghq list --full-path | sed -E "s#^$HOME#~#" | __label_candidate GHQ
                    git rev-parse --show-cdup 2> /dev/null      | __label_candidate Repo root
                    echo -s $dirprev\n | sed -E "s#^$HOME#~#"   | __label_candidate History
                    # Default completion
                    complete -C(commandline -p) | sort -u | tr '\t' '\0' | __label_candidate ' (completion)'
                case start
                    ghq list
                case docker
                    docker image ls --format='{{ .Repository }}:{{ .Tag }}\t{{ .Size }} created {{ .CreatedSince }}' | tr '\t' '\0'
                    # Default completion
                    complete -C(commandline -p) | sort -u | tr '\t' '\0' | __label_candidate ' (completion)'
            end
        end | sed -E '/^(\x00|$)/d; s/\x00(.*)/\x00\t\x1B[36m\1\x1B[0m/' \
            | fzf --multi --query="$query" --ansi \
            | cut -d '' -f 1 \
            | string escape --no-quoted \
            | sed -E 's/^\\\\~/~/'
    )
    if [ (count $result) -gt 0 ]
        commandline -t "$result"
    end
    commandline -f repaint
end

function fzf_complete -d 'fzf-version of complete'
    set -l choosen (complete -C | sed -E 's/(\t.*)/\x1B[36m\1\x1B[0m/' \
                                | fzf --ansi --exit-0 --select-1 \
                                | cut -d \t -f 1 \
                                | string escape --no-quoted \
                                | sed -E 's/^\\\\~/~/')
    if [ (count $choosen) -gt 0 ]
        commandline -t "$choosen"
    end
    commandline -f repaint
end

function fish_user_key_bindings
    bind -k btab __my_complete
end

function start
    cd (start.sh $argv)
end

# ==========================================================
# Languages
# ----------------------------------------------------------
# Go
set -x GOPATH $HOME
# ref:
# - https://github.com/syndbg/goenv/pull/70
# - https://github.com/syndbg/goenv/issues/72
# set -x GOENV_DISABLE_GOPATH 1
# set -x GOENV_DISABLE_GOROOT 1

# Anyenv
addpath "$HOME/.anyenv/bin"
status --is-interactive; and source (anyenv init -|psub)

# Pipenv
set -x PIPENV_VENV_IN_PROJECT true

# Python Poetry
addpath "$HOME/.poetry/bin"

# Rust
addpath "$HOME/.cargo/bin"

# Bundle
set -x BUNDLE_PATH "vendor/bundle"

# Jsonnet
set -x JSONNET_PATH "$HOME/src/github.com/grafana/grafonnet-lib/grafonnet/"

# krew (kubectl plugin manager)
addpath "$HOME/.krew/bin"
# ==========================================================
# Brewed tools
# ----------------------------------------------------------
# Openssl
addpath "/usr/local/opt/openssl/bin"

# GNU compaliants
for t in coreutils findutils gnu-sed gnu-tar gnu-time grep
    addpath "/usr/local/opt/$t/libexec/gnubin"
    set -x MANPATH "/usr/local/opt/$t/libexec/gnuman" $MANPATH
end
