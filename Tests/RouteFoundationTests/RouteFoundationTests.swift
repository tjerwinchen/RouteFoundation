// RouteFoundationTests.swift
//
// Copyright (c) 2022 Codebase.Codes
// Created by Theo Chen on 2022.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the  Software), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

@testable import RouteFoundation
import XCTest

// MARK: - RouteFoundationTests

final class RouteFoundationTests: XCTestCase {
  override func setUp() {
    super.setUp()
    AppRoute.registerAll()
  }

  func test_getViewControllerFromRoute() {
    let homeViewController = AppRoute.home.viewController(queryParameters: ["title": "Home"])
    XCTAssertTrue(homeViewController.isMember(of: HomeViewController.self))
    XCTAssertEqual(homeViewController.title, "Home")

    let viewModel = WelcomeViewModel(title: "Welcome")
    let welcomeViewController = AppRoute.welcome.viewController(context: viewModel)
    XCTAssertTrue(welcomeViewController.isMember(of: WelcomeViewController.self))
    XCTAssertEqual(welcomeViewController.title, "Welcome")
  }

  // swiftlint:disable force_unwrapping
  func test_getViewControllerFromRouteManager() {
    let routeManager = RouteManager()

    routeManager.register(pattern: "home") { args in
      HomeViewController(url: args.url, params: args.parameters, context: args.context as? Context)
    }

    let homeViewController = routeManager.viewController(for: "home?title=Home", context: nil)!
    XCTAssertTrue(homeViewController.isMember(of: HomeViewController.self))
    XCTAssertEqual(homeViewController.title, "Home")

    let viewModel = WelcomeViewModel(title: "Welcome")
    routeManager.register(pattern: "welcome") { args in
      WelcomeViewController(url: args.url, params: args.parameters, viewModel: args.context as? WelcomeViewModel)
    }
    let welcomeViewController = routeManager.viewController(for: "welcome?q=w", context: viewModel)!
    XCTAssertTrue(welcomeViewController.isMember(of: WelcomeViewController.self))
    XCTAssertEqual(welcomeViewController.title, "Welcome")
  }

  func test_routeOwnership() {
    let routeManager1 = RouteManager()
    routeManager1.register(pattern: "home") { args in
      HomeViewController(url: args.url, params: args.parameters, context: args.context as? Context)
    }

    let routeManager2 = RouteManager()
    routeManager2.register(pattern: "home") { _ in
      UIViewController()
    }

    let homeViewController1 = routeManager1.viewController(for: "home")!
    let homeViewController2 = routeManager2.viewController(for: "home")!

    XCTAssertTrue(homeViewController1.isMember(of: HomeViewController.self))
    XCTAssertTrue(homeViewController2.isMember(of: UIViewController.self))
  }
}
