// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "PathMath",
    products: [
        .library(
            name: "PathMath",
            targets: ["PathMath"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "PathMath",
            dependencies: []),
        .testTarget(
            name: "PathMathTests",
            dependencies: ["PathMath"]),
    ]
)
