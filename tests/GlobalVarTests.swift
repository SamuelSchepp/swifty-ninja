//
//  GlobalVarTests.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 10/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation
import XCTest

class GlobalVarTests: XCTestCase {
	let repl = REPL()
	
	func test1() {
		_ = repl.handle(input: "type IntList = Integer[];")
		_ = repl.handle(input: "global IntList myList;")
		_ = repl.handle(input: "global Integer myNumber;")
		
		let envi = repl.evaluator.globalEnvironment
		envi.dump()
		
		XCTAssertEqual(String(reflecting: envi.globalVariables["myList"]!), String(reflecting: ReferenceValue.null()))
		XCTAssertEqual(String(reflecting: envi.globalVariables["myNumber"]!), String(reflecting: ReferenceValue.null()))
		
		XCTAssertEqual(String(reflecting: envi.varTypeMap["myList"]!), String(reflecting: ArrayType(base: IntegerType(), dims: 1)))
		XCTAssertEqual(String(reflecting: envi.varTypeMap["myNumber"]!), String(reflecting: IntegerType()))
		
		XCTAssertEqual(String(reflecting: envi.typeDecMap["IntList"]!), String(reflecting: ArrayType(base: IntegerType(), dims: 1)))
		
		_ = repl.handle(input: "myNumber = 4 * 6;")
		
		envi.dump()
		
        let valueEval = envi.heap.get(addr: ReferenceValue(value: 3))
        switch valueEval {
        case .SuccessValue(let val):
            let shouldValue = IntegerValue(value: 24)
            
            let isString = val.description
            let shouldString = shouldValue.description
            
            print(isString)
            print(shouldString)
            
            XCTAssertEqual(isString, shouldString)
        default:
            XCTFail()
        }
	}
}
