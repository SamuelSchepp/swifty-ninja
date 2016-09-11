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
				.UnresolvableReference(ident: "a"),
			
			"1 == 1":
				.SuccessValue(value: BooleanValue(value: true), type: BooleanType()),
			
			"1 >= 0":
				.SuccessValue(value: BooleanValue(value: true), type: BooleanType()),
			
			"(4 - 6) * (x + 7)":
				.UnresolvableReference(ident: "x"),
			
			"(4 - 6) * (1 + 7)":
				.SuccessValue(value: IntegerValue(value: -16), type: IntegerType()),
			
			"64-9/((84*23)+25)-98/(23+3)":
				.SuccessValue(value: IntegerValue(value: 61), type: IntegerType()),
			
			"!10":
                .WrongOperator(op: "!", type: IntegerType()),
			
			"554||5+8/5*65&&(75||5)*7/-9":
				.TypeMissmatch
			]
		)
	}
	
	func testBool() {
		Helper.check(map: [
			"true":
				.SuccessValue(value: BooleanValue(value: true), type: BooleanType()),
			
			"false":
				.SuccessValue(value: BooleanValue(value: false), type: BooleanType()),
			
			"false || true":
				.SuccessValue(value: BooleanValue(value: true), type: BooleanType()),
			
			"false < true":
                .TypeMissmatch,
			
			"false &&":
                .ParseError(tokens: [BOOLEANLIT(value: false), LOGAND()]),
			
			"true || false && true":
				.SuccessValue(value: BooleanValue(value: true), type: BooleanType()),
			
			"(true || false) && false":
				.SuccessValue(value: BooleanValue(value: false), type: BooleanType()),
			
			"true && !(false && true)":
                .SuccessValue(value: BooleanValue(value: true), type: BooleanType()),
            
            "!false":
                .SuccessValue(value: BooleanValue(value: true), type: BooleanType())
			]
		)
	}
	
	func testNil() {
		Helper.check(map: [
			"nil":
				.SuccessValue(value: ReferenceValue(value: -1), type: ReferenceType())
			
			]
		)
	}
}
