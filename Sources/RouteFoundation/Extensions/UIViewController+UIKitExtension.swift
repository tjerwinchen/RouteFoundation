// UIViewController+UIKitExtension.swift
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

import UIKit

extension UIKitExtension where Self: UIViewController {
  var topMostViewController: UIViewController? {
    // presented view controller
    if let presentedViewController = presentedViewController {
      return presentedViewController.topMostViewController
    }

    // UITabBarController
    if let tabBarController = self as? UITabBarController,
       let selectedViewController = tabBarController.selectedViewController
    {
      return selectedViewController.topMostViewController
    }

    // UINavigationController
    if let navigationController = self as? UINavigationController,
       let visibleViewController = navigationController.visibleViewController
    {
      return visibleViewController.topMostViewController
    }

    // UIPageController
    if let pageViewController = self as? UIPageViewController,
       pageViewController.viewControllers?.count == 1
    {
      return pageViewController.viewControllers?.first?.topMostViewController
    }

    // child view controller
    for subview in view?.subviews ?? [] {
      if let childViewController = subview.next as? UIViewController {
        return childViewController.topMostViewController
      }
    }

    return self
  }

  var foregroundNavigationController: UINavigationController? {
    topMostViewController?.view.foregroundNavigationController
  }
}

// MARK: - UIViewController + UIKitExtension

extension UIViewController: UIKitExtension {}
