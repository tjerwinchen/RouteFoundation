// RootComponent.swift
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

import Foundation
import Home
import Product
import ResolverFoundation
import RouteFoundation

// MARK: - RootComponent

public class RootComponent {
  // MARK: Lifecycle

  public init() {}

  // MARK: Public

  public var routeManager: RouteManager {
    RouteManager.shared
  }
}

extension RootComponent {
  public static func register() {
    RootRoute.registerAll()
    HomeRoute.registerAll()
    ProductRoute.registerAll()

    let rootComponent = RootComponent()

    Resolver.shared.add(identifier: "HomeComponent.routeManager", resolverFactory: ResolverFactoryImpl {
      rootComponent.routeManager
    })

    Resolver.shared.add(identifier: "ProductComponent.routeManager", resolverFactory: ResolverFactoryImpl {
      rootComponent.routeManager
    })
  }
}
