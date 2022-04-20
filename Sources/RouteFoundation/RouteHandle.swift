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
  /// All view controller providers
  var viewControllerProviders: [String: Route.ViewControllerProvider] { get }

  /// All url open hander providers
  var urlOpenHandlerProviders: [String: Route.URLOpenHandlerProvider] { get }

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
  public func viewController(for url: URLConvertible, context: Any? = nil) -> UIViewController? {
    guard let urlPattern = url.urlValue?.path.trimmingCharacters(in: CharacterSet(charactersIn: "/")) else {
      return nil
    }
    guard let provider = viewControllerProviders[urlPattern] else {
      return nil
    }
    return provider(url, url.queryParameters, context)
  }

  @discardableResult
  public func open(url: URLConvertible) -> Bool {
    handler(for: url)?() ?? false
  }

  func handler(for url: URLConvertible) -> Route.URLOpenHandler? {
    guard let urlPattern = url.urlValue?.path.trimmingCharacters(in: CharacterSet(charactersIn: "/")) else {
      return nil
    }
    guard let handler = urlOpenHandlerProviders[urlPattern] else {
      return nil
    }
    return { handler(url, url.queryParameters) }
  }

  public func show(for url: URLConvertible, context: Any? = nil, from sourceViewController: UIViewController? = nil) {
    guard let destViewController = viewController(for: url, context: context) else {
      return
    }

    let fromViewController = sourceViewController ?? UIApplication.sharedInstance?.topViewController
    fromViewController?.show(destViewController, sender: fromViewController)
  }

  public func showDetail(for url: URLConvertible, context: Any? = nil, from sourceViewController: UIViewController? = nil, wrapIn navigationControllerClass: UINavigationController.Type? = nil) {
    guard let destViewController = viewController(for: url, context: context) else {
      return
    }

    guard let fromViewController = sourceViewController ?? UIApplication.sharedInstance?.topViewController else {
      return
    }

    var viewControllerToPresent = destViewController

    if let navigationControllerClass = navigationControllerClass, !(fromViewController.isKind(of: UINavigationController.self)) {
      viewControllerToPresent = navigationControllerClass.init(rootViewController: destViewController)
    }

    fromViewController.showDetailViewController(viewControllerToPresent, sender: fromViewController)
  }

  public func push(for url: URLConvertible, context: Any? = nil, from navigationController: UINavigationController? = nil, animated: Bool = true) {
    guard let destViewController = viewController(for: url, context: context) else {
      return
    }

    guard let navigationController = navigationController ?? UIApplication.sharedInstance?.foregroundNavigationController else {
      return
    }

    navigationController.pushViewController(destViewController, animated: animated)
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

    guard let fromViewController = sourceViewController ?? UIApplication.sharedInstance?.topViewController else {
      return
    }

    var viewControllerToPresent = destViewController

    if let navigationControllerClass = navigationControllerClass, !(fromViewController.isKind(of: UINavigationController.self)) {
      viewControllerToPresent = navigationControllerClass.init(rootViewController: destViewController)
    }

    fromViewController.present(viewControllerToPresent, animated: animated, completion: completion)
  }
}
