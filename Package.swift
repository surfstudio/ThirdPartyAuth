// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ThirdPartyAuth",
    defaultLocalization: "en",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "ThirdPartyAuth",
            targets: ["ThirdPartyAuth"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/surfstudio/iOS-Utils.git",
            revision: "13.2.0"
        )
    ],
    targets: [
        .target(
            name: "ThirdPartyAuth",
            dependencies: [
                .product(name: "Utils", package: "iOS-Utils")
            ],
            path: "ThirdPartyAuth"
        )
    ]
)
