// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "CSDL2",
    products: [
        .library(name: "CSDL2",
                 targets: ["CSDL2"])
    ],
    targets: [
        .systemLibrary(
            name: "CSDL2",
            pkgConfig: "SDL2",
            providers: [
                .brew(["sdl2"]),
                .apt(["libsdl2-dev", "ibsdl2-2.0"])
            ]),
        .testTarget(name: "CSDL2Tests", dependencies: ["CSDL2"])
    
    ]
)
