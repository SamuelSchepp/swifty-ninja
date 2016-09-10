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
				.UnresolvableIdentifier("a"),
			
			"(4 - 6) * (x + 7)":
				.UnresolvableIdentifier("x"),
			
			"(4 - 6) * (1 + 7)":
				.SuccessObject(IntegerObject(value: -16)),
			
			"64-9/((84*23)+25)-98/(23+3)":
				.SuccessObject(IntegerObject(value: 61)),
			
			"554||5+8/5*65&&(75||5)*7/-9":
				.TypeMissmatch
			]
		)
	}
	
	func testBool() {
		Helper.check(map: [
			"true":
				.SuccessObject(BooleanObject(value: true)),
			
			"false":
				.SuccessObject(BooleanObject(value: false)),
			
			"false || true":
				.SuccessObject(BooleanObject(value: true)),
			
			"false &&":
				REPLResult.ParseError([BOOLEANLIT(value: false), LOGAND()]),
			
			"true || false && true":
				.SuccessObject(BooleanObject(value: true)),
			
			"(true || false) && false":
				.SuccessObject(BooleanObject(value: false))
			]
		)
	}
}
