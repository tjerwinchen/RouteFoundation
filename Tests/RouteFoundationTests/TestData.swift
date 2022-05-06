// TestData.swift
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
import UIKit

// MARK: - Context

struct Context {
  var name: String
}

// MARK: - WelcomeViewModel

struct WelcomeViewModel {
  var title: String
}

// MARK: - WelcomeViewController

class WelcomeViewController: UIViewController {
  // MARK: Lifecycle

  init(url: URLConvertible, params: [String: String], viewModel: WelcomeViewModel?) {
    self.url = url
    self.params = params
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    self.title = viewModel?.title
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  var url: URLConvertible
  var params: [String: String] = [:]
  var viewModel: WelcomeViewModel?
}

// MARK: - HomeViewController

class HomeViewController: UIViewController {
  // MARK: Lifecycle

  init(url: URLConvertible, params: [String: String], context: Context?) {
    self.url = url
    self.params = params
    self.context = context
    super.init(nibName: nil, bundle: nil)
    self.title = params["title"]
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  var url: URLConvertible
  var params: [String: String] = [:]
  var context: Context?
}

// MARK: - AppRoute

enum AppRoute: String, Route {
  case welcome
  case home

  // MARK: Internal

  var viewControllerProvider: RouteViewControllerProvider {
    switch self {
    case .welcome:
      return { arg -> UIViewController in
        let (url, params, context) = arg
        return WelcomeViewController(url: url, params: params, viewModel: context as? WelcomeViewModel)
      }
    case .home:
      return { arg -> UIViewController in
        let (url, params, context) = arg
        return HomeViewController(url: url, params: params, context: context as? Context)
      }
    }
  }
}

extension Collection {
  /// Returns the element at the specified index if it is within bounds, otherwise nil.
  subscript(safe index: Index) -> Iterator.Element? {
    indices.contains(index) ? self[index] : nil
  }
}

// MARK: - AwesomeFeature

struct AwesomeFeature {
  let url: URLConvertible
  let parameters: [String: String]
  let context: [String]
}
