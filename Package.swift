// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "SDL2",
    products: [
        .library(name: "SDL2", targets: ["SDL2"]),
        .library(name: "CSDL2", targets: ["CSDL2"])
    ],
    targets: [
        .systemLibrary(
            name: "CSDL2",
            pkgConfig: "sdl2",
            providers: [
                .brew(["sdl2"]),
                .apt(["libsdl2-dev"])
        ]),
        .target(name: "SDL2", dependencies: ["CSDL2"]),
        .testTarget(name: "CSDL2Tests", dependencies: ["CSDL2"])
    ]
)
