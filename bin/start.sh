#!/usr/bin/env bash

: Shell options && {
    set -o nounset
    set -o errexit
    # set -o pipefail
    # set -o xtrace
}

: Parse target && {
    if [[ "${1:?}" =~ ^(.+://)?(.*)$ ]]; then
        readonly schema=${BASH_REMATCH[1]:-https://}
        readonly target="${BASH_REMATCH[2]:?}"
        readonly work=$(test "${target%%/*}" = work && echo yes || echo no)
        readonly abspath="$(ghq root)/${target}"
    else
        # Never fallback here, but just in case...
        exit 1
    fi
}

: Find current session && {
    readonly current_pane=$(
        tmux list-panes -s -F '#{pane_id} #{pane_current_path}' \
        | grep -E " ${abspath}($|/)" \
        | sort \
        | head -n 1 \
        | cut -d' ' -f1
    )
    if [[ -n "${current_pane}" ]]; then
        echo "You already have a pane for this; let's go there!" >&2
        tmux switch-client -t "${current_pane}"
        echo '.'
        exit
    fi
}

: Prepare directory && {
    if [[ "${work}" = yes ]]; then
        mkdir -p "${abspath}"
    elif [[ -z "$(ghq list -e "${target}")" ]]; then
        ghq get "${schema}${target}" >&2
        (
            cd "${abspath}"
            if [[ "${abspath}" =~ github.com ]]; then
                hub fork --remote-name myorigin >&2 || :
            fi
        )
    fi
}

: Display directory && {
    echo "${abspath}"
}
