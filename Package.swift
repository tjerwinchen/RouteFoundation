// swift-tools-version: 5.6

import PackageDescription

let package = Package(
  name: "RouteFoundation",
  platforms: [.iOS(.v12)],
  products: [
    .library(name: "RouteFoundation", targets: ["RouteFoundation"]),
  ],
  dependencies: [
    .package(path: "../ResolverFoundation"),
    .package(path: "../ConcurrencyFoundation"),
  ],
  targets: [
    .target(name: "RouteFoundation", dependencies: [
      .product(name: "ResolverFoundation", package: "ResolverFoundation"),
      .product(name: "ConcurrencyFoundation", package: "ConcurrencyFoundation"),
    ]),
    .testTarget(name: "RouteFoundationTests", dependencies: [
      .target(name: "RouteFoundation"),
    ]),
  ]
)
