#if __APPLE__
    error "Use SDL2.xcframework"
#elif defined(WIN32) || defined(_WIN32) || defined(__WIN32__) || defined(__NT__)
    #if __has_include("windows_generated.h")
        #include "windows_generated.h"
    #else
        #include "windows.h"
    #endif
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
