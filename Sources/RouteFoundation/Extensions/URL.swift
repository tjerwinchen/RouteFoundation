// URL.swift
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

// MARK: - URLQueryParameterStringConvertible

protocol URLQueryParameterStringConvertible {
  /// This computed property returns a query parameters string from the given `Dictionary`.
  ///
  /// For example, if the input is
  ///
  ///     ["day": "Tuesday", "month": "January"]
  ///
  /// The output string will be
  ///
  ///     "day=Tuesday&month=January"
  ///
  /// - Returns: The computed parameters string.
  var queryParametersText: String { get }
}

extension URLQueryParameterStringConvertible where Self == [String: String] {
  var queryParametersText: String {
    // swiftformat:disable redundantSelf
    self.compactMap { key, value in
      String(format: "%@=%@",
             String(describing: key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "",
             String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
    }.joined(separator: "&")
  }
}

// MARK: - Dictionary + URLQueryParameterStringConvertible

extension Dictionary: URLQueryParameterStringConvertible where Key == String, Value == String {}

extension URL {
  /// Returns a URL constructed by appending the given parameters.
  ///
  /// - Parameters:
  ///   - parameters: The query parameter dictionary to add.
  /// - Returns: A new URL with parameters appended.
  func appendingQueryParameters(_ parameters: [String: String]) -> URL? {
    let URLString = String(format: "%@?%@", absoluteString, parameters.queryParametersText)
    return URL(string: URLString)
  }
}
