//
//  ExpressionTests.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 09/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation
import XCTest

class ExpressionTests: XCTestCase {
	func testArithmetic() {
		Helper.check(map: [
			"a + b":
			"(a + b)",
			
			"(4 - 6) * (x + 7)":
			"((4 - 6) * (x + 7))",
			
			"554||5+8/5*65&&(75||5)*7/-9":
			"(554 || ((5 + ((8 / 5) * 65)) && (((75 || 5) * 7) / (-9))))"
			]
		)
	}
}
