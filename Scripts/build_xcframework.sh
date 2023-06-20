#!/usr/bin/env bash

set -eu

rm -rdf build
git clone --recursive https://github.com/libsdl-org/SDL.git build/SDL

pushd build/SDL

git checkout release-2.26.5 --force

mkdir -p "../Headers"
cp include/*.h "../Headers/" 

BUILD_DIR=".."
HEADERS_DIR="../Headers"

# generate module map
echo "module SDL2 {" > "${BUILD_DIR}/module.modulemap"
for f in "${HEADERS_DIR}"/*; do
  echo "    header \"$(basename -- $f)\"" >> "${BUILD_DIR}/module.modulemap"
done
echo "    export *" >> "${BUILD_DIR}/module.modulemap"
echo "    link \"SDL2\"" >> "${BUILD_DIR}/module.modulemap"
echo "}" >> "${BUILD_DIR}/module.modulemap"

cp "${BUILD_DIR}/module.modulemap" "${HEADERS_DIR}/module.modulemap"

pushd Xcode/SDL


BUILD_DIR="../../.."

# build archives
xcodebuild archive ONLY_ACTIVE_ARCH=NO -scheme "Static Library" -project "SDL.xcodeproj" -archivePath "${BUILD_DIR}/SDL-macosx/" -sdk macosx BUILD_LIBRARY_FOR_DISTRIBUTION=YES SKIP_INSTALL=NO
xcodebuild archive ONLY_ACTIVE_ARCH=NO -scheme "Static Library-iOS" -project "SDL.xcodeproj" -archivePath "${BUILD_DIR}/SDL-iphoneos/" -sdk iphoneos BUILD_LIBRARY_FOR_DISTRIBUTION=YES SKIP_INSTALL=NO
xcodebuild archive ONLY_ACTIVE_ARCH=NO -scheme "Static Library-iOS" -project "SDL.xcodeproj" -archivePath "${BUILD_DIR}/SDL-iphonesimulator/" -sdk iphonesimulator BUILD_LIBRARY_FOR_DISTRIBUTION=YES SKIP_INSTALL=NO
xcodebuild archive ONLY_ACTIVE_ARCH=NO -scheme "Static Library-tvOS" -project "SDL.xcodeproj" -archivePath "${BUILD_DIR}/SDL-appletvos/" -sdk appletvos BUILD_LIBRARY_FOR_DISTRIBUTION=YES SKIP_INSTALL=NO
xcodebuild archive ONLY_ACTIVE_ARCH=NO -scheme "Static Library-tvOS" -project "SDL.xcodeproj" -archivePath "${BUILD_DIR}/SDL-appletvsimulator/" -sdk appletvsimulator BUILD_LIBRARY_FOR_DISTRIBUTION=YES SKIP_INSTALL=NO

popd
popd

BUILD_DIR="build"
HEADERS_DIR="build/Headers"

rm -rdf "${BUILD_DIR}/SDL2.xcframework"

# assemble xcframework
xcodebuild -create-xcframework \
 	-library "${BUILD_DIR}/SDL-macosx.xcarchive/Products/usr/local/lib/libSDL2.a" \
 	-headers ${HEADERS_DIR} \
 	-library "${BUILD_DIR}/SDL-iphoneos.xcarchive/Products/usr/local/lib/libSDL2.a" \
 	-headers ${HEADERS_DIR} \
 	-library "${BUILD_DIR}/SDL-iphonesimulator.xcarchive/Products/usr/local/lib/libSDL2.a" \
 	-headers ${HEADERS_DIR} \
 	-library "${BUILD_DIR}/SDL-appletvos.xcarchive/Products/usr/local/lib/libSDL2.a" \
 	-headers ${HEADERS_DIR} \
 	-library "${BUILD_DIR}/SDL-appletvsimulator.xcarchive/Products/usr/local/lib/libSDL2.a" \
 	-headers ${HEADERS_DIR} \
	-output "${BUILD_DIR}/SDL2.xcframework"
