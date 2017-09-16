set -o errexit # abort if a command fails

VERSION="0.1.0"
BRANCH=$(hugo config | grep publishbranch | egrep '"[^!\^:\\ ]+"' -o | tr -d '"')
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

echo "Current branch: $CURRENT_BRANCH"
echo "Target branch: $BRANCH"

echo -n "Keep going (y/n): "
read line
if [[ $line != 'y' ]]; then
    echo "Abort"
    exit 1
fi

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
if [[ $(git status --short) != '' ]]; then
    echo 'git status not clean. Please commit your manual edits'
    exit 1
fi
mv $tmpdir/* .
git add .
git commit -m "Auto build [$VERSION] commit: $CURRENT_COMMIT"
git checkout $CURRENT_BRANCH

set +o errexit