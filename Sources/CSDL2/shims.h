// <https://stackoverflow.com/a/5920028/6043526>
#if defined(WIN32) || defined(_WIN32) || defined(__WIN32__) || defined(__NT__)
   //define something for Windows (32-bit and 64-bit, this part is common)
   #ifdef _WIN64
      //define something for Windows (64-bit only)
      error "Win64 unsupported"
   #else
      //define something for Windows (32-bit only)
      error "Win32 unsupported"
   #endif
#elif __APPLE__
    #include <TargetConditionals.h>
    #if TARGET_IPHONE_SIMULATOR
         #include "apple_iOS.h" // iOS Simulator
    #elif TARGET_OS_IPHONE
        #include "apple_iOS.h" // iOS device
    #elif TARGET_OS_MAC
        #include "apple_macOS.h" //  macOS
    #else
       error "Unknown Apple platform"
    #endif
#elif __has_include("windows_generated.h")
    #include "windows_generated.h"
#elif __linux__
    #include "linux.h" //  linux
#else
   error "Unsupported platform"
#endif

// SDL_KeyCode was introduced with 2.0.12
// <https://github.com/libsdl-org/SDL/blob/release-2.0.12/include/SDL_keycode.h#L320>
#if SDL_MAJOR_VERSION == 2 && SDL_MINOR_VERSION == 0 && SDL_PATCHLEVEL <= 12
    typedef int SDL_KeyCode;
#endif
