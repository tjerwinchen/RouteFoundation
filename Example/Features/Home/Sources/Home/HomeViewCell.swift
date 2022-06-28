// HomeViewCell.swift
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
import UIKit

class HomeViewCell: UICollectionViewCell {
  // MARK: Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .systemBackground

    addSubview(stackView)

    NSLayoutConstraint.activate([
      stackView.leadingAnchor.constraint(
        equalTo: readableContentGuide.leadingAnchor
      ),
      stackView.trailingAnchor.constraint(
        equalTo: readableContentGuide.trailingAnchor
      ),
      stackView.topAnchor.constraint(
        equalTo: readableContentGuide.topAnchor,
        constant: 10
      ),
      stackView.bottomAnchor.constraint(
        equalTo: readableContentGuide.bottomAnchor,
        constant: -10
      ),
    ])
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  static var reuseIdentifier: String {
    String(describing: Self.self)
  }

  var cancellables = Set<AnyCancellable>()

  lazy var stackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [thumbnailView, titleLabel])
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    return stackView
  }()

  lazy var thumbnailView = UIImageView()
  lazy var titleLabel = UILabel()

  var content: Content? {
    didSet {
      let session = URLSession(configuration: .default)
      if let url = content?.thumbnail {
        session.dataTaskPublisher(for: url)
          .map { data, _ in
            UIImage(data: data)
          }
          .catch { _ in
            Just(UIImage())
          }
          .receive(on: DispatchQueue.main)
          .sink { [weak self] in
            self?.thumbnailView.image = $0
          }
          .store(in: &cancellables)
      }
      titleLabel.text = content?.title
    }
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    cancellables = Set<AnyCancellable>()
  }
}
