#ifdef __APPLE__
    #include <TargetConditionals.h>
    #if TARGET_IPHONE_SIMULATOR
         #include "apple_iOS.h"
    #elif TARGET_OS_IPHONE
        #include "apple_iOS.h"
    #elif TARGET_OS_MAC
        #include "apple_macOS.h"
    #else
       error "Unknown Apple platform"
    #endif
#else
	#include "other_platforms.h"
#endif



// SDL_KeyCode was introduced with 2.0.12
// <https://github.com/libsdl-org/SDL/blob/release-2.0.12/include/SDL_keycode.h#L320>
#if SDL_MAJOR_VERSION == 2 && SDL_MINOR_VERSION == 0 && SDL_PATCHLEVEL <= 12
    typedef enum { } SDL_KeyCode;
#endif

