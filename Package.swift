// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "SDL2",
    platforms: [
        .macOS(.v11),
        .iOS(.v13),
        .tvOS(.v13),
    ],
    products: [
        .library(name: "SDL2",
                 targets: ["SDL2"]),
    ],
    targets: [
        .target(name: "SDL2",
                dependencies: [
                    .target(name: "SDL2-apple", condition: .when(platforms: [.macOS, .iOS, .tvOS])),
                    .target(name: "CSDL2", condition: .when(platforms: [.linux])),
                ]),
        .testTarget(name: "SDLTests", dependencies: ["SDL2"]),
        .binaryTarget(name: "SDL2-apple", path: "SDL2.xcframework"),
        .systemLibrary(
            name: "CSDL2",
            pkgConfig: "sdl2",
            providers: [.apt(["libsdl2-dev"])]
        ),
        .executableTarget(name: "Minimal", dependencies: ["SDL2"], path: "Sources/Demos/Minimal"),
        .executableTarget(
            name: "MetalApp",
            dependencies: ["SDL2"],
            path: "Sources/Demos/MetalApp",
            swiftSettings: [.define("METAL_ENABLED", .when(platforms: [.macOS]))]
        ),
    ]
)
