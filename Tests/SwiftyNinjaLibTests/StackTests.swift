//
//  Tests.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 04/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import XCTest
import SwiftyNinjaLib
import SwiftyNinjaLang
import SwiftyNinjaRuntime
import SwiftyNinjaUtils

extension StackTests {
	static var allTests : [(String, (StackTests) -> () throws -> Void)] {
		return [
			("testNormal", testNormal),
			("testInit", testInit),
			("testAllTestCount", testAllTestCount),
		]
	}
}

class StackTests: XCTestCase {

	func testNormal() {
		var stack = Stack<Int>()
		stack.push(value: 1)
		stack.push(value: 2)
		stack.push(value: 3)
		
		XCTAssertEqual(stack.pop(), 3)
		XCTAssertEqual(stack.pop(), 2)
		XCTAssertEqual(stack.pop(), 1)
		XCTAssertEqual(stack.pop(), .none)
		XCTAssertEqual(stack.pop(), .none)
		XCTAssertEqual(stack.peek(), .none)
	}
	
	func testInit() {
		var stack = Stack(withList: [1, 2, 3])

		XCTAssertEqual(stack.pop(), 3)
		XCTAssertEqual(stack.pop(), 2)
		XCTAssertEqual(stack.pop(), 1)
		XCTAssertEqual(stack.pop(), .none)
		XCTAssertEqual(stack.pop(), .none)
		XCTAssertEqual(stack.peek(), .none)
	}
	
	func testAllTestCount() throws {
		XCTAssertEqual(3, StackTests.allTests.count)
	}
}
