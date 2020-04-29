#!/bin/bash
 
[ $# -eq 0 ] && { echo "Usage: $0 dir-name"; exit 1; }

TARGET_DIR="$1"

# Test and maybe create target directory 
if [ -d "$TARGET_DIR" ]
then
   if [ "$(ls -A $TARGET_DIR)" ]
   then
    echo "$TARGET_DIR is not empty."
    exit 1
   fi
   echo "$TARGET_DIR exists and is empty. Will setup within."
else
  echo "Will create $TARGET_DIR."
  mkdir $TARGET_DIR
fi

# Determine project name
PROJECT_NAME=${TARGET_DIR##*/}
echo "Project name: $PROJECT_NAME"

# Create project structure
mkdir -p $TARGET_DIR/buildSrc/src/main/kotlin
cp ./files/buildSrc/Build.kt $TARGET_DIR/buildSrc/src/main/kotlin/
cp ./files/buildSrc/build.gradle.kts $TARGET_DIR/buildSrc/

cp ./files/root/settings.gradle.kts $TARGET_DIR/
sed -i "" "s/replace-me/$PROJECT_NAME/g" "$TARGET_DIR"/settings.gradle.kts
cp ./files/root/build.gradle.kts $TARGET_DIR/
sed -i "" "s/replace-me/$PROJECT_NAME/g" "$TARGET_DIR"/build.gradle.kts

cp -r ./files/root/gradle "$TARGET_DIR"
cp ./files/root/gradlew* "$TARGET_DIR"
cp ./files/root/new-module.sh "$TARGET_DIR"

echo "Go to $TARGET_DIR and run './gradlew build'"
