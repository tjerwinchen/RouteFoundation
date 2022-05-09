//
//  File.swift
//  
//
//  Created by Theo Chen on 2022/5/9.
//

import UIKit
@testable import RouteFoundation
import XCTest

final class UIKitExtensionTests: XCTestCase {
  class HomeViewController: UIViewController {}
  class HomeDetailViewController: UIViewController {}
  class ProfileViewController: UIViewController {}
  class ReminderViewController: UIViewController {}
  
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
  let reminderViewController = ReminderViewController()

  override func setUp() {
    // Prepare a view hierarchy
    // window -> nav -> tabbar -> home    -> homeDetail
    //                         -> profile
    //           nav -> Reminder
    super.setUp()

    tabBarController.viewControllers = [homeViewController, profileViewController]
    rootNavigationController.pushViewController(homeDetailViewController, animated: false)

    window.rootViewController?.present(presentedNavigationController, animated: false)
  }

  func test_homeDetail() {
    XCTAssertEqual(homeDetailViewController.topMostViewController, homeDetailViewController)
    XCTAssertEqual(homeDetailViewController.foregroundNavigationController, rootNavigationController)
  }

  func test_home() {
    XCTAssertEqual(homeViewController.topMostViewController, homeViewController)
    XCTAssertEqual(homeViewController.foregroundNavigationController, rootNavigationController)
  }

  func test_reminder() {
    XCTAssertEqual(reminderViewController.topMostViewController, reminderViewController)
    XCTAssertEqual(reminderViewController.foregroundNavigationController, presentedNavigationController)
  }

  func test_nav() {
    XCTAssertEqual(rootNavigationController.foregroundNavigationController, rootNavigationController)
    XCTAssertEqual(presentedNavigationController.topMostViewController, reminderViewController)
    XCTAssertEqual(presentedNavigationController.foregroundNavigationController, presentedNavigationController)

    tabBarController.selectedIndex = 0
    XCTAssertEqual(rootNavigationController.topMostViewController, homeDetailViewController)

    // The TabBar View is obstructed by HomeDetailView
    tabBarController.selectedIndex = 1
    XCTAssertEqual(rootNavigationController.topMostViewController, homeDetailViewController)
  }

  func test_tabbar() {
    XCTAssertEqual(tabBarController.foregroundNavigationController, rootNavigationController)

    tabBarController.selectedIndex = 0
    XCTAssertEqual(tabBarController.topMostViewController, homeViewController)
    tabBarController.selectedIndex = 1
    XCTAssertEqual(tabBarController.topMostViewController, profileViewController)
  }
}
