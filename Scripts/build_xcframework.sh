#!/usr/bin/env bash

set -eu

rm -rdf build
git clone --recursive https://github.com/libsdl-org/SDL.git build/SDL

pushd build/SDL

git checkout release-2.26.5 --force

COMMON_HEADER_FILES=(
"SDL.h"
"SDL_assert.h"
"SDL_atomic.h"
"SDL_audio.h"
"SDL_blendmode.h"
"SDL_clipboard.h"
"SDL_config.h"
"SDL_cpuinfo.h"
"SDL_endian.h"
"SDL_error.h"
"SDL_events.h"
"SDL_filesystem.h"
"SDL_gamecontroller.h"
"SDL_gesture.h"
"SDL_guid.h"
"SDL_haptic.h"
"SDL_hidapi.h"
"SDL_hints.h"
"SDL_joystick.h"
"SDL_keyboard.h"
"SDL_keycode.h"
"SDL_loadso.h"
"SDL_locale.h"
"SDL_log.h"
"SDL_main.h"
"SDL_messagebox.h"
"SDL_metal.h"
"SDL_misc.h"
"SDL_mouse.h"
"SDL_mutex.h"
"SDL_pixels.h"
"SDL_platform.h"
"SDL_power.h"
"SDL_quit.h"
"SDL_rect.h"
"SDL_render.h"
"SDL_rwops.h"
"SDL_rwops.h"
"SDL_scancode.h"
"SDL_sensor.h"
"SDL_shape.h"
"SDL_stdinc.h"
"SDL_surface.h"
"SDL_system.h"
"SDL_thread.h"
"SDL_timer.h"
"SDL_touch.h"
"SDL_version.h"
"SDL_video.h"
"SDL_vulkan.h"
"begin_code.h"
"close_code.h"
)

mkdir -p "../Headers-macos"
mkdir -p "../Headers-ios"
for hFile in ${COMMON_HEADER_FILES[@]}; do
  cp "include/${hFile}" "../Headers-macos"
  cp "include/${hFile}" "../Headers-ios"
done

cp "include/SDL_config_macosx.h" "../Headers-macos"
cp "include/SDL_config_iphoneos.h" "../Headers-ios"


BUILD_DIR=".."

# generate module map
COMMON_LINKED_FRAMEWORKS=(
"AudioToolbox"
"AVFoundation"
"CoreAudio"
"CoreGraphics"
"CoreHaptics"
"CoreMotion"
"Foundation"
"GameController"
"IOKit"
"Metal"
"QuartzCore"
)

MM_OUT_MACOS="module SDL2 {\n    header \"SDL.h\"\n    header \"SDL_vulkan.h\"\n    export *\n    link \"SDL2\"\n"
MM_OUT_IOS="module SDL2 {\n    header \"SDL.h\"\n    header \"SDL_vulkan.h\"\n    export *\n    link \"SDL2\"\n"

for fw in ${COMMON_LINKED_FRAMEWORKS[@]}; do
	MM_OUT_MACOS+="    link framework \"${fw}\"\n"
	MM_OUT_IOS+="    link framework \"${fw}\"\n"
done

LINKED_FRAMEWORKS_MACOS=(
"Carbon"
"Cocoa"
"ForceFeedback"
)

for fw in ${LINKED_FRAMEWORKS_MACOS[@]}; do
	MM_OUT_MACOS+="    link framework \"${fw}\"\n"
done

LINKED_FRAMEWORKS_IOS=(
"OpenGLES"
"UIKit"
)

for fw in ${LINKED_FRAMEWORKS_IOS[@]}; do
	MM_OUT_IOS+="    link framework \"${fw}\"\n"
done

MM_OUT_MACOS+="}\n"
MM_OUT_IOS+="}\n"

printf "%b" "${MM_OUT_MACOS}" > "../Headers-macos/module.modulemap"
printf "%b" "${MM_OUT_IOS}" > "../Headers-ios/module.modulemap"

pushd Xcode/SDL


BUILD_DIR="../../.."

# build archives
xcodebuild archive -quiet ONLY_ACTIVE_ARCH=NO -scheme "Static Library" -project "SDL.xcodeproj" -archivePath "${BUILD_DIR}/SDL-macosx/" -destination "generic/platform=macOS" BUILD_LIBRARY_FOR_DISTRIBUTION=YES SKIP_INSTALL=NO
xcodebuild archive -quiet ONLY_ACTIVE_ARCH=NO -scheme "Static Library-iOS" -project "SDL.xcodeproj" -archivePath "${BUILD_DIR}/SDL-iphoneos/" -destination "generic/platform=iOS"  BUILD_LIBRARY_FOR_DISTRIBUTION=YES SKIP_INSTALL=NO
xcodebuild archive -quiet ONLY_ACTIVE_ARCH=NO -scheme "Static Library-iOS" -project "SDL.xcodeproj" -archivePath "${BUILD_DIR}/SDL-iphonesimulator/" -destination "generic/platform=iOS Simulator"  BUILD_LIBRARY_FOR_DISTRIBUTION=YES SKIP_INSTALL=NO
xcodebuild archive -quiet ONLY_ACTIVE_ARCH=NO -scheme "Static Library-tvOS" -project "SDL.xcodeproj" -archivePath "${BUILD_DIR}/SDL-appletvos/" -destination "generic/platform=tvOS"  BUILD_LIBRARY_FOR_DISTRIBUTION=YES SKIP_INSTALL=NO
xcodebuild archive -quiet ONLY_ACTIVE_ARCH=NO -scheme "Static Library-tvOS" -project "SDL.xcodeproj" -archivePath "${BUILD_DIR}/SDL-appletvsimulator/" -destination "generic/platform=tvOS Simulator" BUILD_LIBRARY_FOR_DISTRIBUTION=YES SKIP_INSTALL=NO

popd
popd

BUILD_DIR="build"
HEADERS_DIR="build/Headers"

rm -rdf "${BUILD_DIR}/SDL2.xcframework"

# assemble xcframework
xcodebuild -create-xcframework \
 	-library "${BUILD_DIR}/SDL-macosx.xcarchive/Products/usr/local/lib/libSDL2.a" \
 	-headers "${HEADERS_DIR}-macos" \
 	-library "${BUILD_DIR}/SDL-iphoneos.xcarchive/Products/usr/local/lib/libSDL2.a" \
 	-headers "${HEADERS_DIR}-ios" \
 	-library "${BUILD_DIR}/SDL-iphonesimulator.xcarchive/Products/usr/local/lib/libSDL2.a" \
 	-headers "${HEADERS_DIR}-ios" \
 	-library "${BUILD_DIR}/SDL-appletvos.xcarchive/Products/usr/local/lib/libSDL2.a" \
 	-headers "${HEADERS_DIR}-ios" \
 	-library "${BUILD_DIR}/SDL-appletvsimulator.xcarchive/Products/usr/local/lib/libSDL2.a" \
 	-headers "${HEADERS_DIR}-ios" \
	-output "${BUILD_DIR}/SDL2.xcframework"
