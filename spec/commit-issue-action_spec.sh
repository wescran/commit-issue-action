Describe "mock date to known commit"
  It "fails to run with improper source repo"
    When run script get_commits.sh "wescran/fake" "wescran/commit-issue-action" "shellspec" "1574124013"
    The status should be failure
    The output should include "Checking for recent commits"
    The error should include "Error with http request"
  End
  It "fails to run with improper target repo"
    When run script get_commits.sh "wescran/commit-issue-action" "wescran/fake" "shellspec" "1574124013"
    The status should be failure
    The output should include "There is a new commit"
    The error should include "Error with request"
  End
  It "runs script with recent commits"
    When run script get_commits.sh "wescran/commit-issue-action" "wescran/commit-issue-action" "shellspec" "1574124013"
    The status should be success
    The output should include "There is a new commit"
    The output should include "Issue created"
  End
End
Describe "short time frame"
  It "runs script with no recent commits"
    When run script get_commits.sh "wescran/commit-issue-action" "wescran/commit-issue-action" "shellspec" "" "1" 
    The status should be success
    The output should include "No recent commits found"
  End
End
