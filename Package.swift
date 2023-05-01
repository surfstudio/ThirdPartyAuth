// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ThirdPartyAuth",
    defaultLocalization: "en",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "ThirdPartyAuth", targets: ["ThirdPartyAuth"]),
        .library(name: "ThirdPartyAuthUI", targets: ["ThirdPartyAuthUI"])
    ],
    dependencies: [
        .package(url: "https://github.com/google/GoogleSignIn-iOS", revision: "7.0.0")
    ],
    targets: [
        .target(
            name: "ThirdPartyAuth",
            dependencies: [
                .product(name: "GoogleSignIn",
                         package: "GoogleSignIn-iOS")
            ]
        ),
        .target(name: "ThirdPartyAuthUI", dependencies: ["ThirdPartyAuth"]),
        .testTarget(name: "ThirdPartyAuthTests", dependencies: ["ThirdPartyAuth"]),
        .testTarget(name: "ThirdPartyAuthUITests", dependencies: ["ThirdPartyAuthUI"])
    ]
)
