# <img src="https://www.libsdl.org/media/SDL_logo.png" height="20" max-width="90%" alt="SDL2" /> SDL2 Swift Package (CSDL2)

<p align="left">
    <img src="https://img.shields.io/badge/Swift-5+-brightgreen.svg" />
    <a href="https://swift.org/package-manager">
        <img src="https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=flat" alt="Swift Package Manager" />
    </a>
    <img src="https://img.shields.io/badge/license-zlib-brightgreen.svg" alt="zlib license" />
     <img src="https://img.shields.io/badge/platforms-macOS%20|%20iOS%20|%20tvOS%20|%20linux-brightgreen.svg?style=flat" alt="macOS | iOS | tvOS | linux" />
</p>


This package provides the [Simple DirectMedia Layer 2](https://www.libsdl.org) (SDL2) library as a Swift system package.

SDL2 is ...
> ... a cross-platform development library designed to provide low level access to audio, keyboard, mouse, joystick, and graphics hardware via OpenGL and Direct3D

## 💡 Getting started

These instructions will tell you about the prerequisites and how to add this package to your Swift project.

### Prerequisites

#### Install SDL2 system library

Ensure you have installed SDL2 at an appropriate system library location. For instructions on how to do this please refer to <https://wiki.libsdl.org/Installation>.  
This packages relies on SDL2 to be installed to `/usr/local/...` which may be done via [Homebrew](https://brew.sh/) or [APT](https://linux.die.net/man/8/apt-get).

To install via Homebrew use 

```sh
brew install sdl2
```

Verify your installed SDL2 version with

```sh
brew list --versions sdl2
```


#### Swift requirements

This package requires [Swift 5](https://swift.org/download/) or higher and is intended to be used with the [Swift Package Manager (SPM)](https://swift.org/package-manager/).

## 📦 Use package

To install SDL2 for use in a Swift Package Manager powered tool or application, add SDL2 as a dependency to your `Package.swift` file. For more information, please see the [Swift Package Manager documentation](https://github.com/apple/swift-package-manager/tree/master/Documentation).


Add the following to you `Package.swift` file.

```swift
.package(url: "https://github.com/ctreffs/CSDL2", from: "1.0.0")
```
You need to add `CSDL2` as a dependency to your desired targets.

**To use the package in your code you must ensure *header* and *library* paths to your SDL2 installation are known to your environment.**   
For Xcode for example this may mean that you have add the following build settings to your project either in the build settings panel or via a `.xcconfig` file.

```xcconfig
HEADER_SEARCH_PATHS = $(inherited) /usr/local/include
LIBRARY_SEARCH_PATHS = $(inherited) /usr/local/lib
```

These settings, among other useful settings, may be found in [settings.xcconfig](settings.xcconfig) in this repository.
To generate an Xcode project with an `xcconfig` file use 

```sh
swift package generate-xcodeproj --xcconfig-overrides <yourfilename>.xcconfig
```

Finally use the following import to use all SDL2 functions in your code

```swift
import CSDL2

```

**HINT:** to use SDL2 on iOS or tvOS it seams to be neccessary that you embed CSL2 into the application rather than only linking the framework.


## 🤘 Minimal Metal example application


```swift
import CSDL2
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

## License

This project is licensed under the zlib License - see the [LICENSE](LICENSE) file for details
