#!/bin/sh

# Get the default branch name more reliably
DEFAULT=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')
if [ -z "$DEFAULT" ]; then
    DEFAULT="1.1"
fi

mkdir base
cat > base/index.html << EOF
<meta http-equiv="refresh" content="0; url=./$DEFAULT/">
EOF
touch base/.nojekyll

# Generating documentation for each other branch in a subdirectory
echo "All branches:"
git fetch --all
# Get all remote branches except HEAD, develop, and gh-pages
BRANCHES=$(git branch --remotes --format '%(refname:lstrip=3)' | grep -Ev '^(HEAD|develop|gh-pages)$')
echo "$BRANCHES"

for BRANCH in $BRANCHES; do
    SANITIZED_BRANCH="$(echo $BRANCH | sed 's/\//_/g')"
    echo "Processing branch: $BRANCH (Sanitized: $SANITIZED_BRANCH)"
    echo "$SANITIZED_BRANCH" >> base/versions.txt
    
    # Checkout the branch
    git checkout --force $BRANCH
    
    # Run processing to generate list.json
    node processing
    
    # Save the generated public folder (contains list.json and icons)
    cp -a public/. process
    
    # Update next.config.js with the branch-specific basePath
    # Use | as delimiter to avoid issues with / in paths
    sed -i "s|1.0|$SANITIZED_BRANCH|g" site/next.config.js
    
    # Build the site
    npm install --quiet --prefix site
    npm run deploy --prefix site
    
    # Restore the list.json and icons
    cp -a process/. public/
    rm -rf process
    
    # Reset next.config.js
    sed -i "s|$SANITIZED_BRANCH|1.0|g" site/next.config.js
    
    # Move to the versioned folder in base
    mv public base/$SANITIZED_BRANCH
    cp base/$SANITIZED_BRANCH/favicon.ico base/favicon.ico
done

mv base public
