#!/usr/bin/env bash

set -e
set -x
shopt -s dotglob

readonly name="KWSys"
readonly ownership="KWSys Upstream <kwrobot@kitware.com>"
readonly subtree="Modules/ThirdParty/KWSys/src/KWSys"
readonly repo="https://gitlab.kitware.com/utils/kwsys.git"
readonly tag="master"
readonly shortlog=true
readonly paths="
"

extract_source () {
    git_archive
    sed -i -e '/import off/,/import on/d' "$extractdir/$name-reduced/.gitattributes"
}

. "${BASH_SOURCE%/*}/../../../Utilities/Maintenance/update-third-party.bash"
