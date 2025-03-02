#!/bin/bash
set -x

# Set the build number from Jenkins, or use "latest" as a fallback
number=${BUILD_NUMBER:-latest}  
URL=https://github.com/chumaedeogu/chatai.git

# Remove any existing repo in /tmp/temp_repo
[ -d /tmp/temp_repo ] && rm -rf /tmp/temp_repo

# Clone the repo
git clone $URL /tmp/temp_repo
cd /tmp/temp_repo

# Check if chai.yml exists and modify it
if [ -f new8ks/chai.yml ]; then
    # Modify the image in chai.yml with the Jenkins build number
    sed -i 's|image: .*|image: chumaedeogu/peter:'"${number}"'|' new8ks/chai.yml
else
    echo "Error: File new8ks/chai.yml not found!"
    exit 1
fi

