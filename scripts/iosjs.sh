#!/bin/bash
echo "Build source location: $BUILD_SOURCESDIRECTORY"
cd $BUILD_SOURCESDIRECTORY/templates/HelloWorld

mkdir -p build
export DEV_MODE=1
# The Template (HelloWorld)

npm install -g react-native-cli

yarn install
npm run test

sudo gem install fastlane -NV

cd ios
bundle install
bundle exec fastlane qa_app
