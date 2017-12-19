#!/usr/bin/env bash

BRANCH="${bamboo_planRepository_1_branchName}"
PLAN_NAME="${bamboo_planName}"
PLAN_SHORT_NAME="${bamboo_shortPlanName}"
BAMBOO_BUILD_NUMBER="${bamboo_buildNumber}"
BUILD_URL="${bamboo_resultsUrl}"
ARTIFACT_URL=`echo $bamboo_buildResultsUrl/artifact/ITR/artifacts | sed 's/-ITR//g'`
ARTIFACTS_PATH="${PWD}/artifacts"
VERSION=$(cat package.json | python -c 'import json,sys; print json.load(sys.stdin)["version"]')
BUILD_NUMBER=$(cat package.json | python -c 'import json,sys; print json.load(sys.stdin)["buildNumber"]')

IOS_PLATFORM_TESTS=$(grep -E "<testsuites name='AppPlatformTests.xctest' tests='([0-9]*)' failures='([0-9]*)'>" $ARTIFACTS_PATH/ios-platform/reports/report.xml | sed "s/<testsuites name='AppPlatformTests.xctest'.*tests='\([0-9]*\)'.*/\1/")
IOS_PLATFORM_TESTS_REPORT="$ARTIFACT_URL/ios-platform/reports/report.html"
IOS_PLATFORM_COVERAGE=$(grep -E '<coverage.*line-rate="([0-9\.]+)"' $ARTIFACTS_PATH/ios-platform/coverage/cobertura.xml | sed 's/<coverage.*line-rate="\([0-9\.]*\)".*/\1/')
IOS_PLATFORM_COVERAGE_PERCENTAGE=$(python -c "print(${IOS_PLATFORM_COVERAGE}*100)" | xargs printf "%.*f\n" 2)
IOS_PLATFORM_COVERAGE_REPORT="$ARTIFACT_URL/ios-platform/coverage/html/index.html"
IOS_PLATFORM="$ARTIFACT_URL/ios-platform/release/AppPlatform.zip"

ANDROID_PLATFORM_TESTS_APPPLATFORM=$(grep -E -m 1 '<div class="counter">' $ARTIFACTS_PATH/android-platform/appplatform/reports/tests/testDebugUnitTest/index.html | awk -F'>' '{print $2}' | awk -F '<' '{print $1}')
ANDROID_PLATFORM_TESTS_APPMANAGER=$(grep -E -m 1 '<div class="counter">' $ARTIFACTS_PATH/android-platform/appmanager/reports/tests/testDebugUnitTest/index.html | awk -F'>' '{print $2}' | awk -F '<' '{print $1}')
ANDROID_PLATFORM_TESTS_REACTNATIVEVIEW=$(grep -E -m 1 '<div class="counter">' $ARTIFACTS_PATH/android-platform/reactnativeview/reports/tests/testDebugUnitTest/index.html | awk -F'>' '{print $2}' | awk -F '<' '{print $1}')
ANDROID_PLATFORM_TESTS=$(python -c "print($ANDROID_PLATFORM_TESTS_APPPLATFORM+$ANDROID_PLATFORM_TESTS_APPMANAGER+$ANDROID_PLATFORM_TESTS_REACTNATIVEVIEW)")
ANDROID_PLATFORM_COVERAGE=$(grep -E '<coverage' $ARTIFACTS_PATH/android-platform/build/coverage/cobertura.xml | awk '{print $4}' | awk -F'"' '{print $2}')
ANDROID_PLATFORM_COVERAGE_PERCENTAGE=$(python -c "print(${ANDROID_PLATFORM_COVERAGE}*100)" | xargs printf "%.*f\n" 2)
ANDROID_PLATFORM_COVERAGE_REPORT="$ARTIFACT_URL/android-platform/build/reports/jacoco/jacocoRootReport/html/index.html"
ANDROID_PLATFORM_APPMANAGER="$ARTIFACT_URL/android-platform/appmanager/outputs/aar/appmanager-release.aar"
ANDROID_PLATFORM_APPPLATFORM="$ARTIFACT_URL/android-platform/appplatform/outputs/aar/appplatform-release.aar"
ANDROID_PLATFORM_REACTNATIVEVIEW="$ARTIFACT_URL/android-platform/reactnativeview/outputs/aar/reactnativeview-release.aar"

