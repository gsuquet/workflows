output=$(cat ./test/pre_commit_output.txt)

# Exclude lines that don't end with Passed, Skipped or Failed
output=$(echo "$output" | grep -E 'Passed|Skipped|Failed')

output=$(echo "$output" | sed 's/Passed/:white_check_mark:/g')
output=$(echo "$output" | sed 's/Skipped/:ballot_box_with_check:/g')
output=$(echo "$output" | sed 's/Failed/:x:/g')

# Use awk to format the output into a markdown table, removing the dots
output=$(echo "$output" | awk -F':' '{gsub(/\.+/, "", $1); print "| " $1 " | :" $2 ":|"}')

echo "| Check | Result |" > ./test/pre_commit_output.md
echo "| --- | --- |" >> ./test/pre_commit_output.md
echo "$output" >> ./test/pre_commit_output.md
