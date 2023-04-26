// swift-tools-version:5.7
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
        .target(name: "SDL2", dependencies: ["CSDL2Wrapped"]),
        // workaround for unsafeFlags from SDL <https://forums.swift.org/t/override-for-unsafeflags-in-swift-package-manager/45273/5>
        .target(name: "CSDL2Wrapped", dependencies: ["CSDL2"]),
        .target(name: "Minimal", dependencies: ["SDL2"], path: "Sources/Demos/Minimal"),
        .target(name: "MetalApp", dependencies: ["SDL2"], path: "Sources/Demos/MetalApp",swiftSettings: [.define("METAL_ENABLED", .when(platforms: [.macOS]))]),
        .testTarget(name: "CSDL2Tests", dependencies: ["CSDL2"])
    ]
)