IOS_APP_TESTS=$(grep -E "<testsuites name='HelloWorldUITests.xctest' tests='([0-9]*)' failures='([0-9]*)'>" $ARTIFACTS_PATH/ios-template/reports/report.xml | sed "s/<testsuites name='HelloWorldUITests.xctest'.*tests='\([0-9]*\)'.*/\1/")
IOS_APP_TESTS_REPORT="$ARTIFACT_URL/ios-template/reports/report.html"
IOS_APP_COVERAGE=$(grep -E '<coverage.*line-rate="([0-9\.]+)"' $ARTIFACTS_PATH/ios-template/coverage/cobertura.xml | sed 's/<coverage.*line-rate="\([0-9\.]*\)".*/\1/')
IOS_APP_COVERAGE_PERCENTAGE=$(python -c "print(${IOS_APP_COVERAGE}*100)" | xargs printf "%.*f\n" 2)
IOS_APP_COVERAGE_REPORT="$ARTIFACT_URL/ios-template/coverage/html/index.html"
IOS_APP="$ARTIFACT_URL/ios-template/release/HelloWorld.ipa"

ANDROID_APP_TESTS_UNIT=$(grep -E -m 1 '<div class="counter">' $ARTIFACTS_PATH/android-template/reports/tests/testDebugUnitTest/index.html | awk -F'>' '{print $2}' | awk -F '<' '{print $1}')
ANDROID_APP_TESTS_UI=$(grep -E -m 1 '<div class="counter">' $ARTIFACTS_PATH/android-template/reports/androidTests/connected/index.html | awk -F'>' '{print $2}' | awk -F '<' '{print $1}')
ANDROID_APP_TESTS=$(python -c "print($ANDROID_APP_TESTS_UNIT+$ANDROID_APP_TESTS_UI)")
ANDROID_APP_TESTS_REPORT="$ARTIFACT_URL/android-template/reports/tests/testDebugUnitTest/index.html"
ANDROID_APP_COVERAGE=$(grep -E '<coverage' $ARTIFACTS_PATH/android-template/coverage/cobertura.xml | awk '{print $4}' | awk -F'"' '{print $2}')
ANDROID_APP_COVERAGE_PERCENTAGE=$(python -c "print(${ANDROID_APP_COVERAGE}*100)" | xargs printf "%.*f\n" 2)
ANDROID_APP_COVERAGE_REPORT="$ARTIFACT_URL/android-template/reports/jacoco/jacocoTestReport/html/index.html"
ANDROID_APP="$ARTIFACT_URL/android-template/outputs/apk/release/app-release.apk"

JS_APP_TESTS=$(grep " tests=\"[0-9]\"" $ARTIFACTS_PATH/js-template/reports/junit.xml | sed 's/<testsuite name=".*" tests=[^0-9]*//g' |  awk -F'"' '{s+=$1} END {print s}')
JS_APP_TESTS_REPORT="$ARTIFACT_URL/js-template/reports/junit.xml"
JS_APP_COVERAGE=$(grep -E '<coverage.*line-rate="([0-9\.]+)"' $ARTIFACTS_PATH/js-template/coverage/cobertura-coverage.xml | sed 's/<coverage.*line-rate="\([0-9\.]*\)".*/\1/')
JS_APP_COVERAGE_PERCENTAGE=$(python -c "print(${JS_APP_COVERAGE}*100)" | xargs printf "%.*f\n" 2)
JS_APP_COVERAGE_REPORT="$ARTIFACT_URL/js-template/coverage/lcov-report/index.html"

