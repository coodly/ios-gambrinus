// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Packages",
    defaultLocalization: LanguageTag("en"),
    platforms: [.iOS(.v9)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "KioskCore",
            targets: ["KioskCore"]
        ),
        .library(
            name: "KioskUI",
            targets: ["KioskUI"]
        ),
        .library(
            name: "Packages",
            targets: ["Packages"]),
    ],
    dependencies: [
        .package(url: "https://github.com/coodly/BloggerAPI.git", .exact("0.1.2")),
        .package(url: "https://github.com/coodly/CoreDataPersistence.git", .exact("0.2.4")),
        .package(url: "https://github.com/coodly/ImageProvide.git", .exact("0.5.0")),
        .package(url: "https://github.com/coodly/Puff.git", .exact("0.6.3")),
        .package(name: "SWLogger", url: "https://github.com/coodly/swlogger.git", .exact("0.6.2")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Assets",
            resources: [.process("Resources")]
        ),
        .target(
            name: "KioskCore",
            dependencies: [
                "BloggerAPI",
                "CoreDataPersistence",
                "ImageProvide",
                "Puff",
                "SWLogger",
            ],
            resources: [Resource.process("Resources")]
        ),
        .target(
            name: "KioskUI",
            dependencies: [
                "Assets",
                "KioskCore",
                "Localization"
            ],
            resources: [Resource.process("Resources")]
        ),
        .target(
            name: "Localization",
            resources: [.process("Resources")]
        ),
        .target(
            name: "Packages",
            dependencies: []),
        .testTarget(
            name: "PackagesTests",
            dependencies: ["Packages"]),
    ]
)
