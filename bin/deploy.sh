[[ $@ == *--quiet* ]]
QUIET=$?

function output {
    if [[ ! $QUIET -eq 0 ]]; then
        echo $@
    fi
}

function echoerr {
    echo >&2 $@
}

set -o errexit

VERSION="1.0.1"

if ! `git diff --exit-code > /dev/null`; then
    echoerr "Uncommitted changes"
    echoerr "Please commit your changes before you deploy."
    exit 1
fi

THEMES_DIR=$(hugo config | grep "themesdir" | egrep '".+"' -o)
THEMES_DIR=${THEMES_DIR:1:${#THEMES_DIR}-2}

TARGET_BRANCH=$(hugo config | grep "publishbranch" | egrep '".+"' -o)
TARGET_BRANCH=${TARGET_BRANCH:1:${#TARGET_BRANCH}-2}

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

CURRENT_COMMIT=$(git rev-parse --short HEAD)

output "$CURRENT_BRANCH@$CURRENT_COMMIT => $TARGET_BRANCH"

if ! `git rev-parse --verify --quiet "$TARGET_BRANCH" > /dev/null`; then
    output -e "\nThe branch '$TARGET_BRANCH' doesn't exits."
    output -n "Creating it..."
    git checkout --orphan "$TARGET_BRANCH" --quiet
    git reset --hard --quiet &> /dev/null
    git commit --allow-empty -m "Initial commit" --quiet
    git checkout "$CURRENT_COMMIT" --quiet &> /dev/null
    output 'Done.'
fi

function get_temp_dir {
    # cannot use mktemp because hugo on windows doesn't work with path
    # starting with /
    local temp="../"
    while [[ -d $temp ]]; do
        local temp="../hugo-build-$RANDOM"
    done
    mkdir $temp
    echo $temp
}

TEMP=$(get_temp_dir)
hugo -d "$TEMP" --quiet

git checkout "$TARGET_BRANCH" --quiet &> /dev/null

find -not -path "*.git*" -not -path "*$THEMES_DIR*" -not -name 'README.md' -type f -delete
find -depth -not -path "*.git*" -not -path "*$THEMES_DIR*" -type d -empty -exec rmdir {} +

mv $TEMP/* .

rmdir $TEMP

git add . &> /dev/null

git rm --cached "$THEMES_DIR" -r --quiet

if `git diff --exit-code --cached > /dev/null`; then
    output "No change since last build"
    output "-> don't commit or push"
else
    output "Commit..."
    git commit -m "Auto build for $CURRENT_COMMIT" -m "deployer version: $VERSION" --quiet

    output "Push..."
    git push origin HEAD --quiet
fi

git checkout "$CURRENT_BRANCH" --quiet


