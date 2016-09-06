//
//  ASTTests.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 07/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import XCTest

class ASTTests: XCTestCase {
	func testStringExtansion() {
		XCTAssertEqual("[]".repeated(times: 0), "")
		XCTAssertEqual("[]".repeated(times: 1), "[]")
		XCTAssertEqual("[]".repeated(times: 2), "[][]")
		XCTAssertEqual("[]".repeated(times: 3), "[][][]")
		XCTAssertEqual("[]".repeated(times: 4), "[][][][]")
	}
}
