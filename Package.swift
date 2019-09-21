// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "Shinkansen",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "Shinkansen",
            targets: ["Shinkansen"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Shinkansen",
            dependencies: []),
    ]
)
