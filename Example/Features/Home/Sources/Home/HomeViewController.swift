// HomeViewController.swift
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
import RouteFoundation
import UIKit

// MARK: - HomeViewController

class HomeViewController: UICollectionViewController {
  // MARK: Lifecycle

  init(viewModel: HomeViewModel, routeManager: RouteManager) {
    self.viewModel = viewModel
    self.routeManager = routeManager
    super.init(collectionViewLayout: UICollectionViewFlowLayout())
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  typealias DataSource = UICollectionViewDiffableDataSource<Category, Content>
  typealias Snapshot = NSDiffableDataSourceSnapshot<Category, Content>

  var cancellables = Set<AnyCancellable>()

  let routeManager: RouteManager

  @Published
  var viewModel: HomeViewModel

  lazy var dataSource: DataSource = {
    let dataSource = DataSource(
      collectionView: collectionView,
      cellProvider: { collectionView, indexPath, content ->
        UICollectionViewCell? in
        let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: HomeViewCell.reuseIdentifier,
          for: indexPath
        ) as? HomeViewCell
        cell?.content = content
        return cell
      }
    )

    dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
      guard kind == UICollectionView.elementKindSectionHeader else {
        return nil
      }
      let section = self.dataSource.snapshot()
        .sectionIdentifiers[indexPath.section]
      let view = collectionView.dequeueReusableSupplementaryView(
        ofKind: kind,
        withReuseIdentifier: SectionHeaderReusableView.reuseIdentifier,
        for: indexPath
      ) as? SectionHeaderReusableView
      view?.titleLabel.text = section.title
      return view
    }

    return dataSource
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    onLoad()
  }

  func onLoad() {
    view.backgroundColor = .systemBackground
    configureLayout()

    $viewModel
      .receive(on: DispatchQueue.main)
      .sink { [weak self] currentViewModel in
        self?.reload(viewModel: currentViewModel)
      }
      .store(in: &cancellables)
  }

  func reload(viewModel: HomeViewModel) {
    title = viewModel.title

    var snapshot = Snapshot()
    snapshot.appendSections(viewModel.categories)
    viewModel.categories.forEach { category in
      snapshot.appendItems(category.contents, toSection: category)
    }
    dataSource.apply(snapshot, animatingDifferences: false)
  }

  // MARK: Private

  private var searchController = UISearchController(searchResultsController: nil)
}

extension HomeViewController {
  override func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    guard let content = dataSource.itemIdentifier(for: indexPath) else {
      return
    }

    if let deepLink = content.link {
      routeManager.show(for: deepLink)
    }
  }
}

extension HomeViewController {
  private func configureLayout() {
    collectionView.register(
      SectionHeaderReusableView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: SectionHeaderReusableView.reuseIdentifier
    )
    collectionView.register(HomeViewCell.self, forCellWithReuseIdentifier: HomeViewCell.reuseIdentifier)
    collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection? in
      let size = NSCollectionLayoutSize(
        widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
        heightDimension: NSCollectionLayoutDimension.absolute(280)
      )
      let itemCount = 1
      let item = NSCollectionLayoutItem(layoutSize: size)
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: itemCount)
      let section = NSCollectionLayoutSection(group: group)
      section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
      section.interGroupSpacing = 10
      // Supplementary header view setup
      let headerFooterSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .estimated(20)
      )
      let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
        layoutSize: headerFooterSize,
        elementKind: UICollectionView.elementKindSectionHeader,
        alignment: .top
      )
      section.boundarySupplementaryItems = [sectionHeader]
      return section
    })
  }

  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    coordinator.animate(alongsideTransition: { _ in
      self.collectionView.collectionViewLayout.invalidateLayout()
    }, completion: nil)
  }
}
