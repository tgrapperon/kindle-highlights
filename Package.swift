// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "kindle-highlights",
    platforms: [.macOS(.v12)],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", .exact("1.1.2")),
        .package(url: "https://github.com/pointfreeco/swift-parsing.git", .exact("0.9.1")),
//        .package(url: "https://github.com/alexito4/Baggins.git", .exact("1.1.0")),
        .package(name: "Baggins", path: "../Baggins"),
    ],
    targets: [
        .executableTarget(
            name: "kindle-highlights",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Parsing", package: "swift-parsing"),
                "Baggins",
            ]
        ),
        .testTarget(
            name: "kindle-highlightsTests",
            dependencies: ["kindle-highlights"]
        ),
    ]
)
