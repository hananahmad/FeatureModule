// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FeatureModule",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "FeatureModule",
            targets: ["FeatureModule"]),
    ],
    dependencies: [
        .package(url: "https://github.com/hananahmad/SuperNetworkLayer.git", branch: "main")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "FeatureModule",
        dependencies: [
            .product(name: "NetworkingLayer", package: "SuperNetworkLayer")
        ],
        resources: [.process("Resources")]),
        .testTarget(
            name: "FeatureModuleTests",
            dependencies: ["FeatureModule"]),
    ]
)
