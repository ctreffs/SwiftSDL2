#ifdef __APPLE__
	#ifdef __IPHONEOS__
		#include "apple_iOS.h"
	#else
		#include "apple_macOS.h"
	#endif
#else
	#include "other_platforms.h"
#endif
