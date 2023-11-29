output=$(cat ./test/pre_commit_output.txt)
output=$(echo "$output" | grep -v '\[INFO\]')
output=$(echo "$output" | sed 's/Passed/:white_check_mark:/g')
output=$(echo "$output" | sed 's/Skipped/:ballot_box_with_check:/g')
output=$(echo "$output" | sed 's/Failed/:x:/g')

# Exclude empty lines
output=$(echo "$output" | grep -v '^$')

# Exclude lines that start with '-'
output=$(echo "$output" | grep -v '^-')

# Exclude lines that start with 'Fixing'
output=$(echo "$output" | grep -v '^Fixing')

# Use awk to format the output into a markdown table, removing the dots
output=$(echo "$output" | awk -F':' '{gsub(/\.+/, "", $1); print "| " $1 " | :" $2 ":|"}')

echo "| Check | Result |" > ./test/pre_commit_output.md
echo "| --- | --- |" >> ./test/pre_commit_output.md
echo "$output" >> ./test/pre_commit_output.md
