#!/bin/bash

# Check if the parameter is provided
if [ $# -eq 0 ]; then
  echo "Please provide the release version number as a parameter."
  exit 1
fi

# Check if the version number matches the semver format
if ! [[ $1 =~ ^[0-9]+\.[0-9]+\.[0-9]+(-rc)?$ ]]; then
  echo "The release version number does not match the semver format (X.Y.Z or X.Y.Z-rc)."
  exit 1
fi

# Check the current Git branch
current_branch=$(git symbolic-ref --short HEAD)
echo "Currently on branch: $current_branch"

if [[ ! $current_branch =~ ^(release|support)/[0-9]+\.[0-9]+\.[0-9]+(-rc)?$ ]]; then
    echo "The current Git branch ($current_branch) is not in the format 'release/X.Y.Z', 'release/X.Y.Z-rc', 'support/X.Y.Z' or 'support/X.Y.Z-rc'."
    exit 1
fi

version=$1

# Show the current directory and its files
echo "Current directory: $(pwd)"
echo "Files in the current directory:"
ls -l

# Add changelog to the index and create a commit
properties_file="gradle.properties"

current_version=$(grep -E '^SDK_VERSION_NAME=' "$properties_file" | cut -d'=' -f2)
echo "Current SDK_VERSION_NAME: ${current_version:-<empty>}"

echo "Updating SDK_VERSION_NAME to $version"

# Кроссплатформенный sed: macOS требует аргумент после -i, Linux — нет
if [[ "$OSTYPE" == "darwin"* ]]; then
  sed -i '' "s/^SDK_VERSION_NAME=.*/SDK_VERSION_NAME=$version/" "$properties_file"
else
  sed -i "s/^SDK_VERSION_NAME=.*/SDK_VERSION_NAME=$version/" "$properties_file"
fi

echo "Updated line:"
grep "^SDK_VERSION_NAME=" "$properties_file"
echo "gradle.properties updated and pushed successfully to $current_branch"

git add $properties_file
git commit -m "Bump Common SDK version to $version"

echo "Bump Common SDK version to $version"

echo "Pushing changes to branch: $current_branch"
if ! git push origin $current_branch; then
    echo "Failed to push changes to the origin $current_branch"
    exit 1
fi
