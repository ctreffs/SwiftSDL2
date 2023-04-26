// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "SDL2",
    products: [
        .library(name: "SDL2",
                 targets: ["SDL2"]),
        .executable(name: "MinimalApp",
                    targets: ["Minimal"]),
        .executable(name: "MetalApp",
                    targets: ["MetalApp"])
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
        .executableTarget(name: "Minimal", dependencies: ["SDL2"], path: "Sources/Demos/Minimal"),
        .executableTarget(
            name: "MetalApp",
            dependencies: ["SDL2"],
            path: "Sources/Demos/MetalApp",
            swiftSettings: [.define("METAL_ENABLED", .when(platforms: [.macOS]))]
        ),
        .testTarget(name: "CSDL2Tests", dependencies: ["CSDL2"])
    ]
)
