# Starting Development

This guide assumes that you used the `dss --project` command to create your project and that you have Homebrew installed. See [Quick Start](/quick-start.md) if you did not yet create a project.

## Common Install Steps

1. Install watchman using [Homebrew](https://brew.sh)

  ```sh
  brew install watchman
  ```

1. Install the React Native CLI

  ```sh
  npm install -g react-native-cli
  ```

1. Install `npm` modules

  `npm install` or `yarn install`

1. Run RN server & Lint at the project root

  ```sh
  npm run develop
  ```

## Next Steps

For Android apps, check out [Android Development](/development/android-development.md)

For iOS apps, check out [iOS Development](/development/ios-development.md)

## Modifying App Platform code

It is __strongly__ advised that consumers of the DSS App Platform __do not__ make changes to the core App Platform code (particularly directly in the node_modules folder) as this will hamper your ability to easily update to future App Platform versions.

If you do require running in "dev mode", see the following instructions: [Platform Development Mode](/contributing/platform-development-mode.md)