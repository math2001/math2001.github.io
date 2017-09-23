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

echo "$CURRENT_BRANCH@$CURRENT_COMMIT => build => $TARGET_BRANCH"
echo "Themes directory: '$THEMES_DIR'"

echo -n "Continue? (y/N) "
read line
if [[ $line != 'y' ]]; then
    echo "Abort"
    exit 1
fi

TEMP=$(mktemp -d)
hugo -d "$TEMP"

git checkout "$TARGET_BRANCH"

find -not -path "*.git*" -not -path "*$THEMES_DIR*" -type f -delete
find -depth -not -path "*.git*" -not -path "*$THEMES_DIR*" -type d -empty -exec rmdir {} +

mv $TEMP/* .

rmdir $TEMP

git add .

git rm --cached "$THEMES_DIR" -r

git commit -m "Auto build for $CURRENT_COMMIT" -m "deployer version: $VERSION"

git push origin HEAD

git checkout "$CURRENT_BRANCH"
