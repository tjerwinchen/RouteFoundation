// RouteRegister.swift
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

import Foundation

// MARK: - RouteRegister

protocol RouteRegister: AnyObject {
  var viewControllerProviders: [String: Route.ViewControllerProvider] { get set }
  var urlOpenHandlerProviders: [String: Route.URLOpenHandlerProvider] { get set }

  /// Register a pattern with a ViewController provider
  func register(pattern: URLConvertible, viewControllerProvider: @escaping Route.ViewControllerProvider)

  /// Register a pattern with a URLOpenHandler provider
  func register(pattern: URLConvertible, urlOpenHandlerProvider: @escaping Route.URLOpenHandlerProvider)
}

extension RouteRegister {
  func register(pattern: URLConvertible, viewControllerProvider: @escaping Route.ViewControllerProvider) {
    guard let pattern = pattern.urlValue?.path else {
      return
    }

    viewControllerProviders[pattern] = viewControllerProvider
  }

  func register(pattern: URLConvertible, urlOpenHandlerProvider: @escaping Route.URLOpenHandlerProvider) {
    guard let pattern = pattern.urlValue?.path else {
      return
    }
    urlOpenHandlerProviders[pattern] = urlOpenHandlerProvider
  }
}
