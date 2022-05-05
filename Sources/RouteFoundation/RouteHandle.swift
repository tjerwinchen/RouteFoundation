// RouteHandle.swift
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

// MARK: - RouteHandle

public protocol RouteHandle: AnyObject {
  /// Register a pattern with a ViewController provider
  func register(pattern: URLConvertible, viewControllerProvider: @escaping Route.ViewControllerProvider)

  /// Register a pattern with a URLOpenHandler provider
  func register(pattern: URLConvertible, urlOpenHandlerProvider: @escaping Route.URLOpenHandlerProvider)

  /// view controller for a given url
  func viewController(for url: URLConvertible, context: Any?) -> UIViewController?

  /// open a new view controller for a given url
  func open(url: URLConvertible) -> Bool

  /// show a new view controller for a given url
  func show(for url: URLConvertible, context: Any?, from sourceViewController: UIViewController?)

  /// show detail a new view controller for a given url
  func showDetail(for url: URLConvertible, context: Any?, from sourceViewController: UIViewController?, wrapIn navigationControllerClass: UINavigationController.Type?)

  /// push a new view controller for a given url
  func push(for url: URLConvertible, context: Any?, from navigationController: UINavigationController?, animated: Bool)

  /// present a new view controller for a given url
  func present(for url: URLConvertible, context: Any?,
               from sourceViewController: UIViewController?,
               wrapIn navigationControllerClass: UINavigationController.Type?,
               animated: Bool,
               completion: (() -> Void)?)
}

// MARK: - Default Implementation

extension RouteHandle {
  func identifier(from url: URLConvertible, type: Any.Type) -> String? {
    guard let urlPattern = url.urlValue?.path.trimmingCharacters(in: CharacterSet(charactersIn: "/")) else {
      return nil
    }

    let tag = Int(bitPattern: ObjectIdentifier(type))

    return "\(urlPattern)#\(tag)"
  }

  public func register(pattern: URLConvertible, viewControllerProvider: @escaping Route.ViewControllerProvider) {
    guard let identifier = identifier(from: pattern, type: Route.ViewControllerProvider.self) else {
      return
    }

    Resolver.shared.add(identifier: identifier, factory: viewControllerProvider)
  }

  public func register(pattern: URLConvertible, urlOpenHandlerProvider: @escaping Route.URLOpenHandlerProvider) {
    guard let identifier = identifier(from: pattern, type: Route.URLOpenHandlerProvider.self) else {
      return
    }

    Resolver.shared.add(identifier: identifier, factory: urlOpenHandlerProvider)
  }

  public func viewController(for url: URLConvertible, context: Any? = nil) -> UIViewController? {
    guard let identifier = identifier(from: url, type: Route.ViewControllerProvider.self) else {
      return nil
    }

    let parameter: Route.ViewControllerProviderParameters = (url, url.queryParameters, context)

    do {
      return try Resolver.shared.resolve(identifier: identifier, type: UIViewController?.self, input: parameter)
    } catch {
      return nil
    }
  }

  @discardableResult
  public func open(url: URLConvertible) -> Bool {
    handler(for: url)?() ?? false
  }

  func handler(for url: URLConvertible) -> Route.URLOpenHandler? {
    guard let identifier = identifier(from: url, type: Route.URLOpenHandlerProvider.self) else {
      return nil
    }

    let parameter: Route.URLOpenHandlerProviderParameters = (url, url.queryParameters)

    return {
      do {
        return try Resolver.shared.resolve(identifier: identifier, type: Bool.self, input: parameter)
      } catch {
        return false
      }
    }
  }

  public func show(for url: URLConvertible, context: Any? = nil, from sourceViewController: UIViewController? = nil) {
    guard let destViewController = viewController(for: url, context: context) else {
      return
    }

    let fromViewController = sourceViewController ?? UIApplication.shared.topViewController
    DispatchQueue.main.async {
      fromViewController?.show(destViewController, sender: fromViewController)
    }
  }

  public func showDetail(for url: URLConvertible, context: Any? = nil, from sourceViewController: UIViewController? = nil, wrapIn navigationControllerClass: UINavigationController.Type? = nil) {
    guard let destViewController = viewController(for: url, context: context) else {
      return
    }

    guard let fromViewController = sourceViewController ?? UIApplication.shared.topViewController else {
      return
    }

    var viewControllerToPresent = destViewController

    if let navigationControllerClass = navigationControllerClass, !(fromViewController.isKind(of: UINavigationController.self)) {
      viewControllerToPresent = navigationControllerClass.init(rootViewController: destViewController)
    }

    DispatchQueue.main.async {
      fromViewController.showDetailViewController(viewControllerToPresent, sender: fromViewController)
    }
  }

  public func push(for url: URLConvertible, context: Any? = nil, from navigationController: UINavigationController? = nil, animated: Bool = true) {
    guard let destViewController = viewController(for: url, context: context) else {
      return
    }

    guard let navigationController = navigationController ?? UIApplication.shared.foregroundNavigationController else {
      return
    }

    DispatchQueue.main.async {
      navigationController.pushViewController(destViewController, animated: animated)
    }
  }

  public func present(for url: URLConvertible, context: Any? = nil,
                      from sourceViewController: UIViewController? = nil,
                      wrapIn navigationControllerClass: UINavigationController.Type? = nil,
                      animated: Bool = true,
                      completion: (() -> Void)? = nil)
  {
    guard let destViewController = viewController(for: url, context: context) else {
      return
    }

    guard let fromViewController = sourceViewController ?? UIApplication.shared.topViewController else {
      return
    }

    var viewControllerToPresent = destViewController

    if let navigationControllerClass = navigationControllerClass, !(fromViewController.isKind(of: UINavigationController.self)) {
      viewControllerToPresent = navigationControllerClass.init(rootViewController: destViewController)
    }

    DispatchQueue.main.async {
      fromViewController.present(viewControllerToPresent, animated: animated, completion: completion)
    }
  }
}
