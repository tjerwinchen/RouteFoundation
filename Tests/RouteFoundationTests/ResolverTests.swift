// ResolverTests.swift
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
@testable import RouteFoundation
import XCTest

// MARK: - ResolverTests

final class ResolverTests: XCTestCase {
  typealias AwesomeFeatureFactory = ((url: URLConvertible, parameters: [String: String], context: Any?)) -> AwesomeFeature?

  override class func setUp() {
    super.setUp()
  }

  // swiftlint:disable force_cast
  func test_optionalParameters() {
    let factory: AwesomeFeatureFactory = { arg -> AwesomeFeature? in
      AwesomeFeature(url: arg.url, parameters: arg.parameters, context: arg.context as! [String])
    }

    let resolverFactory = ResolverFactoryImpl(closure: factory)

    Resolver.shared.add(identifier: "awesome-feature", resolverFactory: resolverFactory)

    do {
      let args: (url: URLConvertible, parameters: [String: String], context: Any?) = (url: "https://apple.com", parameters: ["param": "param"], context: ["1", "2"])
      let awesomeFeature = try Resolver.shared.resolve(type(of: resolverFactory).self, identifier: "awesome-feature", args: args)

      XCTAssertEqual(awesomeFeature?.url.urlStringValue, "https://apple.com")
      XCTAssertEqual(awesomeFeature?.parameters, ["param": "param"])
      XCTAssertEqual(awesomeFeature?.context, ["1", "2"])
    } catch {
      XCTFail("Unexpected error = \(error)")
    }
  }

  func test_nonoptionalArgs() {
    let identifier = "non-optional-args"
    Resolver.shared.add(identifier: identifier, resolverFactory: ResolverFactoryImpl(closure: { (num1: Int, num2: Int) -> Int in
      num1 + num2
    }))

    do {
      let sum = try Resolver.shared.resolve(ResolverFactoryImpl<(Int, Int), Int>.self, identifier: identifier, args: (1, 2))
      XCTAssertEqual(sum, 3)
    } catch {
      XCTFail("Unexpected error = \(error)")
    }
  }

  func test_voidArgs() {
    let identifier = "void-args"

    let resolverFactory = ResolverFactoryImpl(closure: {
      5
    })

    Resolver.shared.add(identifier: identifier, resolverFactory: resolverFactory)

    do {
      let value = try Resolver.shared.resolve(type(of: resolverFactory), identifier: identifier, args: ())
      XCTAssertEqual(value, 5)
    } catch {
      XCTFail("Unexpected error = \(error)")
    }
  }
}
