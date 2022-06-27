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
import UIKit

// protocol Routing where Self: UIViewController {
//  func setup(url: URLConvertible, queryParameters: [String: String], context: Any?)
// }
//
// extension RouteSampleTwoViewController {
//
//  convenience init(url: URLConvertible, queryParameters: [String: String], context: Any?) {
//    self.init()
//    self.setup(url: url, queryParameters: queryParameters, context: context)
//  }
// }
//
// class RouteSampleTwoViewController: UITableViewController, Routing {
//  func setup(url: URLConvertible, queryParameters: [String : String], context: Any?) {
//
//  }
//
//  override func viewDidLoad() {
//    super.viewDidLoad()
//  }
// }

class HomeViewController: UITableViewController {
  // MARK: Lifecycle

  init(viewModel: HomeViewModel) {
    self.viewModel = viewModel
    super.init(style: .plain)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  var viewModel: HomeViewModel

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

    view.backgroundColor = .systemBackground
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    4
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    cell.textLabel?.text = "routes[indexPath.row].rawValue"
    cell.accessoryType = .disclosureIndicator
    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    // route.show(queryParameters: ["title": "Show"])
  }
}
