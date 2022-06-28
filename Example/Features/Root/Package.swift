// swift-tools-version: 5.6

import PackageDescription

let package = Package(
  name: "Root",
  platforms: [.iOS(.v13)],
  products: [
    .library(
      name: "Root",
      targets: ["Root"]
    ),
  ],
  dependencies: [
    .package(name: "RouteFoundation", path: "../../../"),
    .package(name: "Home", path: "../Home"),
    .package(name: "Product", path: "../Product"),
  ],
  targets: [
    .target(
      name: "Root",
      dependencies: [
        .product(name: "RouteFoundation", package: "RouteFoundation"),
        .product(name: "Home", package: "Home"),
        .product(name: "Product", package: "Product"),
      ]
    ),
  ]
)
