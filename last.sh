#!/bin/bash

BUILD_NUMBER=${BUILD_NUMBER}
MANIFEST_FILE="path/to/your/manifestfile.xml"

if [ -z "$BUILD_NUMBER" ]; then
  echo "Jenkins build number is not set."
  exit 1
fi
sed -i "s|<build_number>.*</build_number>|<build_number>$BUILD_NUMBER</build_number>|" $MANIFEST_FILE
echo "Updated the manifest file with Jenkins build number: $BUILD_NUMBER"
