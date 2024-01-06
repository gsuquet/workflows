#!/bin/bash

# Replaces semantic-release with script
{
    set -e

    # Git configuration
    GIT_COMMITTER_NAME=${GIT_COMMITTER_NAME:-"Semrel Extra Bot"}
    GIT_COMMITTER_EMAIL=${GIT_COMMITTER_EMAIL:-"semrel-extra-bot@hotmail.com"}
    VERBOSE=${VERBOSE:-false}
    NOQUOTE=""

    if [ "$VERBOSE" = true ]; then
        NOQUOTE="echo"
    fi

    GITHUB_TOKEN=${GITHUB_TOKEN:-$GH_TOKEN}

    if [ -z "$GITHUB_TOKEN" ]; then
        echo "env.GITHUB_TOKEN or GH_TOKEN is required"
        exit 1
    fi

    DEBUG=${DEBUG:-false}
    DRY_RUN=${DRY_RUN:-false}
    ORIGIN_URL=$(git config --get remote.origin.url | tr -d '\n')
    REPO_HOST=$(echo "$ORIGIN_URL" | awk -F'[@/]' '{print $2}')
    REPO_NAME=$(echo "$ORIGIN_URL" | awk -F'[@/]' '{print $3}')
    REPO_PUBLIC_URL="https://$REPO_HOST/$REPO_NAME"
    REPO_AUTHED_URL="https://$GITHUB_TOKEN@$REPO_HOST/$REPO_NAME.git"

    # Commits analysis
    SEMANTIC_TAG_PATTERN="^v?([0-9]+)\.([0-9]+)\.([0-9]+)$"
    RELEASE_SEVERITY_ORDER=("major" "minor" "patch")
    SEMANTIC_RULES=(
        '{"group": "Features", "releaseType": "minor", "prefixes": ["feat"]}',
        '{"group": "Fixes & improvements", "releaseType": "patch", "prefixes": ["fix", "perf", "refactor", "docs"]}',
        '{"group": "BREAKING CHANGES", "releaseType": "major", "keywords": ["BREAKING CHANGE", "BREAKING CHANGES"]}'
    )

    PKG_JSON=$(cat package.json)
    TAGS=$(git tag -l --sort=-v:refname)
    LAST_TAG=""
    for tag in $TAGS; do
        if [[ $tag =~ $SEMANTIC_TAG_PATTERN ]]; then
            LAST_TAG=$tag
            break
        fi
    done

    if [ -z "$LAST_TAG" ]; then
        COMMITS_RANGE="HEAD"
    else
        COMMITS_RANGE=$(git rev-list -1 $LAST_TAG)
    fi

    NEW_COMMITS=$(git log --format=+++%s__%b__%h__%H $COMMITS_RANGE | tr -d '\n')
    NEW_COMMITS=$(echo "$NEW_COMMITS" | awk -F'+++' '{print $2}' | awk -F'__' '{print $1 "||" $2 "||" $3 "||" $4}')

    SEMANTIC_CHANGES=""
    IFS=$'\n'
    for commit in $NEW_COMMITS; do
        IFS="||" read -r subj body short hash <<< "$commit"
        for rule in "${SEMANTIC_RULES[@]}"; do
            group=$(echo "$rule" | jq -r '.group')
            releaseType=$(echo "$rule" | jq -r '.releaseType')
            prefixes=$(echo "$rule" | jq -r '.prefixes[]')
            keywords=$(echo "$rule" | jq -r '.keywords[]')

            prefixMatcher=""
            keywordsMatcher=""
            if [ -n "$prefixes" ]; then
                prefixMatcher="^($prefixes)(\\([a-z0-9\\-_]+\\))?:\\s.+"
            fi
            if [ -n "$keywords" ]; then
                keywordsMatcher="($keywords):\\s(.+)"
            fi

            change=""
            if [[ $subj =~ $prefixMatcher ]]; then
                change="${BASH_REMATCH[0]}"
            elif [[ $body =~ $keywordsMatcher ]]; then
                change="${BASH_REMATCH[2]}"
            fi

            if [ -n "$change" ]; then
                SEMANTIC_CHANGES+="{\"group\":\"$group\",\"releaseType\":\"$releaseType\",\"change\":\"$change\",\"subj\":\"$subj\",\"body\":\"$body\",\"short\":\"$short\",\"hash\":\"$hash\"},"
            fi
        done
    done
    SEMANTIC_CHANGES="[${SEMANTIC_CHANGES%,}]"

    echo "semanticChanges=$SEMANTIC_CHANGES"
    [ "$DEBUG" = true ] && echo "tags: $TAGS"

    NEXT_RELEASE_TYPE=""
    for type in "${RELEASE_SEVERITY_ORDER[@]}"; do
        if echo "$SEMANTIC_CHANGES" | jq -r ".[] | select(.releaseType == \"$type\")" >/dev/null; then
            NEXT_RELEASE_TYPE=$type
            break
        fi
    done

    if [ -z "$NEXT_RELEASE_TYPE" ]; then
        echo "No semantic changes - no semantic release."
        exit 0
    fi

    NEXT_VERSION=""
    if [ -z "$LAST_TAG" ]; then
        NEXT_VERSION=${PKG_JSON##*\"version\": \"}
        NEXT_VERSION=${NEXT_VERSION%%\"*}
        NEXT_VERSION=${NEXT_VERSION:-"1.0.0"}
    else
        SEMANTIC_TAG_PATTERN="^v?([0-9]+)\.([0-9]+)\.([0-9]+)$"
        if [[ $LAST_TAG =~ $SEMANTIC_TAG_PATTERN ]]; then
            c1=${BASH_REMATCH[1]}
            c2=${BASH_REMATCH[2]}
            c3=${BASH_REMATCH[3]}

            if [ "$NEXT_RELEASE_TYPE" = "major" ]; then
                NEXT_VERSION="$((c1 + 1)).0.0"
            elif [ "$NEXT_RELEASE_TYPE" = "minor" ]; then
                NEXT_VERSION="$c1.$((c2 + 1)).0"
            elif [ "$NEXT_RELEASE_TYPE" = "patch" ]; then
                NEXT_VERSION="$c1.$c2.$((c3 + 1))"
            fi
        fi
    fi

    NEXT_TAG="v$NEXT_VERSION"
    RELEASE_DIFF_REF="## [$NEXT_VERSION]($REPO_PUBLIC_URL/compare/$LAST_TAG...$NEXT_TAG) ($(date +%Y-%m-%d))"
    RELEASE_DETAILS=""
    IFS=$'\n'
    for change in $(echo "$SEMANTIC_CHANGES" | jq -r ".[]"); do
        group=$(echo "$change" | jq -r '.group')
        subj=$(echo "$change" | jq -r '.subj')
        body=$(echo "$change" | jq -r '.body')
        short=$(echo "$change" | jq -r '.short')
        hash=$(echo "$change" | jq -r '.hash')

        RELEASE_DETAILS+="### $group\n"
        RELEASE_DETAILS+="* $subj ([${short}]($REPO_PUBLIC_URL/commit/$hash))\n"
    done

    RELEASE_NOTES="$RELEASE_DIFF_REF\n$RELEASE_DETAILS\n"

    # Update changelog
    echo "$RELEASE_NOTES$(cat ./CHANGELOG.md)" >./CHANGELOG.md

    # Update package.json version
    npm --no-git-tag-version --allow-same-version version "$NEXT_VERSION"

    if [ "$DRY_RUN" = true ]; then
        exit 0
    fi

    git config user.name "$GIT_COMMITTER_NAME"
    git config user.email "$GIT_COMMITTER_EMAIL"
    git remote set-url origin "$REPO_AUTHED_URL"

    # Prepare git commit and push
    echo "git push"
    RELEASE_MESSAGE="chore(release): $NEXT_VERSION [skip ci]"
    git add -A .
    git commit -am "$RELEASE_MESSAGE"
    git tag -a "$NEXT_TAG" HEAD -m "$RELEASE_MESSAGE"
    git push --follow-tags origin HEAD:refs/heads/master

    if [ -n "$PUSH_MAJOR_TAG" ]; then
        MAJOR_TAG=${NEXT_TAG%%.*}
        git tag -fa "$MAJOR_TAG" HEAD -m "$RELEASE_MESSAGE"
        git push --follow-tags -f origin "$MAJOR_TAG"
    fi

    # Push GitHub release
    RELEASE_DATA="{\"name\":\"$NEXT_TAG\",\"tag_name\":\"$NEXT_TAG\",\"body\":\"$RELEASE_NOTES\"}"
    echo "github release"
    curl -H "Authorization: token $GITHUB_TOKEN" -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/$REPO_NAME/releases -d "$RELEASE_DATA"

    # Publish npm artifact
    if [ "$PKG_JSON" != "null" ] && [ "$(echo "$PKG_JSON" | jq -r '.private')" != "true" ]; then
        ALIASES=($(echo "$PKG_JSON" | jq -r '.name,.alias[]' | tr -d '\n'))
        NPMJS_REGISTRY="https://registry.npmjs.org/"
        NPMRC=""

        if [ -f ".npmrc" ]; then
            NPMRC=".npmrc"
        else
            NPMRC=$(mktemp -d)/.npmrc
            echo "//registry.npmjs.org/:_authToken=$NPM_TOKEN" >"$NPMRC"
            echo "//npm.pkg.github.com/:_authToken=$GITHUB_TOKEN" >>"$NPMRC"
        fi

        for alias in "${ALIASES[@]}"; do
            echo "npm publish $alias $NEXT_VERSION to $NPMJS_REGISTRY"
            echo "$(jq '.name="'$alias'"' package.json)" >package.json
            npm publish ${NPM_PROVENANCE:+--provenance} --no-git-tag-version --registry=$NPMJS_REGISTRY --userconfig "$NPMRC"
        done

        echo "npm publish @$REPO_NAME $NEXT_VERSION to https://npm.pkg.github.com"
        echo "$(jq '.name="@'$REPO_NAME'"' package.json)" >package.json
        npm publish --no-git-tag-version --registry=https://npm.pkg.github.com/ --userconfig "$NPMRC"
    fi

    echo "Great success!"
} || {
    echo "An error occurred."
    exit 1
}
