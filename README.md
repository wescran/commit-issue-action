# commit-issue-action
GitHub action that monitors public repositories for commits and creates an issue if found. There is also an issue template that you can edit yourself to fit your needs for the issue you would like to create if commits are found.

## Inputs

### `sourceRepo`

**Required** The name of the repository to monitor for commits.

### `targetRepo`

**Required** The name of the repository to create an issue in. 

## Outputs

### `issueURL`

If an issue is created, an html url for the issue will ouput.

## Example usage
```
uses: wescran/commits-issue-action@v1
with:
  sourceRepo: 'wescran/commit-issue-action'
  targetRepo: 'wescran/commit-issue-action'
```
