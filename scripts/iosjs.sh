#!/bin/bash
echo "Build source location: $BUILD_SOURCESDIRECTORY"
cd $BUILD_SOURCESDIRECTORY/templates/HelloWorld

mkdir -p build
export DEV_MODE=1
# The Template (HelloWorld)

npm install -g react-native-cli

yarn install
npm run test

#Installing dependencies
sudo gem install fastlane -NV

#Install python
brew install python
#sh python setup.py install

#cd ios
#bundle install
#bundle exec fastlane qa_app
