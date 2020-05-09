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
