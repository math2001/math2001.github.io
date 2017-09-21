set -o errexit # abort if a command fails

VERSION="0.1.0"

function git_clean {
    if [[ $(git status --short > /dev/null) == '' ]]; then
        return 0
    fi
    return 1
}
if ! git_clean; then
    echo "git status dirty"
    echo "You need to commit/remove your changes before you can deploy"
    exit 1
fi

TARGET_BRANCH=$(hugo config | grep publishbranch | egrep '"[^!\^:\\ ]+"' -o | tr -d '"')
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
CURRENT_COMMIT=$(git rev-parse --short HEAD)

echo "Current branch: '$CURRENT_BRANCH'"
echo "Target branch: '$TARGET_BRANCH'"

# get user confirmation
echo -n "Keep going (y/N): "
read line
if [[ $line != 'y' ]]; then
    echo "Abort"
    exit 1
fi

SUBMODULES=$(git config --file .gitmodules --get-regexp submodule\..+\.path | awk '{ print $2  }')

# build
tmpdir=$(mktemp -d)
hugo -d $tmpdir

git checkout $TARGET_BRANCH

mv $tmpdir/* .

git add .

# remove submodules from index (so they don't get commited)
echo $SUBMODULES | while read submodule; do
git rm --cached $SUBMODULES
done

git commit -m "auto build [$VERSION] $CURRENT_COMMIT"

git checkout $CURRENT_BRANCH
