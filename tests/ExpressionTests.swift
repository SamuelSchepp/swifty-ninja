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
				.Unresolvable(ident: "a"),
			
			"(4 - 6) * (x + 7)":
				.Unresolvable(ident: "x"),
			
			"(4 - 6) * (1 + 7)":
				.SuccessObject(object: IntegerObject(value: -16)),
			
			"64-9/((84*23)+25)-98/(23+3)":
				.SuccessObject(object: IntegerObject(value: 61)),
			
			"!10":
                .WrongOperator(op: "!", object: IntegerObject(value: 10)),
			
			"554||5+8/5*65&&(75||5)*7/-9":
				.TypeMissmatch
			]
		)
	}
	
	func testBool() {
		Helper.check(map: [
			"true":
				.SuccessObject(object: BooleanObject(value: true)),
			
			"false":
				.SuccessObject(object: BooleanObject(value: false)),
			
			"false || true":
				.SuccessObject(object: BooleanObject(value: true)),
			
			"false < true":
                .TypeMissmatch,
			
			"false &&":
                .ParseError(tokens: [BOOLEANLIT(value: false), LOGAND()]),
			
			"true || false && true":
				.SuccessObject(object: BooleanObject(value: true)),
			
			"(true || false) && false":
				.SuccessObject(object: BooleanObject(value: false)),
			
			"true && !(false && true)":
                .SuccessObject(object: BooleanObject(value: true)),
            
            "!false":
                .SuccessObject(object: BooleanObject(value: true))
			]
		)
	}
}
