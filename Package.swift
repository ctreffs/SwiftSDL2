// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "SDL",
    platforms: [
        .macOS(.v11),
        .iOS(.v13),
        .tvOS(.v13),
    ],
    products: [
        .library(name: "SDL",
                 targets: ["SDL"]),
    ],
    targets: [
        .target(name: "SDL",
                dependencies: [
                    .target(name: "SDL2", condition: .when(platforms: [.macOS, .iOS, .tvOS])),
                    .target(name: "CSDL2", condition: .when(platforms: [.linux, .windows])),
                ],
                path: "Sources/SDL2"),
        .testTarget(name: "SDLTests", dependencies: ["SDL"]),
        .binaryTarget(name: "SDL2", path: "SDL2.xcframework"),
        .systemLibrary(
            name: "CSDL2",
            pkgConfig: "sdl2",
            providers: [
                .apt(["libsdl2-dev"]),
                // ,.vcpkg(["sdl2[core,vulkan]"])
            ]
        ),
        .executableTarget(name: "Minimal", dependencies: ["SDL"], path: "Sources/Demos/Minimal"),
        .executableTarget(
            name: "MetalApp",
            dependencies: ["SDL"],
            path: "Sources/Demos/MetalApp",
            swiftSettings: [.define("METAL_ENABLED", .when(platforms: [.macOS]))]
        ),
    ]
)
