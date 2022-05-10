// swift-tools-version: 5.6

import PackageDescription

let package = Package(
  name: "RouteFoundation",
  platforms: [.iOS(.v12)],
  products: [
    .library(name: "RouteFoundation", targets: ["RouteFoundation"]),
  ],
  dependencies: [
  ],
  targets: [
    .target(name: "RouteFoundation", dependencies: []),
    .testTarget(name: "RouteFoundationTests", dependencies: [
      .target(name: "RouteFoundation"),
    ]),
  ]
)
