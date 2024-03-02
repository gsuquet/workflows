# Centralized Workflows
<p align="center">
  <a href="https://github.com/gsuquet/workflows/blob/main/LICENSE" target="_blank" alt="License">
    <img src="https://img.shields.io/github/license/gsuquet/workflows" alt="License">
  </a>
  <a href="https://securityscorecards.dev/viewer/?uri=github.com/gsuquet/workflows" alt="openssf scorecard"> 
    <img src="https://api.securityscorecards.dev/projects/github.com/gsuquet/workflows/badge" alt="openssf score"/> 
  </a>
</p>

This repository contains all the github actions workflows used in my projects.

## Usage

To use a workflow in your project, either copy the workflow file to your project's `.github/workflows` directory or call it directly from the `uses` field in your workflow file.

```yaml
# .github/workflows/your-workflow.yml
name: Your Workflow
on:
  pull_request:

permissions: {}

jobs:
  your-job:
    permissions:
      contents: read
      pull-requests: write
    uses: gsuquet/workflows/.github/workflows/automation-labeler.yml@commit-sha
```

## Available Workflows

| Category | Workflow | Description |
| --- | --- | --- |
| automation | [closer](./.github/workflows/automation-closer.yml) | Close stale issues and PRs |
| automation | [comment-pr](./.github/workflows/automation-comment-pr.yml) | Add or update a comment on the pull request |
| automation | [greeter](./.github/workflows/automation-greeter.yml) | Greetings |
| automation | [labeler](./.github/workflows/automation-labeler.yml) | Labeler |
| deployment | [python-pypi](./.github/workflows/deployment-python-pypi.yml) | Deploy a python package to PyPi and GitHub |
| deployment | [s3](./.github/workflows/deployment-s3.yml) | Upload files to AWS S3 |
| integration | [commit-validator](./.github/workflows/integration-commit-validator.yml) | Validate commit or PR title format is correct |
| integration | [linter-pre-commit](./.github/workflows/integration-linter-pre-commit.yml) | Pre-commit |
| integration | [modification-script](./.github/workflows/integration-modification-script.yml) | Execute script and commit changes to git |
| integration | [python](./.github/workflows/integration-python.yml) | Unit tests and code format checks for a python project |
| security | [codeql](./.github/workflows/security-codeql.yml) | Code Quality and Security Analysis |
| security | [dependencies](./.github/workflows/security-dependencies.yml) | Dependency Scanning |
| security | [ossf-scorecard](./.github/workflows/security-ossf-scorecard.yml) | Scorecard supply-chain security |
<!-- WORKFLOWS TABLE END -->
