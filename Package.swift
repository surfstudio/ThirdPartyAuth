// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ThirdPartyAuth",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "ThirdPartyAuth",
            targets: ["ThirdPartyAuth"])
    ],
    targets: [
        .target(
            name: "ThirdPartyAuth",
            dependencies: [],
            path: "ThirdPartyAuth"
        )
    ]
)
