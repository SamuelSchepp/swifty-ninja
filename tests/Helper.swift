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
			let result = repl.handle(input: source)
            repl.dump()
            
            var shouldVal: Value = UninitializedValue()
            
            if case .SuccessReference(let ref, _) = result {
                let resultVal = repl.evaluator.globalEnvironment.heap.get(addr: ref)
                switch resultVal {
                case .SuccessValue(let val):
                    shouldVal = val
                    print(val)
                default:
                    break
                }
            }
            
            XCTAssertEqual(shouldVal.description, value.description)
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
