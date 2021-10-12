$bindir = ((pkgconf --variable exec_prefix sdl2).Trim() + "/bin")
$libdir = (pkgconf --variable libdir sdl2).Trim()
foreach ($config in "debug", "release") {
    $path = ".build/$config"
    if (Test-Path -Path $path) {
        Copy-Item ($bindir + '/SDL2.dll') $path
        Copy-Item ($libdir + '/SDL2.lib') $path
    }
}
