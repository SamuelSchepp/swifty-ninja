//
//  Helper.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 09/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation
import XCTest

class Helper {
	class func checkHeap(map: [String: Value]) {
		map.forEach { source, value in
			print("==== Source ====")
			print(source)
			
			print("==== Result ====")
			let repl = REPL()
			_ = repl.handle(input: source)
			let result = repl.evaluator.globalEnvironment.heapPeek()
			
			
			let resultString = String(reflecting: result)
			let targetString = String(reflecting: value)
			
			print(resultString)
			
			XCTAssertEqual(targetString, resultString)
		}
	}
	
	class func checkResult(map: [String: REPLResult]) {
		map.forEach { source, value in
			print("==== Source ====")
			print(source)
			
			print("==== Result ====")
			let repl = REPL()
			let result = repl.handle(input: source)
			
			
			let resultString = String(reflecting: result)
			let targetString = String(reflecting: value)
			
			print(resultString)
			
			XCTAssertEqual(targetString, resultString)
		}
	}
}
