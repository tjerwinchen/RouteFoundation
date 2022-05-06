// URLConvertibleTests.swift
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

// MARK: - URLConvertibleTests

final class URLConvertibleTests: XCTestCase {
  func test_all() throws {
    let url1 = "特斯拉.com/vehicles?id=1&vin=212241AB56D1F"
    let url2 = "特斯拉.com/vehicles/?id=1&vin=212241AB56D1F"

    XCTAssertEqual(url1.urlValue?.absoluteString, "%E7%89%B9%E6%96%AF%E6%8B%89.com/vehicles?id=1&vin=212241AB56D1F")
    XCTAssertEqual(url2.urlValue?.absoluteString, "%E7%89%B9%E6%96%AF%E6%8B%89.com/vehicles/?id=1&vin=212241AB56D1F")
    XCTAssertEqual(url1.queryParameters, ["id": "1", "vin": "212241AB56D1F"])
  }
}
