#!/bin/bash

. ../setup.sh

desc "Demo of Kubernetes Draft"

run "draft init"

desc "Update /etc/hosts with endpoint"

run "cd python"
run "ls"

run "draft create"

desc "Draft has detected the project type and added new files"

run "cat draft.toml"

run "draft up"

exit;
