// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Chip8",
    products: [
        .library(
            name: "Chip8",
            targets: ["Chip8"])
    ],
    dependencies: [
        
    ],
    targets: [
        .target(
            name: "Chip8",
            dependencies: []),
        .testTarget(
            name: "Chip8Tests",
            dependencies: ["Chip8"],
            resources: [.copy("EmptyROM")])
    ]
)
