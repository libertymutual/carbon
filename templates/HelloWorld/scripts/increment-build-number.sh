#Imporant: Usage should be ". ./incrementBuildNumber.sh" (Note the extra . required to prevent spawning a sub-process)
if grep -q APP_BUILD_NUMBER_HelloWorld ~/.profile; then
    sed -i.bu 's/APP_BUILD_NUMBER_HelloWorld=[0-9]*/APP_BUILD_NUMBER_HelloWorld='"$((APP_BUILD_NUMBER_HelloWorld+1))"'/' ~/.profile
else
    echo "export APP_BUILD_NUMBER_HelloWorld=1" >> ~/.profile
fi
mkdir -p ./artifacts
echo $((APP_BUILD_NUMBER_HelloWorld+1)) >> ./artifacts/BUILD_NUMBER
#Imporant: You must call "source ~/.profile" after executing this script