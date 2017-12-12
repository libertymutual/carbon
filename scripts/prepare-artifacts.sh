#/bin/bash
set -e

DESTINATION_ROOT="${PWD}/artifacts"
IOS_PLATFORM="${DESTINATION_ROOT}/ios-platform"
ANDROID_PLATFORM="${DESTINATION_ROOT}/android-platform"
IOS_TEMPLATE="${DESTINATION_ROOT}/ios-template"
ANDROID_TEMPLATE="${DESTINATION_ROOT}/android-template"
JS_TEMPLATE="${DESTINATION_ROOT}/js-template"

mkdir -p ${DESTINATION_ROOT}
mkdir -p $IOS_PLATFORM
mkdir -p $ANDROID_PLATFORM/build
mkdir -p $ANDROID_PLATFORM/build/coverage
mkdir -p $ANDROID_PLATFORM/appmanager
mkdir -p $ANDROID_PLATFORM/appplatform
mkdir -p $ANDROID_PLATFORM/reactnativeview
mkdir -p $IOS_TEMPLATE
mkdir -p $ANDROID_TEMPLATE/coverage
mkdir -p $JS_TEMPLATE


# Platform iOS
echo "Moving iOS Platform build to artifacts"
mv ios/build/* ${IOS_PLATFORM}
mv ${IOS_PLATFORM}/reports/report.junit ${IOS_PLATFORM}/reports/report.xml
zip -r ${IOS_PLATFORM}/release/AppPlatform.zip ${IOS_PLATFORM}/release/AppPlatform.framework

# Platform Android
echo "Moving Android Platform build to artifacts"
mv android/build/* ${ANDROID_PLATFORM}/build

mv android/appmanager/build/* ${ANDROID_PLATFORM}/appmanager
mv android/appplatform/build/* ${ANDROID_PLATFORM}/appplatform
mv android/reactnativeview/build/* ${ANDROID_PLATFORM}/reactnativeview


# iOS Template
echo "Moving iOS Template build to artifacts"
mv templates/HelloWorld/ios/build/* ${IOS_TEMPLATE}
mv ${IOS_TEMPLATE}/reports/report.junit ${IOS_TEMPLATE}/reports/report.xml

# Android Template
echo "Moving Android Template build to artifacts"
mv templates/HelloWorld/android/app/build/* ${ANDROID_TEMPLATE}

# RN JavaScript Template
echo "Moving RN JavaScript reports to artifacts"
mv templates/HelloWorld/build/* ${JS_TEMPLATE}

# Reduce the artifact folder size by >200MB
rm -rf ${ANDROID_PLATFORM}/appmanager/generated
rm -rf ${ANDROID_PLATFORM}/appmanager/intermediates
rm -rf ${ANDROID_PLATFORM}/appmanager/tmp
rm -rf ${ANDROID_PLATFORM}/appplatform/generated
rm -rf ${ANDROID_PLATFORM}/appplatform/intermediates
rm -rf ${ANDROID_PLATFORM}/appplatform/tmp
rm -rf ${ANDROID_PLATFORM}/reactnativeview/generated
rm -rf ${ANDROID_PLATFORM}/reactnativeview/intermediates
rm -rf ${ANDROID_PLATFORM}/reactnativeview/tmp
rm -rf ${ANDROID_PLATFORM}/build/generated
rm -rf ${ANDROID_PLATFORM}/build/intermediates

rm -rf ${ANDROID_TEMPLATE}/generated
rm -rf ${ANDROID_TEMPLATE}/intermediates
rm -rf ${ANDROID_TEMPLATE}/tmp


# TODO: fix this script
scripts/cover2cover.py ${ANDROID_PLATFORM}/build/reports/jacoco/jacocoRootReport/jacocoRootReport.xml > ${ANDROID_PLATFORM}/build/coverage/cobertura.xml
scripts/cover2cover.py ${ANDROID_TEMPLATE}/reports/jacoco/jacocoTestReport/jacocoTestReport.xml > ${ANDROID_TEMPLATE}/coverage/cobertura.xml

# Merge all Cobertura reports
python scripts/merge-cobertura.py ${IOS_PLATFORM}/coverage/cobertura.xml ${ANDROID_PLATFORM}/build/coverage/cobertura.xml ${ANDROID_TEMPLATE}/coverage/cobertura.xml ${IOS_TEMPLATE}/coverage/cobertura.xml  ${JS_TEMPLATE}/coverage/cobertura-coverage.xml --path="" --output="${DESTINATION_ROOT}/cobertura-merged.xml"
# TODO Add the rest

# Transform merged Cobertura to Clover
cobertura-clover-transform  ${DESTINATION_ROOT}/cobertura-merged.xml > ${DESTINATION_ROOT}/clover-merged.xml