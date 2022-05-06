// Route.swift
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

import UIKit

/// (_ url: URLConvertible, queryParameters: [String: String], context: Any?)
public typealias RouteViewControllerProvider = ((url: URLConvertible, parameters: [String: String], context: Any?)) -> UIViewController?

/// (_ url: URLConvertible, queryParameters: [String: String])
public typealias RouteURLOpenHandlerProvider = ((url: URLConvertible, parameters: [String: String])) -> Bool

public typealias RouteURLOpenHandler = () -> Bool

// MARK: - Route

public protocol Route: CaseIterable, RawRepresentable where RawValue == String {
  /// url patter for the route
  var urlPattern: String { get }

  /// view cotroller provider for the route
  var viewControllerProvider: RouteViewControllerProvider { get }

  /// url open hanlder for the route
  var urlOpenHandlerProvider: RouteURLOpenHandlerProvider { get }

  /// view controller for a ruote
  func viewController(queryParameters: [String: String], context: Any?) -> UIViewController

  func show(queryParameters: [String: String], context: Any?, from sourceViewController: UIViewController?)

  func showDetail(queryParameters: [String: String], context: Any?, from sourceViewController: UIViewController?, wrapIn navigationControllerClass: UINavigationController.Type?)

  func push(queryParameters: [String: String], context: Any?, from navigationController: UINavigationController?, animated: Bool)

  func present(queryParameters: [String: String], context: Any?, wrapIn navigationControllerClass: UINavigationController.Type?, animated: Bool, completion: (() -> Void)?)
}

// MARK: - Default implementation

extension Route {
  /// Register all routes
  public static func registerAll() {
    allCases.forEach { item in
      RouteManager.shared.register(pattern: item.urlPattern, viewControllerProvider: item.viewControllerProvider)
      RouteManager.shared.register(pattern: item.urlPattern, urlOpenHandlerProvider: item.urlOpenHandlerProvider)
    }
  }

  public var urlPattern: String {
    rawValue
  }

  public var urlOpenHandlerProvider: RouteURLOpenHandlerProvider {
    { arg in
      let (_, queryParameters) = arg
      show(queryParameters: queryParameters, context: nil, from: nil)
      return true
    }
  }

  public func viewController(queryParameters: [String: String] = [:], context: Any? = nil) -> UIViewController {
    guard let viewController = RouteManager.shared.viewController(for: "\(urlPattern)?\(queryParameters.queryParametersText)", context: context) else {
      fatalError("View Controller should be correctly get")
    }

    return viewController
  }

  public func show(queryParameters: [String: String] = [:], context: Any? = nil, from sourceViewController: UIViewController? = nil) {
    RouteManager.shared.show(for: "\(urlPattern)?\(queryParameters.queryParametersText)", context: context, from: sourceViewController)
  }

  public func showDetail(queryParameters: [String: String] = [:], context: Any? = nil, from sourceViewController: UIViewController? = nil, wrapIn navigationControllerClass: UINavigationController.Type? = nil) {
    RouteManager.shared.showDetail(for: "\(urlPattern)?\(queryParameters.queryParametersText)", context: context, from: sourceViewController, wrapIn: navigationControllerClass)
  }

  public func push(queryParameters: [String: String] = [:], context: Any? = nil, from navigationController: UINavigationController? = nil, animated: Bool = true) {
    RouteManager.shared.push(for: "\(urlPattern)?\(queryParameters.queryParametersText)", context: context, from: navigationController, animated: animated)
  }

  public func present(queryParameters: [String: String] = [:],
                      context: Any? = nil,
                      wrapIn navigationControllerClass: UINavigationController.Type? = nil,
                      animated: Bool = true,
                      completion: (() -> Void)? = nil)
  {
    RouteManager.shared.present(for: "\(urlPattern)?\(queryParameters.queryParametersText)", context: context, wrapIn: navigationControllerClass, animated: animated, completion: completion)
  }
}
