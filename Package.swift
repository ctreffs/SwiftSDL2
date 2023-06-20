// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "SDL2",
    products: [
        .library(name: "SDL2",
                 targets: ["SDL"])
    ],
    targets: [
        .target(name: "SDL",
                dependencies: [.target(name: "SDL2")],
                linkerSettings: [
                    .linkedFramework("Foundation"),
                    .linkedFramework("AVFoundation"),
                    .linkedFramework("AudioToolbox"),
                    .linkedFramework("CoreGraphics"),
                    .linkedFramework("CoreHaptics"),
                    .linkedFramework("CoreAudio"),
                    .linkedFramework("GameController"),
                    .linkedFramework("QuartzCore"),
                    .linkedFramework("CoreMotion"),
                    .linkedFramework("IOKit"),
                    .linkedFramework("Metal"),
                    .linkedFramework("OpenGLES", .when(platforms: [.iOS, .tvOS])),
                    .linkedFramework("Cocoa", .when(platforms: [.macOS])),
                    .linkedFramework("UIKit", .when(platforms: [.iOS, .tvOS])),
                    .linkedFramework("ForceFeedback", .when(platforms: [.macOS])),
                    .linkedFramework("Carbon", .when(platforms: [.macOS]))
                ]
               ),
        .binaryTarget(name: "SDL2", path: "SDL2.xcframework"),
        .executableTarget(name: "Minimal", dependencies: ["SDL"], path: "Sources/Demos/Minimal"),
        .executableTarget(
            name: "MetalApp",
            dependencies: ["SDL"],
            path: "Sources/Demos/MetalApp",
            swiftSettings: [.define("METAL_ENABLED", .when(platforms: [.macOS]))]
        )
    ]
)
