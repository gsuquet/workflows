#!/bin/bash

output=$(cat ./test/pre_commit_output.txt)

if printf "%s" "$output" | grep -q 'Failed'; then
    {
        printf "## :x: Pre-commit checks failed :x:\n"
        printf "You can reproduce this behavior locally by running :\n\n"
        printf "\`\`\`bash\n"
        printf "pre-commit run --all-files --show-diff-on-failure\n"
        printf "\`\`\`\n\n"
        printf "Please fix the errors and commit again.\n"
        printf "If you think this is a false positive, please open an issue on the [GitHub repository](https://github.com/gsuquet/workflows/issues/new?assignees=&labels=bug%%2Cto+sort&projects=&template=bug_report.yml).\n"
        printf "\n"
    } > ./test/pre_commit_output.md
else
    printf "## :white_check_mark: Pre-commit checks passed :white_check_mark:\n" > ./test/pre_commit_output.md
fi

# Exclude lines that don't end with Passed, Skipped or Failed
output=$(printf "%s" "$output" | grep -E 'Passed|Skipped|Failed')

output=${output//Passed/:white_check_mark:}
output=${output//Skipped/:ballot_box_with_check:}
output=${output//Failed/:x:}

# Use awk to format the output into a markdown table, removing the dots
output=$(printf "%s" "$output" | awk -F':' '{gsub(/\.+/, "", $1); print "| " $1 " | :" $2 ":|"}')

{
    printf "### Checks summary\n"
    printf "| Check | Result |\n"
    printf "| --- | --- |\n"
    printf "%s\n" "$output"
} >> ./test/pre_commit_output.md
