
# <img src="https://www.libsdl.org/media/SDL_logo.png" height="20" max-width="90%" alt="SDL2" /> Swift SDL2

[![Build Status](https://travis-ci.com/ctreffs/SwiftSDL2.svg?branch=master)](https://travis-ci.com/ctreffs/SwiftSDL2)
[![license](https://img.shields.io/badge/license-zlib-brightgreen.svg)](LICENSE)
[![swift version](https://img.shields.io/badge/swift-5.1+-brightgreen.svg)](https://swift.org/download)
[![platforms](https://img.shields.io/badge/platforms-%20macOS%20|%20iOS%20|%20tvOS-brightgreen.svg)](#)
[![platforms](https://img.shields.io/badge/platforms-linux-brightgreen.svg)](#)

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
* [SwiftEnv](https://swiftenv.fuller.li/) for Swift version management - (optional)

### 💻 Installing

Swift SDL2 is available for all platforms that support [Swift 5.1](https://swift.org/) and higher and the [Swift Package Manager (SPM)](https://github.com/apple/swift-package-manager).

Extend the following lines in your `Package.swift` file or use it to create a new project.

```swift
// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "YourPackageName",
    dependencies: [
        .package(url: "https://github.com/ctreffs/SwiftSDL2.git", from: "1.1.0")
    ],
    targets: [
        .target(
            name: "YourTargetName",
            dependencies: ["SDL2"])
    ]
)

```

Since it's a system library wrapper you need to install the SDL2 library either via

```sh
brew install sdl2
```

or 

```sh
apt-get install libsdl2-dev
```

depending on your platform.

## 📝 Code Example


### 🤘 Minimal Metal example application


```swift
import SDL2
import Metal
import class QuartzCore.CAMetalLayer

SDL_Init(SDL_INIT_VIDEO)
SDL_SetHint(SDL_HINT_RENDER_DRIVER, "metal")
SDL_InitSubSystem(SDL_INIT_VIDEO)

let window = SDL_CreateWindow("SDL2 Metal Demo", 0, 0, 800, 600, SDL_WINDOW_SHOWN.rawValue | SDL_WINDOW_ALLOW_HIGHDPI.rawValue)

let renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_PRESENTVSYNC.rawValue)

guard let layerPointer = SDL_RenderGetMetalLayer(renderer) else {
    fatalError("could not get metal layer from renderer")
}

let layer: CAMetalLayer = unsafeBitCast(layerPointer, to: CAMetalLayer.self)

guard let device: MTLDevice = layer.device else {
    fatalError("metal device missing")
}

guard let queue: MTLCommandQueue = device.makeCommandQueue() else {
    fatalError("could not create command queue")
}

SDL_DestroyRenderer(renderer)

var color = MTLClearColorMake(0, 0, 0, 1)

var quit = false
var event: SDL_Event = SDL_Event()
while(!quit) {
    while SDL_PollEvent(&event) != 0 {
        switch SDL_EventType(event.type) {
        case SDL_KEYUP:
            if( event.key.keysym.sym == SDLK_ESCAPE ) {
                quit = true
            }
        default:
            break
        }
    }

    guard let surface = layer.nextDrawable() else {
        break
    }

    color.blue = (color.blue > 1.0) ? 0 : color.blue + 0.01

    let pass = MTLRenderPassDescriptor()
    pass.colorAttachments[0].clearColor = color
    pass.colorAttachments[0].loadAction = .clear
    pass.colorAttachments[0].storeAction = .store
    pass.colorAttachments[0].texture = surface.texture

    guard let buffer = queue.makeCommandBuffer() else {
        fatalError("could not create command buffer")
    }

    guard let encoder = buffer.makeRenderCommandEncoder(descriptor: pass) else {
        fatalError("could not create render command encoder")
    }

    encoder.endEncoding()

    buffer.present(surface)
    buffer.commit()

}

SDL_DestroyWindow(window)
SDL_Quit()
```

See the unit tests for more examples.

## 💁 Help needed

This project is in an early stage and needs a lot of love.
If you are interested in contributing, please feel free to do so!

Things that need to be done are, among others:

- [ ] Wrap more SDL2 functions and types
- [ ] Support for [Cocoapods](https://cocoapods.org) packaging
- [ ] Support for [Carthage](https://github.com/Carthage/Carthage) packaging
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
* <https://github.com/MattGuerrette/CSDL2>
* <https://github.com/KevinVitale/SwiftSDL>
* <https://github.com/adagio/swiftsdl2>
* <https://github.com/latencyzero/SwiftSDL>
* <https://github.com/sunlubo/SwiftSDL2>
* <https://github.com/SwiftSDL/Demo>
