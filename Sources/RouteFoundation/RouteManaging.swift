// RouteManaging.swift
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

import OSLog
import ResolverFoundation
import SwiftUI
import UIKit

extension String {
  fileprivate static let http = "http"
  fileprivate static let https = "https"
}

// MARK: - RouteManaging

public protocol RouteManaging: AnyObject {
  var resolver: Resolver { get }

  /// Register a pattern with a ViewController provider
  func register(pattern: URLConvertible, viewControllerProvider: @escaping RouteViewControllerProvider)

  /// Register a pattern with a URLOpenHandler provider
  func register(pattern: URLConvertible, urlOpenHandlerProvider: @escaping RouteURLOpenHandlerProvider)

  /// view controller for a given url
  func viewController(for url: URLConvertible, context: Any?) -> UIViewController?

  /// any view for a given url
  @available(iOS 13.0, *)
  func view(for url: URLConvertible, context: Any?) -> AnyView?

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

extension RouteManaging {
  func identifier(from url: URLConvertible, type: Any.Type) -> String? {
    guard let urlPattern = [String.http, String.https].contains(url.urlValue?.scheme) ? .http : url.urlValue?.path.trimmingCharacters(in: CharacterSet(charactersIn: "/")) else {
      return nil
    }

    let tag = Int(bitPattern: ObjectIdentifier(type))
    let owner = Int(bitPattern: ObjectIdentifier(self))

    return "\(urlPattern)#\(tag)@\(owner)"
  }

  public func register(pattern: URLConvertible, viewControllerProvider: @escaping RouteViewControllerProvider) {
    guard let identifier = identifier(from: pattern, type: RouteViewControllerProvider.self) else {
      return
    }

    let resolverFactory = ResolverFactoryImpl(closure: viewControllerProvider)
    resolver.add(identifier: identifier, resolverFactory: resolverFactory)
  }

  @available(iOS 13, *)
  public func register(pattern: URLConvertible, viewProvider: @escaping RouteViewProvider) {
    guard let identifier = identifier(from: pattern, type: RouteViewProvider.self) else {
      return
    }

    let resolverFactory = ResolverFactoryImpl(closure: viewProvider)
    resolver.add(identifier: identifier, resolverFactory: resolverFactory)
  }

  public func register(pattern: URLConvertible, urlOpenHandlerProvider: @escaping RouteURLOpenHandlerProvider) {
    guard let identifier = identifier(from: pattern, type: RouteURLOpenHandlerProvider.self) else {
      return
    }

    let resolverFactory = ResolverFactoryImpl(closure: urlOpenHandlerProvider)
    resolver.add(identifier: identifier, resolverFactory: resolverFactory)
  }

  public func viewController(for url: URLConvertible, context: Any? = nil) -> UIViewController? {
    guard let identifier = identifier(from: url, type: RouteViewControllerProvider.self) else {
      return nil
    }

    let parameter: (url: URLConvertible, parameters: [String: String], context: Any?) = (url, url.queryParameters, context)

    do {
      return try resolver.resolve(ViewControllerResolverFactory.self, identifier: identifier, args: parameter)
    } catch {
      if #available(iOS 10.0, *) {
        os_log("%@", error.localizedDescription)
      }
      return nil
    }
  }

  @available(iOS 13.0, *)
  public func view(for url: URLConvertible, context: Any? = nil) -> AnyView? {
    guard let identifier = identifier(from: url, type: RouteViewProvider.self) else {
      return nil
    }

    let parameter: (url: URLConvertible, parameters: [String: String], context: Any?) = (url, url.queryParameters, context)

    do {
      return try resolver.resolve(ViewResolverFactory.self, identifier: identifier, args: parameter)
    } catch {
      os_log("%@", error.localizedDescription)
      return nil
    }
  }

  @discardableResult
  public func open(url: URLConvertible) -> Bool {
    handler(for: url)?() ?? false
  }

  func handler(for url: URLConvertible) -> RouteURLOpenHandler? {
    guard let identifier = identifier(from: url, type: RouteURLOpenHandlerProvider.self) else {
      return nil
    }

    let parameter: (url: URLConvertible, parameters: [String: String]) = (url, url.queryParameters)

    return { [weak self] in
      guard let self = self else {
        return false
      }
      do {
        return try self.resolver.resolve(URLOpenHandlerResolverFactory.self, identifier: identifier, args: parameter)
      } catch {
        return false
      }
    }
  }

  public func show(for url: URLConvertible, context: Any? = nil, from sourceViewController: UIViewController? = nil) {
    guard let destViewController = viewController(for: url, context: context) else {
      return
    }

    let fromViewController = sourceViewController ?? UIApplication.shared.topMostViewController
    DispatchQueue.main.async {
      fromViewController?.show(destViewController, sender: fromViewController)
    }
  }

  public func showDetail(for url: URLConvertible, context: Any? = nil, from sourceViewController: UIViewController? = nil, wrapIn navigationControllerClass: UINavigationController.Type? = nil) {
    guard let destViewController = viewController(for: url, context: context) else {
      return
    }

    guard let fromViewController = sourceViewController ?? UIApplication.shared.topMostViewController else {
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

    guard let fromViewController = sourceViewController ?? UIApplication.shared.topMostViewController else {
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
