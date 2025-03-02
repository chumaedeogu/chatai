#!/bin/bash

# Use Jenkins' BUILD_NUMBER if not explicitly provided
number=${BUILD_NUMBER:-latest}  

set -x

my_repo="https://github.com/chumaedeogu/chatai.git"

# Remove existing repo if it exists
[ -d /tmp/temp_repo ] && rm -rf /tmp/temp_repo

# Clone the repo
git clone "$my_repo" /tmp/temp_repo
cd /tmp/temp_repo

# Check if chai.yml exists before modifying
if [ -f "new8ks/chai.yml" ]; then
    sed -i "s|image: .*|image: chumaedeogu/peter:$number|" new8ks/chai.yml
else
    echo "Error: File new8ks/chai.yml not found!"
    exit 1
fi
