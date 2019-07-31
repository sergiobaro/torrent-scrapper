// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "torrent-scrapper",
    products: [
        .executable(name: "torrent-scrapper", targets: ["torrent-scrapper"]),
        .library(name: "TorrentScrapper", targets: ["TorrentScrapper"])
    ],
    dependencies: [
        .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "2.2.0")
    ],
    targets: [
        .target(
            name: "torrent-scrapper",
            dependencies: ["TorrentScrapper"]),
        .target(
            name: "TorrentScrapper",
            dependencies: ["SwiftSoup"]),
        .testTarget(
            name: "TorrentScrapperTests",
            dependencies: ["TorrentScrapper"]),
    ]
)
