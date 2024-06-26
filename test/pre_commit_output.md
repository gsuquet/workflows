# GitHub Actions - Summary of pre-commit checks

## :x: Pre-commit checks failed :x:
You can reproduce this behavior locally by running :

```bash
pre-commit run --all-files --show-diff-on-failure
```

Please fix the errors and commit again.
If you think this is a false positive, please open an issue on the [GitHub repository](https://github.com/gsuquet/workflows/issues/new?assignees=&labels=bug%2Cto+sort&projects=&template=bug_report.yml).

### Checks summary
| Check | Result |
| --- | --- |
| check for merge conflicts | :white_check_mark:|
| don't commit to branch | :white_check_mark:|
| Update markdown table of contents | :white_check_mark:|
| Detect secrets | :white_check_mark:|
| trim trailing whitespace | :white_check_mark:|
| fix end of files | :white_check_mark:|
| check json(no files to check) | :ballot_box_with_check:|
| check yaml | :white_check_mark:|
| validate pre-commit manifest(no files to check) | :ballot_box_with_check:|
| Pretty format YAML | :white_check_mark:|
| check for added large files | :white_check_mark:|
| check for added large files with git lfs | :x:|
| check for added large files with git lfs | :white_check_mark:|
