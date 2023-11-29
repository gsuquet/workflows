#!/bin/bash

# Header of the table
echo "| Category | Workflow | Description |" > workflows_table.md
echo "| --- | --- | --- |" >> workflows_table.md

# Iterate over the workflow files
for file in .github/workflows/*.yml; do
    # Extract the category and workflow name from the file name
    category=$(basename $file .yml | cut -d'-' -f1)
    workflow=$(basename $file .yml | cut -d'-' -f2-)

    # Extract the description from the 'name' field in the YAML file
    description=$(grep '^name:' $file | sed 's/name: //')

    # Generate the markdown link
    link="[${workflow}](./${file})"

    # Append the row to the table
    echo "| ${category} | ${link} | ${description} |" >> workflows_table.md
done

# Add a marker line after the table
echo "<!-- WORKFLOWS TABLE END -->" >> workflows_table.md

# Delete the old table from the README
sed -i '/| Category | Workflow | Description |/,/<!-- WORKFLOWS TABLE END -->/d' README.md

# Append the generated table to the README
cat workflows_table.md >> README.md

# Remove the temporary file
rm workflows_table.md
