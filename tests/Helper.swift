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
	class func check(map: [String: REPLResult]) {
		map.forEach { source, target in
			print("==== Source ====")
			print(source)
			
			print("==== Result ====")
			let repl = REPL()
			let result = repl.handle(input: source)
			
			let resultString = String(describing: result)
			let targetString = String(describing: target)
			
			print(resultString)
			
			XCTAssertEqual(targetString, resultString)
		}
	}
}
