// ConcurrentLock.swift
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

// MARK: - ConcurrentLocking

protocol ConcurrentLocking: AnyObject {
  var rwlock: pthread_rwlock_t { get set }

  func unlock()
  func writeLock()
  func readLock()
}

extension ConcurrentLocking {
  func unlock() {
    pthread_rwlock_unlock(&rwlock)
  }

  func writeLock() {
    pthread_rwlock_wrlock(&rwlock)
  }

  func readLock() {
    pthread_rwlock_rdlock(&rwlock)
  }
}

// MARK: - ConcurrentLock

final class ConcurrentLock: ConcurrentLocking {
  // MARK: Lifecycle

  init() {
    pthread_rwlock_init(&rwlock, nil)
  }

  deinit {
    pthread_rwlock_destroy(&rwlock)
  }

  // MARK: Internal

  var rwlock = pthread_rwlock_t()
}
