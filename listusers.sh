#!/bin/bash

# GitHub API URL
API_URL="https://api.github.com"

# GitHub username and personal access token
USERNAME=$username
TOKEN=$token

# User and Repository information
REPO_OWNER=$1
REPO_NAME=$2

# Function to make a GET request to the GitHub API
function github_api_get {
    local endpoint="$1"
    local url="${API_URL}/${endpoint}"

    # Send a GET request to the GitHub API with authentication
    curl -s -u "${USERNAME}:${TOKEN}" "$url"
}

# Function to list users with read access to the repository
function list_users_with_read_access {
    local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"

    # Fetch the list of collaborators on the repository
    collaborators="$(github_api_get "$endpoint" | jq -r '.[] | select(.permissions.pull == true) | .login')"
#     collaborators="$(github_api_get "$endpoint" )"
    response="$(github_api_get "$endpoint")"
#if echo "$response" | jq -e '.message? // empty' >/dev/null; then
 # echo "Error: $(echo "$response" | jq -r '.message')"
#else
 # collaborators="$(echo "$response" | jq -r '.[] | select(.permissions.pull == true) | .login')"
 # echo "Users with read access: $collaborators"
#fi

    # Display the list of collaborators with read access
    if [[ -z "$collaborators" ]]; then
        echo "No users with read access found for ${REPO_OWNER}/${REPO_NAME}."
    else
        echo "Users with read access to ${REPO_OWNER}/${REPO_NAME}:"
        echo "$collaborators"
    fi
}

# Argument helper function (corrected!)
function helper {
    local expected_cmd_args=2
    if [ $# -ne $expected_cmd_args ]; then
        echo "Please enter the required arguments: <repo_owner> <repo_name>"
        exit 1
    fi
}

# Main script
helper "$@"  # Call helper with all script arguments

echo "Listing users with read access to ${REPO_OWNER}/${REPO_NAME}..."
list_users_with_read_access
