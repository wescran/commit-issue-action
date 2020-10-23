#!/bin/sh
#check for commits on a target repo and if found create issue in source repo
set -eu
API="https://api.github.com/repos"
VERSION="Accept: application/vnd.github.v3+json"
PROGNAME=$(basename $0)
UNTIL=$(date +%s)
#since 1 hour ago in seconds
TIMEFRAME="3600"
#for errors in script, cause action to fail
error_exit()
{
  echo "${PROGNAME}: ${1:-"Unknown Error"}" 1>&2
  exit 1
}
#for results in script that shouldn't cause action to fail
null_exit()
{
  echo "${PROGNAME}: ${1:-"Null response"}"
  exit 0
}
#function that creates issue on GitHub
create_issue()
{
  title="New commit to ${1}"
  body="There was a new commit/commits to ${1}, please check the newly updated codebase. Here are the recent commits: ${commiturls}"
  labels=${3}
  json=$(jq -nc --arg l "${labels}" --arg t "${title}" --arg b "${body}" '$l | split(", ") | {title: $t, body: $b, labels: .}')
  issue=$(curl -fsSL --stderr - -X POST "${API}/${2}/issues" -H "authorization: token ${GITHUB_TOKEN}" -H "$VERSION" -H "Content-Type: application/json" -d "${json}")
  [ $? -ne 0 ] && error_exit "Error with request: ${issue}"
  echo "Issue created in ${2}"
  issueURL=$(jq -n "${issue}" | jq -r '.html_url')
  [ $? -ne 0 ] && error_exit "Error with issueURL"
  return 0
}
#function that checks for recent commits
check_commits()
{
  commits=$(curl -fsSL --stderr - "${API}/${1}/commits?since=$(date -Iseconds -u -d "@$((${2} - ${3}))")&until=$(date -Iseconds -u -d "@${2}")" -H "$VERSION")
  [ $? -ne 0 ] && error_exit "Error with http request: ${commits}"
  [ $(jq -n "${commits}" | jq length) -eq 0 ] && null_exit "No recent commits found"
  commiturls=$(jq -n "${commits}" | jq -r 'map(.html_url) | join("<br/>")')
  [ $? -ne 0 ] && error_exit "Error with jq construction: ${commiturls}"
  return 0
}
main()
{
#begin here, check for recent commits
echo "Checking for recent commits to ${1}"
#if found within time frame, create an issue on GitHub linking commits
check_commits "$1" "$4" "$5" && echo "There is a new commit to ${1}! Creating issue in ${2}."
create_issue "$1" "$2" "$3" && echo ::set-output name=issue_url::${issueURL}
exit 0
}
main ${INPUT_SOURCEREPO:-$1} ${INPUT_TARGETREPO:-$2} ${INPUT_ISSUELABELS:-${3:-""}} ${INPUT_TIMEUNTIL:-${4:-$UNTIL}} ${INPUT_TIMEFRAME:-${5:-$TIMEFRAME}}
