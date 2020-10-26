# commit-issue-action
GitHub action that monitors public repositories for commits to the master branch and creates an issue if found. There are 3 inputs that can be written to the workflow `main.yml` found in the `.github` directory.

## Inputs

### `sourceRepo`

**Required** The name of the repository to monitor for commits. Should be in the form of `{owner}/{repo}`

### `targetRepo`

**Required** The name of the repository to create an issue in. Should be in the form of `{owner}/{repo}`

### `issueLabels`

**Not Required** A comma-with-space separated string of labels to use for the created issue. An example of this would be `'Type: Maintenance, Status: Available, Status: Review Needed'`

### `timeUntil`

**Not Required** Only commits before this date will found. Only use Unix time (seconds since Unix epoch). Default is using present date. As an example 10/23/2020 becomes `1603425600`
### `timeFrame`

**Not Required** Time back from `timeUntil` to look for commits. Again only use Unix time. Default is 1 hour ago or `3600`. An example to look back 24 hours is `86400`

## Outputs

### `issueURL`

If an issue is created, an html url for the issue will ouput.

## Example usage
```
uses: wescran/commit-issue-action@v1
with:
  sourceRepo: 'wescran/commit-issue-action'
  targetRepo: 'wescran/commit-issue-action'
  issueLabels: 'Type: Maintenance, Status: Available'
  timeFrame: `86400`
```
