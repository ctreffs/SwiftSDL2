
# <img src="https://www.libsdl.org/media/SDL_logo.png" height="20" max-width="90%" alt="SDL2" /> Swift SDL2

[![license](https://img.shields.io/badge/license-zlib-brightgreen.svg)](LICENSE)
[![Linux](https://github.com/ctreffs/SwiftSDL2/actions/workflows/ci-linux.yml/badge.svg)](https://github.com/ctreffs/SwiftSDL2/actions/workflows/ci-linux.yml)
[![macOS](https://github.com/ctreffs/SwiftSDL2/actions/workflows/ci-macos.yml/badge.svg)](https://github.com/ctreffs/SwiftSDL2/actions/workflows/ci-macos.yml)
[![Windows](https://github.com/ctreffs/SwiftSDL2/actions/workflows/ci-windows.yml/badge.svg)](https://github.com/ctreffs/SwiftSDL2/actions/workflows/ci-windows.yml)

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fctreffs%2FSwiftSDL2%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/ctreffs/SwiftSDL2)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fctreffs%2FSwiftSDL2%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/ctreffs/SwiftSDL2)

This is a  **thin** Swift wrapper around the popular and excellent [**Simple DirectMedia Layer**](https://www.libsdl.org) library.  
It provides a **swifty** and **typesafe** API. 

> Simple DirectMedia Layer is a cross-platform development library designed to provide low level access to audio, keyboard, mouse, joystick, and graphics hardware via OpenGL and Direct3D. It is used by video playback software, emulators, and popular games including Valve's award winning catalog and many Humble Bundle games.
> SDL officially supports Windows, Mac OS X, Linux, iOS, and Android. Support for other platforms may be found in the source code.
> SDL is written in C, works natively with C++, and there are bindings available for several other languages, including C# and Python.   
> ~ [www.libsdl.org](https://www.libsdl.org)

## 🚀 Getting Started

These instructions will get your copy of the project up and running on your local machine and provide a code example.

### 📋 Prerequisites

* [Swift Package Manager (SPM)](https://github.com/apple/swift-package-manager)
* [Swiftlint](https://github.com/realm/SwiftLint) for linting - (optional)

### 💻 Installing

Swift SDL2 is available for all platforms that support [Swift 5.6](https://swift.org/) and higher and the [Swift Package Manager (SPM)](https://github.com/apple/swift-package-manager).

Extend the following lines in your `Package.swift` file or use it to create a new project.

```swift
// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "YourPackageName",
    dependencies: [
        .package(url: "https://github.com/ctreffs/SwiftSDL2.git", from: "1.4.0")
    ],
    targets: [
        .target(
            name: "YourTargetName",
            dependencies: [
                .product(name: "SDL", package: "SwiftSDL2")
            ])
    ]
)

```
Depending on your platform several extra steps have to be taken to SDL2 to compile.

### Apple

For Apple platforms (macOS, iOS, tvOS) SDL2 is provided using an XCFramework so mo extra steps are needed.

### Linux

On Linux platforms you are required to use the following command to install SDL2 as a system package:

```sh
apt-get install libsdl2-dev
```

### Windows

Since Windows is a fairly new platform for Swift development there are some manual steps to perform before you can use the package.
All the following steps assume you have a working swift environment on your Windows machine.
If not follow the [instructions on how to install Swift on Windows](https://www.swift.org/download/#windows).

You can quickly test this package is working by running the `./buildPackageWin.ps1` powershell script.

## 📝 Code Example

### Minimal

A minimal example is located at [Sources/Demos/Minimal](Sources/Demos/Minimal).   

```swift
import SDL

// Initialize SDL video systems
guard SDL_Init(SDL_INIT_VIDEO) == 0 else {
    fatalError("SDL could not initialize! SDL_Error: \(String(cString: SDL_GetError()))")
}

// Create a window at the center of the screen with 800x600 pixel resolution
let window = SDL_CreateWindow(
    "SDL2 Minimal Demo",
    Int32(SDL_WINDOWPOS_CENTERED_MASK), Int32(SDL_WINDOWPOS_CENTERED_MASK),
    800, 600,
    SDL_WINDOW_SHOWN.rawValue)

var quit = false
var event = SDL_Event()

// Run until app is quit
while !quit {
    // Poll for (input) events
    while SDL_PollEvent(&event) > 0 {
        // if the quit event is triggered ...
        if event.type == SDL_QUIT.rawValue {
            // ... quit the run loop
            quit = true
        }
    }

    // wait 100 ms
    SDL_Delay(100)
}

// Destroy the window
SDL_DestroyWindow(window)

// Quit all SDL systems
SDL_Quit()
```

### Metal + macOS

There is another demo displaying a SDL2 demo window at [Sources/Demos/MetalApp](Sources/Demos/MetalApp).


## 💁 Help needed

This project is in an early stage and needs a lot of love.
If you are interested in contributing, please feel free to do so!

Things that need to be done are, among others:

- [ ] Wrap more SDL2 functions and types
- [ ] Write some additional tests to improve coverage

## 🏷️ Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/ctreffs/SwiftSDL2/tags). 

## ✍️ Authors

* [Christian Treffs](https://github.com/ctreffs)

See also the list of [contributors](https://github.com/ctreffs/SwiftSDL2/contributors) who participated in this project.

## 🔏 Licenses

This project is licensed under the zlib License - see the [LICENSE](LICENSE) file for details.

* SDL2 licensed under [zlib license](https://www.libsdl.org/license.php)


## 🙏 Original code

Since Swift SDL2 is merely a wrapper around [**SDL2**](https://www.libsdl.org) it obviously depends on it.       
Support them if you can!  
See <https://www.libsdl.org/credits.php>

## ☮️ Alternatives

* <https://github.com/PureSwift/CSDL2>
* <https://github.com/jaz303/CSDL2.swift>
* <https://github.com/latencyzero/CSDL2>
* <https://github.com/lightive/CSDL2>
* <https://github.com/sunlubo/CSDL2>
* <https://github.com/KevinVitale/SwiftSDL>
* <https://github.com/adagio/swiftsdl2>
* <https://github.com/latencyzero/SwiftSDL>
* <https://github.com/sunlubo/SwiftSDL2>
* <https://github.com/SwiftSDL/Demo>
