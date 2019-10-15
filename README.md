# commit-issue-action
GitHub action that monitors public repositories for commits to the master branch and creates an issue if found. There are 3 inputs that can be written to the workflow `main.yml` found in the `.github` directory.

## Inputs

### `sourceRepo`

**Required** The name of the repository to monitor for commits. Should be in the form of `{owner}/{repo}`

### `targetRepo`

**Required** The name of the repository to create an issue in. Should be in the form of `{owner}/{repo}`

### `issueLabels`

**Not Required** A comma-with-space separated string of labels to use for the created issue. An example of this would be `'Type: Maintenance, Status: Available, Status: Review Needed'`
## Outputs

### `issueURL`

If an issue is created, an html url for the issue will ouput.

## Example usage
```
uses: wescran/commits-issue-action@v1
with:
  sourceRepo: 'wescran/commit-issue-action'
  targetRepo: 'wescran/commit-issue-action'
  issueLabels: 'Type: Maintenance, Status: Available'
```
