# Centralized Workflows

This repository contains all the github actions workflows used in my projects.

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
| automation | [greeter](./.github/workflows/automation-greeter.yml) | Greetings |
| automation | [labeler](./.github/workflows/automation-labeler.yml) | Labeler |
| integration | [linter-pr](./.github/workflows/integration-linter-pr.yml) | PR name linter |
| integration | [linter-pre-commit](./.github/workflows/integration-linter-pre-commit.yml) | Pre-commit |
| integration | [modification-script](./.github/workflows/integration-modification-script.yml) | Execute script and commit changes to git |
| integration | [integration](./.github/workflows/integration.yml) | Code integration |
| security | [codeql](./.github/workflows/security-codeql.yml) | Code Quality and Security Analysis |
| security | [dependencies](./.github/workflows/security-dependencies.yml) | Dependency Scanning |
<!-- WORKFLOWS TABLE END -->
