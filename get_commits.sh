#!/bin/sh
# check for commits on a target repo and if found create issue in source repo
API="https://api.github.com/repos"
VERSION="Accept: application/vnd.github.v3+json"
PROGNAME=$(basename $0)
#for errors in script, cause action to fail
error_exit()
{
  echo "${PROGNAME}: ${1:-"Unknown Error"}" 1>&2
  exit 1
}
#for results in script that shouldn't cause action to fail
null_exit()
{
  echo "{PROGNAME}: ${1:-"Null response"}"
  exit 0
}
create_issue()
{
  title="New commit to ${INPUT_SOURCEREPO}"
  body="There was a new commit/commits to ${INPUT_SOURCEREPO}, please check the newly updated codebase. Here are the recent commits: ${commiturls}"
  labels=$INPUT_ISSUELABELS
  json=$(jq -nc --arg l "${labels}" --arg t "${title}" --arg b "${body}" '$l | split(", ") | {title: $t, body: $b, labels: .}')
  issue=$(curl -sS -X POST "${API}/${INPUT_TARGETREPO}/issues" -H "authorization: token ${GITHUB_TOKEN}" -H "$VERSION" -H "Content-Type: application/json" -d "${json}")
  [ $? -ne 0 ] && error_exit "Error with request: ${issue}"
  echo "Issue created in ${INPUT_TARGETREPO}"
  issueURL=$(jq -n "${issue}" | jq -r '.html_url')
  [ $? -ne 0 ] && error_exit "Error with issueURL"
  return 0
}
check_commits()
{
  commits=$(curl -fsSL "${API}/${INPUT_SOURCEREPO}/commits?since=$(date -Iseconds -u -d "@$(($(date +%s) - 86400))")&until=$(date -Iseconds -u)" -H "$VERSION")
  [ $? -ne 0 ] && error_exit "Error with http request: ${commits}"
  [ $(jq -n "${commits}" | jq length) -eq 0 ] && null_exit "No recent commits found"
  commiturls=$(jq -n "${commits}" | jq -r 'map(.html_url) | join("<br/>")')
  [ $? -ne 0 ] && error_exit "Error with jq construction: ${commiturls}"
  return 0
}
main()
{
  echo "Checking for recent commits to ${INPUT_SOURCEREPO}"
  check_commits && echo "There is a new commit to ${INPUT_SOURCEREPO}! Creating issue in ${INPUT_TARGETREPO}."
  create_issue && echo ::set-output name=issue_url::${issueURL}
  exit 0
}
#begin here
main
