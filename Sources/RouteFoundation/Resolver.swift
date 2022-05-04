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

final class Resolver {
  // MARK: Lifecycle

  private init() {}

  // MARK: Internal

  static let shared = Resolver()

  @ConcurrentDictionary
  var factories: [String: Any] = [:]

  func add<FactoryInput, FactoryOutput>(identifier: String, factory: @escaping (FactoryInput) -> FactoryOutput) {
    $factories.updateValue(factory, forKey: identifier)
  }

  func factory<FactoryInput, FactoryOutput>(for identifier: String, factoryInput: FactoryInput.Type, factoryOutput: FactoryOutput.Type) -> ((FactoryInput) -> FactoryOutput)? {
    $factories[identifier] as? ((FactoryInput) -> FactoryOutput)
  }

  func resolve<FactoryInput, FactoryOutput>(identifier: String, factoryInput: FactoryInput.Type, factoryOutput: FactoryOutput.Type, input: FactoryInput) throws -> FactoryOutput {
    guard let factory = factory(for: identifier, factoryInput: FactoryInput.self, factoryOutput: FactoryOutput.self) else {
      throw ResolverError.notFound(factoryKey: identifier)
    }

    return factory(input)
  }
}

// MARK: - ResolverError

enum ResolverError: Error {
  case notFound(factoryKey: String)
}

// MARK: CustomStringConvertible

extension ResolverError: CustomStringConvertible {
  var description: String {
    switch self {
    case let .notFound(factoryKey):
      return "The factory \(factoryKey) not found."
    }
  }
}
