// HomeComponent.swift
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

import ResolverFoundation
import RouteFoundation
import SwiftUI
import UIKit

// MARK: - HomeComponent

public class HomeComponent {
  // MARK: Lifecycle

  public init(title: String) {
    let viewModel = HomeViewModel(title: title, categories: allCategories)
    self.viewController = HomeViewController(viewModel: viewModel, routeManager: routeManager)
    self.view = AnyView(HomeView(viewModel: viewModel, routeManager: routeManager))
  }

  // MARK: Public

  public private(set) var viewController = UIViewController()

  public private(set) var view = AnyView(EmptyView())

  // MARK: Internal

  var routeManager: RouteManager {
    (try? Resolver.shared.resolve(ResolverFactoryImpl<Void, RouteManager>.self, identifier: "\(String(describing: Self.self)).\(#function)", args: ())) ?? RouteManager.shared
  }
}

let allCategories: [Category] = [
  Category(title: "718", contents: [
    Content(
      title: "565,000 元起 *",
      thumbnail: URL(string: "https://files.porsche.com/filestore/image/multimedia/none/carrange-flyout-718/small/57ad32c8-ca23-11ec-80ef-005056bbdc38;sM;c892;gc/porsche-small.jpg"),
      link: URL(string: "product?title=iPad&image_url=https://www.apple.com/newsroom/images/product/ipad/standard/Apple-iPad-Air-Magic-Keyboard-220308_big_carousel.jpg.slideshow-large_2x.jpg")
    ),
  ]),
  Category(title: "911", contents: [
    Content(
      title: "1,298,000 元起 *",
      thumbnail: URL(string: "https://files.porsche.com/filestore/image/multimedia/none/carrange-flyout-911/small/3cf76e8c-6694-11e9-80c4-005056bbdc38;sQ;c1693;gc/porsche-small.jpg"),
      link: URL(string: "https://www.porsche.com/china/zh/models/911/911-models/")
    ),
    Content(
      title: "1,298,000 元起 *",
      thumbnail: URL(string: "https://files.porsche.com/filestore/image/multimedia/none/carrange-flyout-911/small/3cf76e8c-6694-11e9-80c4-005056bbdc38;sQ;c1693;gc/porsche-small.jpg"),
      link: URL(string: "https://www.porsche.com/china/zh/models/911/911-models/")
    ),
  ]),
  Category(title: "Taycan", contents: [
    Content(
      title: "898,000 元起 *",
      thumbnail: URL(string: "https://files.porsche.com/filestore/image/multimedia/none/carrange-flyout-taycan/small/094d1c1c-bab0-11e9-80c4-005056bbdc38;sQ;c1693;gc/porsche-small.jpg"),
      link: URL(string: "https://www.porsche.com/china/zh/models/taycan/taycan-models/")
    ),
    Content(
      title: "898,000 元起 *",
      thumbnail: URL(string: "https://files.porsche.com/filestore/image/multimedia/none/carrange-flyout-taycan/small/094d1c1c-bab0-11e9-80c4-005056bbdc38;sQ;c1693;gc/porsche-small.jpg"),
      link: URL(string: "https://www.porsche.com/china/zh/models/taycan/taycan-models/")
    ),
  ]),
  Category(title: "Macan", contents: [
    Content(
      title: "573,000 元起 *",
      thumbnail: URL(string: "https://files.porsche.com/filestore/image/multimedia/none/carrange-flyout-macan/small/47db3c6d-e3d7-11eb-80d9-005056bbdc38;sM;c892;gc/porsche-small.jpg"),
      link: URL(string: "https://www.porsche.com/china/zh/models/macan/macan-models/")
    ),
    Content(
      title: "573,000 元起 *",
      thumbnail: URL(string: "https://files.porsche.com/filestore/image/multimedia/none/carrange-flyout-macan/small/47db3c6d-e3d7-11eb-80d9-005056bbdc38;sM;c892;gc/porsche-small.jpg"),
      link: URL(string: "https://www.porsche.com/china/zh/models/macan/macan-models/")
    ),
    Content(
      title: "573,000 元起 *",
      thumbnail: URL(string: "https://files.porsche.com/filestore/image/multimedia/none/carrange-flyout-macan/small/47db3c6d-e3d7-11eb-80d9-005056bbdc38;sM;c892;gc/porsche-small.jpg"),
      link: URL(string: "https://www.porsche.com/china/zh/models/macan/macan-models/")
    ),
    Content(
      title: "573,000 元起 *",
      thumbnail: URL(string: "https://files.porsche.com/filestore/image/multimedia/none/carrange-flyout-macan/small/47db3c6d-e3d7-11eb-80d9-005056bbdc38;sM;c892;gc/porsche-small.jpg"),
      link: URL(string: "https://www.porsche.com/china/zh/models/macan/macan-models/")
    ),
  ]),
]
