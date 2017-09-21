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

TARGET_BRANCH=$(hugo config | grep publishBranch | egrep '"[^!\^:\\ ]+"' -o | tr -d '"')
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
CURRENT_COMMIT=$(git rev-parse --short HEAD)

echo "Current branch: $CURRENT_BRANCH"
echo "Target branch: $BRANCH"

echo -n "Keep going (y/n): "
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

exit 0

if [[ "$(git branch --list $BRANCH)" == '' ]]; then
    # create branch
    git checkout --orphan $BRANCH
    git reset --hard
    git commit -m "Auto build [$VERSION] initial commit" --allow-empty
    git checkout $CURRENT_BRANCH
fi

CURRENT_COMMIT=$(git rev-parse HEAD)

tmpdir=$(mktemp -d)
hugo -d $tmpdir
git checkout $BRANCH

if ! git_clean; then
    echo 'git status not clean. Please commit your manual edits'
    exit 1
fi
rm -rf ./*
mv $tmpdir/* .
git add .
git commit -m "Auto build [$VERSION] commit: $CURRENT_COMMIT"
git checkout $CURRENT_BRANCH

set +o errexit
