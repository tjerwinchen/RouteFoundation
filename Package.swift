// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "RouteFoundation",
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
