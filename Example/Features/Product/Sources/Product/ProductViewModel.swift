// ProductViewModel.swift
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

import Combine
import Foundation
import SwiftUI

class ProductViewModel: ObservableObject {
  // MARK: Lifecycle

  init(title: String, imageUrl: URL) {
    self.title = title
    self.imageUrl = imageUrl

    bindData()
  }

  // MARK: Internal

  var cancellables = Set<AnyCancellable>()

  @Published var title: String
  @Published var imageUrl: URL

  @Published var image = Image(systemName: "keyboard")

  lazy var session: URLSession = {
    let configuration: URLSessionConfiguration = .default
    configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
    return URLSession(configuration: configuration)
  }()

  func bindData() {
    $imageUrl
      .flatMap { url in
        self.session.dataTaskPublisher(for: url)
          .replaceError(with: (data: Data(), response: URLResponse()))
      }
      .compactMap { data, _ -> UIImage in
        UIImage(data: data) ?? UIImage()
      }
      .compactMap { image in
        Image(uiImage: image)
      }
      .receive(on: DispatchQueue.main)
      .assign(to: \.image, on: self)
      .store(in: &cancellables)
  }
}
