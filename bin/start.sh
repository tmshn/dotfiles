#!/usr/bin/env bash

: Shell options && {
    set -o nounset
    set -o errexit
    # set -o pipefail
    # set -o xtrace
}

: Parse target && {
    if [[ "${1:-}" =~ ^(.+://)?(.+)$ ]]; then
        readonly schema=${BASH_REMATCH[1]:-https://}
        target=$(echo "${BASH_REMATCH[2]}" | sed -E 's#(\.git)?/?$##g')
        readonly target
        abspath="$(ghq root)/${target}"
        readonly abspath
    else
        "We need an argument!"
        exit 1
    fi
}

: Find current session && {
    current_pane=$(
        tmux list-panes -s -F '#{pane_id} #{pane_current_path}' \
        | grep -E " ${abspath}($|/)" \
        | sort \
        | head -n 1 \
        | cut -d' ' -f1
    )
    readonly current_pane
    if [[ -n "${current_pane}" ]]; then
        echo "You already have a pane for this; let's go there!" >&2
        tmux switch-client -t "${current_pane}"
        echo '.'
        exit
    fi
}

: Prepare directory && {
    if [[ -z "$(ghq list -e "${target}")" ]]; then
        ghq get "${schema}${target}" >&2
        (
            cd "${abspath}"
            if [[ "${target}" =~ github.com && ! "${target}" =~ github.com/tmshn/ ]]; then
                hub fork --remote-name myorigin >&2 || :
            fi
        )
    fi
}

: Display directory && {
    echo "${abspath}"
}
