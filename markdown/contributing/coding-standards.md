# Coding Standards

<!-- toc -->

## Introduction

The following document outlines the coding standards and processes uses while
developing on the App Platform. These standards / processes should be
followed at all times, and all requirements must be met before submitting a pull
request to merge code into the main develop branch.

Please be pro-active in addressing any code which you spot which does not
satisfy the below requirements, or any areas which may have missing unit tests.
Our code quality is a collective team effort, so if you spot missing unit tests,
please add them...even if you did not add the file in the first place.

Our build pipeline has been configured to fail any builds which do not satisfy
some of the requirements listed below. If you merge code which fails a build,
addressing this broken build should become your first priority, taking
precedence over any other project work.

## Common Standards

Any changes to code in this repository should adhere to the common standards
listed in this section. There are some additional standards listed that are
specific to a certain language/framework.

### Code Review

All code must be reviewed by a senior peer before code is merged to develop. No
code should be pushed directly to develop, master or release branches

> **info-icon** This can be done using Bitbucket's built in
> [pull request](https://confluence.atlassian.com/bitbucket/work-with-pull-requests-223220593.html)
> tool

### Unit Tests

All existing unit tests must pass

* Build is configured to fail if unit test coverage drops below a specified
  threshold or if unit tests fail
* Any new functionality should include unit tests
  * This applies to new files added, but also to new functionality added to
    existing files
* Unit testing should not simply be a simple 'ComponentX renders correctly' test
  (even if this alone results in a high unit test coverage)
* Unit tests should test real functionality, business logic, functions & rules

### Code Comments

All code should be commented where appropriate, especially code that may not be
immediately obvious

In the future, we may adopt formal code comments (e.g. JSDoc)

## React Native

### Lint

This project uses [ESLint](https://eslint.org/) to manage linting

* All code must pass the eslint code quality tool and zero lint errors should be
  present.
* The build is configured to fail if lint errors are detected.
* Any changes to .eslintrc should be reviewed by a tech lead
* Run the linter using `npm run lint`

> **info-icon** Most IDE's have an extension or plugin that allows real-time
> lint checking

### Flow

Because javascript is dynamically typed, the React Native code uses
[Flow](https://flow.org/) for static type checking. All code must pass the flow
code quality tool and zero flow errors should be present.

* Run `npm run flow` to execute
* It is recommended that you configure your IDE to enable real-time flow
  checking for instant feedback
* Any changes to `.flowrc` should be reviewed by a tech lead
* The build is configured to fail if there are any flow errors
* All new JS files must have the `// @flow` declaration at the top of the file
  * This applies to all `.js` files including `index.js` and `styles.js` files
  * Build is configured to fail if lint errors are detected

### Unit Testing with Jest

The React Native code uses Jest as its unit testing framework

* Run `npm run test` to execute
* Run `npm run update-snapshots` to update Jest Snapshots

> **tip** **Note:** Snapshots should not be updated blindly just to get tests
> passing. It is easy to blindly update these with incorrect snapshot data. All
> snapshot changes you commit should be manually reviewed by yourself, and
> should also be reviewed by the person completing your PR approval

### Index Exports

Any new files should be properly exported from an index.js file within the same
directory

## iOS Native Code

### Linting with SwiftLint

All code must pass the SwiftLint code quality tool and zero lint errors should
be present

* Any changes to .swiftlint.yml should be reviewed by tech lead
* Build is configured to fail if lint errors are detected

## Android Native Code

See the common standards
