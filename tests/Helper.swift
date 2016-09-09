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
	class func check(map: [String: String]) {
		map.forEach { source, target in
			print("==== Source ====")
			print(source)
			
			print("==== Handler ====")
			if let result = App.handle(input: source) {
			
				print("==== Result ====")
				print(result)
			
				XCTAssertEqual(target.description, String(describing: result))
			}
			else {
				XCTFail()
			}
		}
	}
}
