// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

//let package = Package(
//    name: "ThirdPartyAuth",
//    defaultLocalization: "en",
//    platforms: [.iOS(.v13)],
//    products: [
//        .library(name: "ThirdPartyAuth", targets: ["ThirdPartyAuth"]),
//        .library(name: "ThirdPartyAuthUI", targets: ["ThirdPartyAuthUI"])
//    ],
//    targets: [
//        .target(name: "ThirdPartyAuth"),
//        .target(name: "ThirdPartyAuthUI", dependencies: ["ThirdPartyAuth"]),
//        .testTarget(name: "ThirdPartyAuthTests", dependencies: ["ThirdPartyAuth"]),
//        .testTarget(name: "ThirdPartyAuthUITests", dependencies: ["ThirdPartyAuthUI"])
//    ]
//)

let platforms: [SupportedPlatform] = [.iOS(.v13)]

let dependencies: [Package.Dependency] = [
    .package(url: "https://github.com/google/GoogleSignIn-iOS", revision: "7.0.0")
]

let thirdPartyAuthTargets: [Target] = [
    .target(
        name: "ThirdPartyAuth",
        dependencies: [
            .product(name: "GoogleSignIn",
                     package: "GoogleSignIn-iOS")
        ]
    ),
    .testTarget(name: "ThirdPartyAuthTests", dependencies: ["ThirdPartyAuth"])
]

let thirdPartyAuthUITargets: [Target] = [
    .target(name: "ThirdPartyAuthUI", dependencies: ["ThirdPartyAuth"]),
    .testTarget(name: "ThirdPartyAuthUITests", dependencies: ["ThirdPartyAuthUI"])
]

let targets: [Target] = thirdPartyAuthTargets
+ thirdPartyAuthUITargets

let package = Package(
    name: "ThirdPartyAuth",
    defaultLocalization: "en",
    platforms: platforms,
    products: [
        .library(name: "ThirdPartyAuth", targets: ["ThirdPartyAuth"]),
        .library(name: "ThirdPartyAuthUI", targets: ["ThirdPartyAuthUI"])
    ],
    dependencies: dependencies,
    targets: targets
)
