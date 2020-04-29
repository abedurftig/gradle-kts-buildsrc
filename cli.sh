#!/bin/bash

dir="$1"
 
[ $# -eq 0 ] && { echo "Usage: $0 dir-name"; exit 1; }

# Test and maybe create target directory 
if [ -d "$dir" ]
then
   if [ "$(ls -A $dir)" ]
   then
    echo "$dir is not empty."
    exit 1
   fi
   echo "$dir exists and is empty. Will setup within."
else
  echo "Will create $dir."
  mkdir $dir
fi

# Determine project name
PROJECT_NAME=${dir##*/}
echo "Project name: $PROJECT_NAME"

# Create project structure
mkdir -p $dir/buildSrc/src/main/kotlin
cp ./files/buildSrc/Build.kt $dir/buildSrc/src/main/kotlin/
cp ./files/buildSrc/build.gradle.kts $dir/buildSrc/

cp ./files/root/settings.gradle.kts $dir/
sed -i "" "s/replace-me/$PROJECT_NAME/g" "$dir"/settings.gradle.kts
cp ./files/root/build.gradle.kts $dir/
sed -i "" "s/replace-me/$PROJECT_NAME/g" "$dir"/build.gradle.kts

cp -r ./files/root/gradle "$dir"
cp ./files/root/gradlew* "$dir"

echo "Go to $dir and run './gradlew build'"
