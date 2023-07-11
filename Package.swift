// swift-tools-version:5.9

import PackageDescription
import CompilerPluginSupport
import Foundation

let buildDynamic = ProcessInfo.processInfo.environment["NODE_SWIFT_BUILD_DYNAMIC"] == "1"
let enableEvolution = ProcessInfo.processInfo.environment["NODE_SWIFT_ENABLE_EVOLUTION"] == "1"

let package = Package(
    name: "node-swift",
    platforms: [
        .macOS(.v10_15), .iOS(.v13),
    ],
    products: [
        .library(
            name: "NodeAPI",
            type: buildDynamic ? .dynamic : nil,
            targets: ["NodeAPI"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", branch: "release/5.9"),
    ],
    targets: [
        .target(name: "CNodeAPI"),
        .macro(
            name: "NodeAPIMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ]
        ),
        .target(
            name: "NodeAPI",
            dependencies: ["CNodeAPI", "NodeAPIMacros"],
            swiftSettings: (enableEvolution ? [
                .unsafeFlags(["-enable-library-evolution"])
            ] : [])
        ),
    ],
    cxxLanguageStandard: .cxx14
)
