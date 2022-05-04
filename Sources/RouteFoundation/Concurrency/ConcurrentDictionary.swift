// ConcurrentDictionary.swift
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

// MARK: - ConcurrentDictionary

/// Wraps the `Dictionary` in a concurrent dictionary.
///
/// Example 1.
///
///     struct AwesomeStruct {
///       @ConcurrentDictionary
///       var dictionary = [String: String]()
///
///       func foo() {
///         $dictionary["key"] = "value"
///         $dictionary.removeAll()
///       }
///     }
///
/// Example 2.
///
///     struct AwesomeStruct {
///       var dictionary = ConcurrentDictionary()
///
///       func foo() {
///         dictionary["key"] = "value"
///         dictionary.removeAll()
///       }
///     }
@propertyWrapper
final class ConcurrentDictionary<Key: Hashable, Value> {
  // MARK: Lifecycle

  init(wrappedValue: [Key: Value] = [:]) {
    self.unsafeDictionary = wrappedValue
  }

  // MARK: Internal

  var wrappedValue: [Key: Value] {
    unsafeDictionary
  }

  var projectedValue: ConcurrentDictionary {
    self
  }

  var first: (key: Key, value: Value)? {
    concurrentLock.readLock(); defer { concurrentLock.unlock() }
    return unsafeDictionary.first
  }

  var startIndex: Dictionary<Key, Value>.Index {
    concurrentLock.readLock(); defer { concurrentLock.unlock() }
    return unsafeDictionary.startIndex
  }

  var endIndex: Dictionary<Key, Value>.Index {
    concurrentLock.readLock(); defer { concurrentLock.unlock() }
    return unsafeDictionary.endIndex
  }

  var count: Int {
    concurrentLock.readLock(); defer { concurrentLock.unlock() }
    return unsafeDictionary.count
  }

  var isEmpty: Bool {
    concurrentLock.readLock(); defer { concurrentLock.unlock() }
    return unsafeDictionary.isEmpty
  }

  subscript(key: Key) -> Value? {
    _read {
      concurrentLock.readLock(); defer { concurrentLock.unlock() }
      yield unsafeDictionary[key]
    }
    _modify {
      concurrentLock.writeLock(); defer { concurrentLock.unlock() }
      yield &unsafeDictionary[key]
    }
  }

  /// Updates the value stored in the dictionary for the given key, or adds a
  /// new key-value pair if the key does not exist.
  ///
  /// - Parameters:
  ///   - value: The new value to add to the dictionary.
  ///   - key: The key to associate with `value`. If `key` already exists in
  ///     the dictionary, `value` replaces the existing associated value. If
  ///     `key` isn't already a key of the dictionary, the `(key, value)` pair
  ///     is added.
  /// - Returns: The value that was replaced, or `nil` if a new key-value pair
  ///   was added.
  @discardableResult
  func updateValue(_ value: Value, forKey key: Key) -> Value? {
    concurrentLock.writeLock(); defer { concurrentLock.unlock() }
    return unsafeDictionary.updateValue(value, forKey: key)
  }

  func removeAll(keepingCapacity keepCapacity: Bool = false) {
    concurrentLock.writeLock(); defer { concurrentLock.unlock() }
    unsafeDictionary.removeAll(keepingCapacity: keepCapacity)
  }

  // MARK: Private

  // Initialization of lock, pthread_rwlock_t is a value type and must be declared as var in order to refer it later. Make sure not to copy it.
  private var concurrentLock = ConcurrentLock()
  private var unsafeDictionary: [Key: Value]
}
