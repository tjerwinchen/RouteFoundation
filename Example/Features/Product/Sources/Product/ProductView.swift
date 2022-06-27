// ProductView.swift
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

import SwiftUI

// MARK: - ProductView

public struct ProductView: View {
  // MARK: Lifecycle

  init(viewModel: ProductViewModel) {
    self.viewModel = viewModel
  }

  // MARK: Public

  public var body: some View {
    VStack {
      Text(viewModel.title)

      viewModel.image
        .resizable()
        .aspectRatio(contentMode: .fit)
    }
  }

  // MARK: Internal

  @ObservedObject
  var viewModel: ProductViewModel
}

#if DEBUG

  struct HomeView_Previews: PreviewProvider {
    static let viewModel = ProductViewModel(title: "Title", imageUrl: URL(string: "https://www.apple.com/newsroom/images/product/ipad/standard/Apple-iPad-Air-Magic-Keyboard-220308_big_carousel.jpg.slideshow-large_2x.jpg")!)

    static var previews: some View {
      ProductView(viewModel: Self.viewModel)
    }
  }

#endif