TOTAL_TESTS=$(python -c "print($IOS_PLATFORM_TESTS+$IOS_APP_TESTS+$ANDROID_PLATFORM_TESTS+$ANDROID_APP_TESTS+$JS_APP_TESTS)")
TOTAL_COVERAGE=$(grep -E '<coverage.*line-rate="([0-9\.]+)"' $ARTIFACTS_PATH/cobertura-merged.xml | sed 's/<coverage.*line-rate="\([0-9\.]*\)".*/\1/')
TOTAL_COVERAGE_PERCENTAGE=$(python -c "print($TOTAL_COVERAGE*100)" | xargs printf "%.*f\n" 2)
echo "Total coverage: ${TOTAL_COVERAGE_PERCENTAGE}%"


LAST_COMMIT_AUTHOR_NAME=$(git log -1 --pretty=format:%an)
LAST_COMMIT_MESSAGE=$(git log -1 --pretty=format:%s)
LAST_COMMIT_HASH=$(git log -1 --pretty=format:%h)

compare () {
  lhs=$(printf '%07.3f' "$1"); lhs=${lhs/./}
  rhs=$(printf '%07.3f' "$3"); rhs=${rhs/./}
  case "$2" in
    -lt) return $(( 10#$lhs < 10#$rhs )) ;;
    -le) return $(( 10#$lhs <= 10#$rhs )) ;;
    -eq) return $(( 10#$lhs == 10#$rhs )) ;;
    -ge) return $(( 10#$lhs >= 10#$rhs )) ;;
    -gt) return $(( 10#$lhs > 10#$rhs )) ;;
  esac
}

percentageColor () {
	if [ -z "$1" ]; then
      echo "#777"
    else
		if compare 50 -le "$1" compare; then
	        echo "danger"
	    elif compare 80 -ge "$1" compare; then
	        echo "good"
	    else
	  	  echo "warning"
	    fi
	fi
}

IOS_PLATFORM_COLOR=$(percentageColor $IOS_PLATFORM_COVERAGE_PERCENTAGE)
ANDROID_PLATFORM_COLOR=$(percentageColor $ANDROID_PLATFORM_COVERAGE_PERCENTAGE)
IOS_APP_COLOR=$(percentageColor $IOS_APP_COVERAGE_PERCENTAGE)
ANDROID_APP_COLOR=$(percentageColor $ANDROID_APP_COVERAGE_PERCENTAGE)
JS_APP_COLOR=$(percentageColor $JS_APP_COVERAGE_PERCENTAGE)

SLACK_MESSAGE=$(cat <<-END
    {
    "attachments": [
        {
            "fallback": "New build",
            "color": "#205081",
            "pretext": "New build is ran on *${BRANCH}* branch",
            "title": "${PLAN_NAME}",
            "title_link": "${BUILD_URL}",
            "text": "${PLAN_SHORT_NAME} has finished running build ${BUILD_NUMBER}.",
            "fields": [
				{
                    "title": "Build Number",
                    "value": "${BUILD_NUMBER}",
                    "short": true
                },
				{
                    "title": "Version",
                    "value": "${VERSION}",
                    "short": true
                },
                {
                    "title": "Total Tests",
                    "value": "${TOTAL_TESTS}",
                    "short": true
                },
				{
                    "title": "Coverage",
                    "value": "${TOTAL_COVERAGE_PERCENTAGE}% (Android missing)",
                    "short": true
                },
                {
                    "title": "Bamboo Build Job Number",
                    "value": "${BAMBOO_BUILD_NUMBER}",
                    "short": true
                }
            ],
			"mrkdwn_in": ["text", "pretext"]
        },
		{
            "fallback": "Platform - iOS",
            "color": "${IOS_PLATFORM_COLOR}",
            "title": "Platform - iOS",
            "title_link": "${IOS_PLATFORM_COVERAGE_REPORT}",
            "text": "<${IOS_PLATFORM_TESTS_REPORT}|Unit tests: ${IOS_PLATFORM_TESTS}>\n<${IOS_PLATFORM_COVERAGE_REPORT}|Coverage: ${IOS_PLATFORM_COVERAGE_PERCENTAGE}%>\n<${IOS_PLATFORM}|Framework artifact>",
			"mrkdwn_in": ["text", "pretext"]
        },
		{
            "fallback": "Platform - Android",
            "color": "${ANDROID_PLATFORM_COLOR}",
            "title": "Platform - Android",
            "text": "<${ANDROID_PLATFORM_COVERAGE_REPORT}|Unit tests: ${ANDROID_PLATFORM_TESTS}>\n<${ANDROID_PLATFORM_COVERAGE_REPORT}|Coverage: ${ANDROID_PLATFORM_COVERAGE_PERCENTAGE}%>\n<${ANDROID_PLATFORM_APPMANAGER}|App Manager Lib> (${ANDROID_PLATFORM_TESTS_APPMANAGER})\n<${ANDROID_PLATFORM_APPPLATFORM}|App Platform Lib> (${ANDROID_PLATFORM_TESTS_APPPLATFORM})\n<${ANDROID_PLATFORM_REACTNATIVEVIEW}|React Native View Lib> (${ANDROID_PLATFORM_TESTS_REACTNATIVEVIEW})",
			"mrkdwn_in": ["text", "pretext"]
        },
		{
            "fallback": "HelloWorld App - iOS",
            "color": "${IOS_APP_COLOR}",
            "title": "HelloWorld App - iOS",
            "title_link": "${IOS_APP_COVERAGE_REPORT}",
            "text": "<${IOS_APP_TESTS_REPORT}|Unit tests: ${IOS_APP_TESTS}>\n<${IOS_APP_COVERAGE_REPORT}|Coverage: ${IOS_APP_COVERAGE_PERCENTAGE}%>\n<${IOS_APP}|IPA file>",
			"mrkdwn_in": ["text", "pretext"]
        },
		{
            "fallback": "HelloWorld App - Android",
            "color": "${ANDROID_APP_COLOR}",
            "title": "HelloWorld App - Android",
			"title_link": "${ANDROID_APP}",
            "text": "<${ANDROID_APP_TESTS_REPORT}|Unit tests: ${ANDROID_APP_TESTS}>\n<${ANDROID_APP_COVERAGE_REPORT}|Coverage: ${ANDROID_APP_COVERAGE_PERCENTAGE}%>\n<${ANDROID_APP}|Android App - APK file>",
			"mrkdwn_in": ["text", "pretext"]
        },
		{
            "fallback": "HelloWorld App - React Native JavaScript",
            "color": "${JS_APP_COLOR}",
            "title": "HelloWorld App - React Native JavaScript",
            "text": "<${JS_APP_TESTS_REPORT}|Unit tests: ${JS_APP_TESTS}>\n<${JS_APP_COVERAGE_REPORT}|Coverage: ${JS_APP_COVERAGE_PERCENTAGE}%>",
			"mrkdwn_in": ["text", "pretext"]
        },
		{
            "fallback": "Latest commit",
            "color": "#205081",
            "title": "Latest commit",
			"title_link": "https://git.forge.lmig.com/projects/PIDSS/repos/dss-app-platform/commits/${LAST_COMMIT_HASH}",
			"author_name": "${LAST_COMMIT_AUTHOR_NAME}",
            "text": "${LAST_COMMIT_MESSAGE}",
			"mrkdwn_in": ["text", "pretext"],
			"footer": "${LAST_COMMIT_HASH}",
			"footer_icon": "https://cdn2.iconfinder.com/data/icons/designer-skills/128/bitbucket-repository-svn-manage-files-contribute-branch-128.png"
        }
    ]
}
END
)

echo "==== Slack message ==="
echo $SLACK_MESSAGE
# Post message to Slack
curl --proxy http://app-proxy.lmig.com:80/ -X POST --data-urlencode "payload=${SLACK_MESSAGE}" https://hooks.slack.com/services/${bamboo_SLACK_TOKEN}