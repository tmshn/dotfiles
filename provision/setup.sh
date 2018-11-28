#!/bin/sh

set -o xtrace

# Install ansible
if ! type ansible > /dev/null; then
    xcode-select --install
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew install ansible
fi

if [ "${1}" = '-n' ]; then
    opt='--check'
fi

pushd $(dirname $0)
    ansible-playbook -v --diff --ask-become-pass -i localhost, playbook.yaml ${opt}
popd
