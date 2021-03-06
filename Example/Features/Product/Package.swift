// swift-tools-version: 5.6

import PackageDescription

let package = Package(
  name: "Product",
  platforms: [.iOS(.v13), .watchOS(.v6)],
  products: [
    .library(
      name: "Product",
      targets: ["Product"]
    ),
  ],
  dependencies: [
    .package(name: "RouteFoundation", path: "../../../"),
  ],
  targets: [
    .target(
      name: "Product",
      dependencies: [
        .product(name: "RouteFoundation", package: "RouteFoundation"),
      ]
    ),
  ]
)
