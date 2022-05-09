// Resolver.swift
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

// MARK: - Resolver

/// A lightweight resolver for DI
public final class Resolver {
  // MARK: Lifecycle

  init() {}

  // MARK: Public

  public static let shared = Resolver()

  public func add<T: ResolverFactory>(identifier: String, resolverFactory: T) {
    $resolverFactories.updateValue(resolverFactory, forKey: identifier)
  }

  public func factory<T: ResolverFactory>(_ type: T.Type = T.self, for identifier: String) -> T? {
    $resolverFactories[identifier] as? T
  }

  public func resolve<T: ResolverFactory>(_ type: T.Type = T.self, identifier: String, args: T.Args) throws -> T.Service {
    guard let resolverFactory: T = factory(for: identifier) else {
      throw ResolverError.notFound(factoryKey: identifier)
    }

    return resolverFactory.resolve(args: args)
  }

  // MARK: Internal

  @ConcurrentDictionary
  var resolverFactories: [String: Any] = [:]
}
