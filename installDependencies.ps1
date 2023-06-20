$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'

git clone https://github.com/Microsoft/vcpkg.git
.\vcpkg\bootstrap-vcpkg.bat
.\vcpkg\vcpkg integrate powershell

.\vcpkg\vcpkg install pkgconf --triplet x64-windows --no-print-usage
$env:Path += ';'+ $pwd.Path + '\vcpkg\installed\x64-windows\tools\pkgconf\'                
$env:PKG_CONFIG_PATH = '' + $pwd.Path + '\vcpkg\installed\x64-windows\lib\pkgconfig'

.\vcpkg\vcpkg install sdl2[core,vulkan] --recurse --triplet x64-windows --no-print-usage

$includedir = (pkgconf --variable includedir sdl2).Trim()
Write-Output ('#include "' + $includedir + '/SDL2/SDL.h"') > Sources/CSDL2/windows_generated.h
Write-Output ('#include "' + $includedir + '/SDL2/SDL_vulkan.h"') >> Sources/CSDL2/windows_generated.h

Remove-Item -Path .\.build -Recurse

swift build

# copy libraries
$bindir = ((pkgconf --variable exec_prefix sdl2).Trim() + "/bin")
$libdir = (pkgconf --variable libdir sdl2).Trim()
foreach ($config in "debug", "release") {
    $path = ".build/$config"
    if (Test-Path -Path $path) {
        Copy-Item ($bindir + '/SDL2.dll') $path
        Copy-Item ($libdir + '/SDL2.lib') $path
    }
}

swift test
