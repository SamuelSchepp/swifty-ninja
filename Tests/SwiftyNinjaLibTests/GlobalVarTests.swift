//
//  GlobalVarTests.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 10/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation
import XCTest
import SwiftyNinjaLib
import SwiftyNinjaLang
import SwiftyNinjaRuntime

extension GlobalVarTests {
	static var allTests : [(String, (GlobalVarTests) -> () throws -> Void)] {
		return [
			("test1", test1),
			("testAllTestCount", testAllTestCount),
		]
	}
}

class GlobalVarTests: XCTestCase {
	let repl = REPL()
	
	func test1() throws {
		_ = try repl.handle(input: "type IntList = Integer[];")
		_ = try repl.handle(input: "global IntList myList;")
		_ = try repl.handle(input: "global Integer myNumber;")
		
		let envi = repl.evaluator.globalEnvironment
		envi.dump()
		
		XCTAssertEqual(String(reflecting: envi.globalVariables["myList"]!), String(reflecting: ReferenceValue.null()))
		XCTAssertEqual(String(reflecting: envi.globalVariables["myNumber"]!), String(reflecting: ReferenceValue.null()))
		
		XCTAssertEqual(String(reflecting: envi.varTypeMap["myList"]!), String(reflecting: ArrayType(base: IntegerType())))
		XCTAssertEqual(String(reflecting: envi.varTypeMap["myNumber"]!), String(reflecting: IntegerType()))
		
		XCTAssertEqual(String(reflecting: envi.typeDecMap["IntList"]!), String(reflecting: ArrayType(base: IntegerType())))
		
		_ = try repl.handle(input: "myNumber = 4 * 6;")
		
		envi.dump()
		
		guard let value = try envi.heap.get(addr: ReferenceValue(value: 3)) as? IntegerValue else {
			XCTFail()
			return;
		}
		let shouldValue = IntegerValue(value: 24)
		
		let isString = value.description
		let shouldString = shouldValue.description
		
		print(isString)
		print(shouldString)
		
		XCTAssertEqual(isString, shouldString)
	}
	
	func testAllTestCount() throws {
		XCTAssertEqual(2, GlobalVarTests.allTests.count)
	}
}
