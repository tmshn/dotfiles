#!/bin/sh

set -o xtrace

# Install ansible
if ! type ansible > /dev/null; then
    xcode-select --install
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew install ansible
fi

opt=''
while [ $# -gt 0 ]; do
    case "${1}" in
        --dryrun ) opt="${opt} --check";;
        --only   ) shift && opt="${opt} --tags ${1}";;
        --except ) shift && opt="${opt} --skip-tags ${1}";;
        *        ) echo "Unknown option '${1}'" >&2; exit 1;;
    esac
    shift
done

pushd $(dirname $0)
    ansible-playbook -v --diff --ask-become-pass -i localhost, playbook.yaml ${opt}
popd
