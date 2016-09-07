//
//  TokenStackTests.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 08/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import XCTest

class TokenStackTests: XCTestCase {
	func testKeywords() {
		let tokenStack = TokenStack(tokens: [.DO, .BREAK, .DO])
		
		if !tokenStack.hasTokens() {
			XCTFail()
		}
		
		if !tokenStack.pop_DO() {
			XCTFail()
		}
		
		if !tokenStack.pop_BREAK() {
			XCTFail()
		}
		
		if tokenStack.pop_BREAK() {
			XCTFail()
		}
		
		if !tokenStack.pop_DO() {
			XCTFail()
		}
		
		if(tokenStack.hasTokens()) {
			XCTFail()
		}
	}
}
