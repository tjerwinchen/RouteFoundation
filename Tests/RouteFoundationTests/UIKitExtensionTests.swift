// UIKitExtensionTests.swift
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
import XCTest

final class UIKitExtensionTests: XCTestCase {
  class HomeViewController: UIViewController {}
  class HomeDetailViewController: UIViewController {}
  class ProfileViewController: UIViewController {}
  class ReminderViewController: UIViewController {}
  class PageExampleViewController: UIViewController {}

  class PageViewController: UIPageViewController {
    let pageExampleViewController1 = PageExampleViewController()
    let pageExampleViewController2 = PageExampleViewController()

    override func viewDidLoad() {
      super.viewDidLoad()
      setViewControllers([pageExampleViewController1], direction: .forward, animated: false, completion: nil)
    }
  }

  lazy var window: UIWindow = {
    let window = UIWindow()
    window.rootViewController = rootNavigationController
    return window
  }()

  lazy var rootNavigationController = UINavigationController(rootViewController: tabBarController)

  lazy var presentedNavigationController = UINavigationController(rootViewController: reminderViewController)

  let tabBarController = UITabBarController()
  let homeViewController = HomeViewController()
  let homeDetailViewController = HomeDetailViewController()
  let profileViewController = ProfileViewController()
  let pageViewController = PageViewController()
  let reminderViewController = ReminderViewController()

  override func setUp() {
    // Prepare a view hierarchy
    // window -> nav -> tabbar -> home    -> homeDetail
    //                         -> profile
    //                         -> page
    //           nav -> Reminder
    super.setUp()

    tabBarController.viewControllers = [homeViewController, profileViewController, pageViewController]
    rootNavigationController.pushViewController(homeDetailViewController, animated: false)

    window.rootViewController?.present(presentedNavigationController, animated: false)
  }

  func test_homeDetail() {
    XCTAssertEqual(homeDetailViewController.topMostViewController, homeDetailViewController)
    XCTAssertEqual(homeDetailViewController.view.foregroundNavigationController, rootNavigationController)
  }

  func test_home() {
    XCTAssertEqual(homeViewController.topMostViewController, homeViewController)
    XCTAssertEqual(homeViewController.view.foregroundNavigationController, rootNavigationController)
  }

  func test_reminder() {
    XCTAssertEqual(reminderViewController.topMostViewController, reminderViewController)
    XCTAssertEqual(reminderViewController.view.foregroundNavigationController, presentedNavigationController)
  }

  func test_nav() {
    XCTAssertEqual(rootNavigationController.view.foregroundNavigationController, rootNavigationController)
    XCTAssertEqual(presentedNavigationController.topMostViewController, reminderViewController)
    XCTAssertEqual(presentedNavigationController.view.foregroundNavigationController, presentedNavigationController)

    tabBarController.selectedIndex = 0
    XCTAssertEqual(rootNavigationController.topMostViewController, homeDetailViewController)

    // The TabBar View is obstructed by HomeDetailView
    tabBarController.selectedIndex = 1
    XCTAssertEqual(rootNavigationController.topMostViewController, homeDetailViewController)
  }

  func test_tabbar() {
    XCTAssertEqual(tabBarController.view.foregroundNavigationController, rootNavigationController)

    tabBarController.selectedIndex = 0
    XCTAssertEqual(tabBarController.topMostViewController, homeViewController)
    tabBarController.selectedIndex = 1
    XCTAssertEqual(tabBarController.topMostViewController, profileViewController)
    tabBarController.selectedIndex = 2
    XCTAssertEqual(tabBarController.topMostViewController, pageViewController.pageExampleViewController1)
  }
}
