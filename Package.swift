// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "Bagel",
    products: [
        .library(name: "Bagel", targets: ["Bagel"])
    ],
    dependencies: [
        .package(url: "https://github.com/mohpor/CocoaAsyncSocket", .branch("master")),
    ],
    targets: [
        .target(
            name: "Bagel",
            dependencies: ["CocoaAsyncSocket"],
            path: "iOS/Source",
            publicHeadersPath: "iOS/Source"
        )
    ],
    swiftLanguageVersions: [.v5]
)
