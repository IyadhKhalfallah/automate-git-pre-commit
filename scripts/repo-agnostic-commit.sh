function git_commit_with_check {
  if [[ $1 == "commit" ]]; then
    # Call the original "git diff --cached --name-only" command to get a list of modified files
    modified_files=$(command git diff --cached --name-only)
    # Loop over the modified files and check if any of them contain an AWS key
    for file in $modified_files; do
      if grep -qE "(AKIA|ASIA)[A-Z0-9]{8,40}" $file; then
        echo "ERROR: AWS key detected in $file"
        exit 1
      fi
    done
    # If no AWS key was detected, call the original "git commit" command with the remaining arguments
    shift
    command git commit "$@"
  else
    # Call the original "git" command with any arguments passed to the script
    command git "$@"
  fi
}

# Call the "git_commit_with_check" function with any arguments passed to the script
git_commit_with_check "$@"
