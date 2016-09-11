//
//  StmTests.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 11/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation
import XCTest

class StmTests: XCTestCase {
	let repl = REPL()
	
	func envi() -> GlobalEnvironment {
		return repl.evaluator.globalEnvironment
	}
	
	func testIf() {
		_ = repl.handle(input: "global Integer a; global Integer b;")
		_ = repl.handle(input: "a = 4; b = 5;")
		_ = repl.handle(input: "if ( a == 4) { b = b + a; } else { b = 0; }")
		let result = repl.handle(input: "b")
		
		if case .SuccessValue(let val as IntegerValue, _ as IntegerType) = result {
			print(result)
			XCTAssertEqual(val.value, 9)
		}
		else {
			XCTFail()
		}
	}
	
	func testNull() {
		_ = repl.handle(input: "global Integer a;")
		let result = repl.handle(input: "a")
		
		if case .NullPointer = result {
			print(result)
		}
		else {
			XCTFail()
		}
	}
	
	func testNull2() {
		_ = repl.handle(input: "global Integer a;")
		let result = repl.handle(input: "if (a == 0) {}")
		
		if case .NullPointer = result {
			print(result)
		}
		else {
			XCTFail()
		}
	}
	
	func testWhile() {
		_ = repl.handle(input: "global Integer akku;")
		_ = repl.handle(input: "global Integer index;")
		_ = repl.handle(input: "akku = 1;")
		_ = repl.handle(input: "index = 0;")
		_ = repl.handle(input: "while(index < 100) { if(index == 5) return; akku = akku * 2; index = index + 1; }")
		let result = repl.handle(input: "akku")
		
		print(result)
		
		if case .SuccessValue(let _val as IntegerValue, _ as IntegerType) = result {
			XCTAssertEqual(_val.value, 64)
		}
		else {
			XCTFail()
		}
	}
}
