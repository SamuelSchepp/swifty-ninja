//
//  Helper.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 09/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation
import XCTest
import SwiftyNinjaLib
import SwiftyNinjaLang
import SwiftyNinjaRuntime

class Helper {
	class func baseURL() -> String {
		return "/Users/samuel/Documents/Git/swifty-ninja/Examples/nj";
	}
	
	class func checkHeap(map: [String: Value]) throws {
		do {
		try map.forEach { source, shouldValue in
			print("==== Source ====")
			print(source)
			
			print("==== Result ====")
			let repl = REPL()
			let result = try repl.handle(input: source)
			
            repl.dump()
            
            if case .Exp(let ref) = result {
                let isValue = try repl.evaluator.globalEnvironment.heap.get(addr: ref)
                XCTAssertEqual(shouldValue.description, isValue.description)
            }
			else {
				XCTFail()
			}
		}
		}
		catch let err {
			print(err)
			throw err
		}
	}
}
