#!/bin/sh
set -eu
API="https://api.github.com/graphql"
AUTH="Authorization: bearer $GITHUB_TOKEN"
null_exit() {
    echo "$1"
    exit 0
}
error_exit() {
    echo "$1" 1>&2
    exit 1
}
ID=$(curl -fsSL -H "$AUTH" -X POST -d '{"query":"{repository(owner:\"wescran\", name:\"commit-issue-action\") {issues(labels:\"shellspec\", states:OPEN, first:5) {edges {node {id}}}}}"}' "$API")
[ $? -ne 0 ] && error_exit "Error with query"
LENGTH=$(jq -n $ID | jq '.data.repository.issues.edges|length')
[ $LENGTH -eq 0 ] && null_exit "No issues found"
OUT=$(jq -n $ID | jq -rc '.data.repository.issues.edges[] | .node.id' | xargs -I {} -P 4 curl -fsSL -H "$AUTH" -X POST -d '{"query": "mutation{deleteIssue(input:{issueId: \"{}\"}) {repository{nameWithOwner}}}"}' "$API" | jq -s '.|length')
[ $? -ne 0 ] && error_exit "Error with mutation"
[ $OUT -ne $LENGTH ] && null_exit "Lengths differ"
exit 0
