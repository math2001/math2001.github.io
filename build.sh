if !git branch | grep gh-pages;
    echo "You need to create a new branch called gh-pages"
    exit 1
fi

echo "build into 'public'"
hugo -d public
echo "get publish branch name"
BRANCH_NAME=$(hugo config | egrep ^publishbranch:\ \" -m 1 | egrep '"[^!\^:\\ ]+"' -oi | tr -d '"')
if !git check-ref-format --branch $BRANCH_NAME; then
    exit 1
fi

