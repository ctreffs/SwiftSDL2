$includedir = (pkgconf --variable includedir sdl2).Trim()
Write-Output ('#include "' + $includedir + '/SDL2/SDL.h"') > Sources/CSDL2/windows_generated.h
