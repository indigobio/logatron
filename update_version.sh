#!/bin/bash -e

#This script is used during the release process. It is not intended to be ran manually.

VERSION="$1"
VERSION="${VERSION:?"must provide version as first parameter"}"
SCRIPT_DIR="$(cd "$(dirname "$0")"; pwd)"
FEATURE_DIR="${SCRIPT_DIR}/features"
FEATURE_PREFIX=CR

ensureLabelerInstalled(){
    if ! which label_features > /dev/null; then
        echo -e "\nERROR: Install the feature file labeler gem"
        echo "   https://github.com/indigo-biosystems/feature_file_labeler"
        exit 1
    fi
}

labelFeatures(){
    echo -e "\nUpdating feature files"
    label_features -p "${FEATURE_PREFIX}" -d "${FEATURE_DIR}" 2>&1 > ../"${FEATURE_PREFIX}_output.txt"
    mv feature_report.txt ../"${FEATURE_PREFIX}_feature_report.txt"
    stageAndCommit "Label feature files" "${FEATURE_DIR}"
}

updateVersion(){
    updateGemspec
    updateLockfile
    commitStagedFiles "Update version to ${VERSION}"
}

updateGemspec(){
    echo -e "\nUpdating gemspec version"
    local gemspecPath="${SCRIPT_DIR}/compute_runner.gemspec"
    sed -i 's/\(\.version\s*=\s*\).*/\1'"'${VERSION}'/" "${gemspecPath}"
    stageFiles "${gemspecPath}"
}

updateLockfile(){
    echo -e "\nUpdating lockfile"
    bundle package --no-install > /dev/null
    rm -rf .bundle/ vendor/
    stageFiles "${SCRIPT_DIR}/Gemfile.lock"
}

stageAndCommit(){
    local msg="$1"
    shift
    local files=( "$@" )
    stageFiles "${files[@]}"
    commitStagedFiles "${msg}"
}

stageFiles(){
    local files=( "$@" )
    git add "${files[@]}"
}

commitStagedFiles(){
    local msg="$1"
    if thereAreStagedFiles; then
        git commit -m "${msg}"
    else
        echo "No changes to commit"
    fi
}

thereAreStagedFiles(){
    git update-index -q --ignore-submodules --refresh
    if git diff-index --cached --quiet HEAD --ignore-submodules -- ; then
        return 1;
    else
        return 0;
    fi
}

#ensureLabelerInstalled
#labelFeatures
updateVersion
