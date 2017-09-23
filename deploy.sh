set -o errexit

VERSION="1.0.1"

if ! `git diff --exit-code > /dev/null`; then
    echo "Uncommitted changes"
    echo "Please commit your changes before you deploy."
    exit 1
fi

THEMES_DIR=$(hugo config | grep "themesdir" | egrep '".+"' -o)
THEMES_DIR=${THEMES_DIR:1:${#THEMES_DIR}-2}

TARGET_BRANCH=$(hugo config | grep "publishbranch" | egrep '".+"' -o)
TARGET_BRANCH=${TARGET_BRANCH:1:${#TARGET_BRANCH}-2}

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

CURRENT_COMMIT=$(git rev-parse --short HEAD)

echo "$CURRENT_BRANCH@$CURRENT_COMMIT => $TARGET_BRANCH"
echo "Themes directory: '$THEMES_DIR'"

if ! `git rev-parse --verify --quiet "$TARGET_BRANCH" > /dev/null`; then
    echo -e "\nThe branch '$TARGET_BRANCH' doesn't exits."
    echo -n "Create it? (y/N) "
    read line
    if [[ $line != 'y' ]]; then
        echo "Then please create it manually"
        exit 1
    fi
    git checkout --orphan "$TARGET_BRANCH" --quiet
    git reset --hard --quiet &> /dev/null
    git commit --allow-empty -m "Initial commit" --quiet
    git checkout "$CURRENT_COMMIT" --quiet &> /dev/null
    echo 'Done.'
fi

echo -n "Build? (y/N) "
read line
if [[ $line != 'y' ]]; then
    echo "Abort"
    exit 1
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

git checkout "$TARGET_BRANCH" --quiet

find -not -path "*.git*" -not -path "*$THEMES_DIR*" -type f -delete
find -depth -not -path "*.git*" -not -path "*$THEMES_DIR*" -type d -empty -exec rmdir {} +

mv $TEMP/* .

rmdir $TEMP

git add .

git rm --cached "$THEMES_DIR" -r --quiet

if `git diff --exit-code --cached > /dev/null`; then
    echo "No change since last build"
    echo "-> don't commit or push"
else
    echo "Commit..."
    git commit -m "Auto build for $CURRENT_COMMIT" -m "deployer version: $VERSION" --quiet

    echo "Push..."
    git push origin HEAD --quiet
fi

git checkout "$CURRENT_BRANCH" --quiet


