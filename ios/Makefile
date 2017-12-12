
APP=AppManager
APP_TARGET=AppManager
TESTS_TARGET=AppManager

###############################################################################

TOP := $(dir $(lastword $(MAKEFILE_LIST)))
CLEAR=\x1b[0m
BOLD=\033[1m
NORMAL=\033[0m

###############################################################################

all:
	@echo
	@echo "  $(BOLD)App Manager Framework$(NORMAL) - build tool"
	@echo
	@echo "    $(BOLD)make$(NORMAL) - show this help message"
	@echo "       aliases: make help"
	@echo "    $(BOLD)make build-ios$(NORMAL) - build a debug iOS build of $(APP)"
	@echo "       aliases: make debug-ios"
	@echo "    $(BOLD)make release-ios$(NORMAL) - build a release iOS build of $(APP)"
	@echo "    $(BOLD)make test-ios$(NORMAL) - run iOS unit tests"
	@echo "    $(BOLD)make test$(NORMAL) - run $(APP) unit tests"
	@echo "       aliases: make tests, make t"
	@echo "    $(BOLD)make coverage-ios$(NORMAL) - run iOS unit test coverage report for $(APP)"
	@echo "    $(BOLD)make setup-tools$(NORMAL) - setup tools needed for running tests etc"
	@echo "    $(BOLD)make clean$(NORMAL) - remove all build artifacts and executables"
	@echo

help: all

setup-tools:
	gem install xcpretty
	gem install slather
	gem install fastlane

install:
	cd $(TOP)ios && pod install

release-ios:
	cd $(TOP)ios && \
	xcodebuild -scheme $(APP_TARGET) -workspace ./AppManager.xcworkspace -configuration Release ONLY_ACTIVE_ARCH=NO SYMROOT=$(PWD)/ios/build
	cd $(TOP)

debug-ios:
	cd $(TOP)ios && \
	xcodebuild -scheme $(APP_TARGET) -workspace ./$(APP_TARGET).xcworkspace -configuration Debug SYMROOT=$(PWD)/ios/build build
	cd $(TOP)

build-ios: debug-ios

build: build-ios

test-ios:
	cd ios && \
	set -o pipefail && xcodebuild -scheme $(TESTS_TARGET) -workspace ./AppManager.xcworkspace test -destination 'platform=iOS Simulator,name=iPhone 7,OS=10.2' | xcpretty -r junit

test: test-ios

.PHONY: tests
tests: test
t: test

coverage-ios:
	cd ios && \
 	slather coverage -x --output-directory ./build/coverage --scheme $(TESTS_TARGET) $(APP).xcodeproj && \
	cobertura-clover-transform  ./build/coverage/cobertura.xml > ./build/coverage/clover.xml && \
	slather coverage --html --output-directory ./build/coverage/html --scheme $(TESTS_TARGET) $(APP).xcodeproj

clean:
	rm -rf $(TOP)ios/build
	cd ios && pod deintegrate
