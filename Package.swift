// swift-tools-version:4.2
import PackageDescription

let package = Package(
    name: "Bagel",
    products: [
        .library(name: "Bagel", targets: ["Bagel"])
    ],
    targets: [
        .target(
            name: "Bagel",
            path: "iOS/Source"
        )
    ]
)
