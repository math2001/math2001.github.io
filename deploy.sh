set -o errexit # abort if a command fails

VERSION="0.1.0"
CURRENT_COMMIT=$(git rev-parse HEAD)

tmpdir=$(mktemp -d)
hugo -d $tmpdir
git checkout gh-pages
if [[ $(git status --short) != '' ]]; then
    echo 'git status not clean. Please commit your manual edits'
    exit 1
fi
mv $tmpdir/* .
git add .
git commit -am "Auto build [$VERSION] commit: $CURRENT_COMMIT"
git checkout master

set +o errexit