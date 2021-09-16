$bindir = (pkgconf --variable exec_prefix sdl2).Trim()
$libdir = (pkgconf --variable libdir sdl2).Trim()
Copy-Item ($bindir + '/SDL2.dll') .build/debug
Copy-Item ($libdir + '/SDL2.lib') .build/debug
