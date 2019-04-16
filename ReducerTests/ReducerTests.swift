//
//  ReducerTests.swift
//  ReducerTests
//
//  Created by CHEN Xian-an on 2019/4/15.
//  Copyright © 2019 realazy. All rights reserved.
//

import XCTest
import Reducer

struct S {
  var a = 0
  var b: Int { return a + 1 }
  var c: String { return String(a) }
}

enum Action {
  case increment
  case decrement
}

func reduce(state: Reducer.Updater<S>, action: Action) {
  switch action {
  case .increment:
    state[keyPath: \.a] += 1
  case .decrement:
    state[keyPath: \.a] -= 1
  }
}

class ReducerTests: XCTestCase {
  func testReducer() {
    let (state, dispatch) = Reducer.use(initialState: S(), reducer: reduce)
    let exp = expectation(description: "Value should change after dispatch action")
    state.observeKeyPath(\.b) { change in
      if change.isInitial { return }
      XCTAssertEqual(change.old, 1)
      XCTAssertEqual(change.new, 2)
      exp.fulfill()
    }
    dispatch(.increment)
    wait(for: [exp], timeout: 1)
  }

  func testReducerMultipleKeyPaths() {
    let (state, dispatch) = Reducer.use(initialState: S(), reducer: reduce)
    let exp = expectation(description: "Value should change after dispatch action")
    state.observeKeyPaths(\.a, \.b, \.c) { a, b, c in
      if a.isInitial { return }
      XCTAssertEqual(a.old, 0)
      XCTAssertEqual(a.new, -1)
      XCTAssertEqual(b.old, 1)
      XCTAssertEqual(b.new, 0)
      XCTAssertEqual(c.old, String(0))
      XCTAssertEqual(c.new, String(-1))
      exp.fulfill()
    }
    dispatch(.decrement)
    wait(for: [exp], timeout: 1)
  }
}
