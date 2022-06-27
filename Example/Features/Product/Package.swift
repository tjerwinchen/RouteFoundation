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
    // .package(url: /* package url */, from: "1.0.0"),
  ],
  targets: [
    .target(
      name: "Product",
      dependencies: []
    ),
  ]
)
