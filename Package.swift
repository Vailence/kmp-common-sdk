// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift
// required to build this package.
import PackageDescription

let package = Package(
    name: "MindboxCommon",
    platforms: [.iOS(.v12)],
    products: [
        .library(
            name: "MindboxCommon",
            targets: ["MindboxCommon"]
        ),
    ],
    dependencies: [],
    targets: [
        .binaryTarget(
            name: "MindboxCommon",
            url: "https://github.com/mindbox-cloud/kmp-common-sdk/releases/download/1.0.3-rc/MindboxCommon.xcframework.zip",
            checksum:"422dad4454addc735ea7469286dea5a828ee114c392b008af69188952ea004f4"),
    ]
)