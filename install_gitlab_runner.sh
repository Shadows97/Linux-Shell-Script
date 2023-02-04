#/bin/bash

echo "----------------- Step 1 – Add the official GitLab repository -----------------"

curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash

echo "----------------- Step 2 – Install the latest version of GitLab Runner -----------------"

sudo apt-get install gitlab-runner