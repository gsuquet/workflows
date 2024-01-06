# Centralized Workflows

This repository contains all the github actions workflows used in my projects.

<p align="center">
  <a href="https://github.com/gsuquet/workflows/blob/main/LICENSE" target="_blank" alt="License">
    <img src="https://img.shields.io/github/license/gsuquet/workflows" alt="License">
  </a>
</p>

## Usage

To use a workflow in your project, either copy the workflow file to your project's `.github/workflows` directory or call it directly from the `uses` field in your workflow file.

```yaml
# .github/workflows/your-workflow.yml
name: Your Workflow
on:
  pull_request:

permissions:
  contents: read
  pull-requests: write

jobs:
  your-job:
    uses: gsuquet/workflows/.github/workflows/automation-labeler.yml@main
```

## Available Workflows

| Category | Workflow | Description |
| --- | --- | --- |
| automation | [closer](./.github/workflows/automation-closer.yml) | Close stale issues and PRs |
| automation | [comment-pr](./.github/workflows/automation-comment-pr.yml) | Add or update a comment on the pull request |
| automation | [display-workflow-info](./.github/workflows/automation-display-workflow-info.yml) | Display informations on the workflow run |
| automation | [greeter](./.github/workflows/automation-greeter.yml) | Greetings |
| automation | [labeler](./.github/workflows/automation-labeler.yml) | Labeler |
| deployment | [s3](./.github/workflows/deployment-s3.yml) | Upload files to AWS S3 |
| deployment | [semver](./.github/workflows/deployment-semver.yml) | Create new semantic version, tag and release it |
| integration | [commit-validator](./.github/workflows/integration-commit-validator.yml) | Validate commit or PR title format is correct |
| integration | [linter-pre-commit](./.github/workflows/integration-linter-pre-commit.yml) | Pre-commit |
| integration | [modification-script](./.github/workflows/integration-modification-script.yml) | Execute script and commit changes to git |
| integration | [integration](./.github/workflows/integration.yml) | Code integration |
| security | [codeql](./.github/workflows/security-codeql.yml) | Code Quality and Security Analysis |
| security | [dependencies](./.github/workflows/security-dependencies.yml) | Dependency Scanning |
<!-- WORKFLOWS TABLE END -->
