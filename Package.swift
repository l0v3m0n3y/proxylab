// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "proxylab",
    platforms: [
        .macOS(.v12), .iOS(.v15)
    ],
    products: [
        .library(name: "proxylab", targets: ["proxylab"]),
    ],
    targets: [
        .target(
            name: "proxylab",
            path: "src"
        ),
    ]
)
