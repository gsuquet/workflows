output=$(cat ./test/pre_commit_output.txt)

if echo "$output" | grep -q 'Failed'; then
    echo "## :x: Pre-commit checks failed :x:" > ./test/pre_commit_output.md
    echo "You can reproduce this behavior locally by running :" >> ./test/pre_commit_output.md
    echo "\`\`\`bash" >> ./test/pre_commit_output.md
    echo "pre-commit run --all-files --show-diff-on-failure" >> ./test/pre_commit_output.md
    echo "\`\`\`" >> ./test/pre_commit_output.md
    echo "Please fix the errors and commit again." >> ./test/pre_commit_output.md
    echo "If you think this is a false positive, please open an issue on the [GitHub repository](https://github.com/gsuquet/workflows/issues/new?assignees=&labels=bug%2Cto+sort&projects=&template=bug_report.yml)." >> ./test/pre_commit_output.md
    echo "" >> ./test/pre_commit_output.md
else
    echo "## :white_check_mark: Pre-commit checks passed :white_check_mark:\n" > ./test/pre_commit_output.md
fi

# Exclude lines that don't end with Passed, Skipped or Failed
output=$(echo "$output" | grep -E 'Passed|Skipped|Failed')

output=$(echo "$output" | sed 's/Passed/:white_check_mark:/g')
output=$(echo "$output" | sed 's/Skipped/:ballot_box_with_check:/g')
output=$(echo "$output" | sed 's/Failed/:x:/g')

# Use awk to format the output into a markdown table, removing the dots
output=$(echo "$output" | awk -F':' '{gsub(/\.+/, "", $1); print "| " $1 " | :" $2 ":|"}')

echo "### Checks summary" >> ./test/pre_commit_output.md
echo "| Check | Result |" >> ./test/pre_commit_output.md
echo "| --- | --- |" >> ./test/pre_commit_output.md
echo "$output" >> ./test/pre_commit_output.md
