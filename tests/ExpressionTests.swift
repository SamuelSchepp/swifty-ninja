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
		Helper.checkResult(map: [
			"a + b":
				.UnresolvableReference(ident: "a"),
			
			"1 == 1":
				.SuccessReference(ref: ReferenceValue(value: 3), type: BooleanType()),
			
			"1 >= 0":
				.SuccessReference(ref: ReferenceValue(value: 3), type: BooleanType()),
			
			"(4 - 6) * (x + 7)":
				.UnresolvableReference(ident: "x"),
			
			"(4 - 6) * (1 + 7)":
				.SuccessReference(ref: ReferenceValue(value: 3), type: IntegerType()),
			
			"64-9/((84*23)+25)-98/(23+3)":
				.SuccessReference(ref: ReferenceValue(value: 3), type: IntegerType()),
			
			"!10":
                .WrongOperator(op: "!", type: IntegerType()),
			
			"554||5+8/5*65&&(75||5)*7/-9":
				.TypeMissmatch
			]
		)
	}
	
	func testBool() {
		Helper.checkResult(map: [
			"true":
				.SuccessReference(ref: ReferenceValue(value: 3), type: BooleanType()),
			
			"false":
				.SuccessReference(ref: ReferenceValue(value: 3), type: BooleanType()),
			
			"false || true":
				.SuccessReference(ref: ReferenceValue(value: 3), type: BooleanType()),
			
			"false < true":
                .TypeMissmatch,
			
			"false &&":
                .ParseError(tokens: [BOOLEANLIT(value: false), LOGAND()]),
			
			"true || false && true":
				.SuccessReference(ref: ReferenceValue(value: 3), type: BooleanType()),
			
			"(true || false) && false":
				.SuccessReference(ref: ReferenceValue(value: 3), type: BooleanType()),
			
			"true && !(false && true)":
                .SuccessReference(ref: ReferenceValue(value: 3), type: BooleanType()),
            
            "!false":
                .SuccessReference(ref: ReferenceValue(value: 3), type: BooleanType())
			]
		)
	}
	
	func testNil() {
		Helper.checkResult(map: [
			"nil":
				.SuccessReference(ref: ReferenceValue(value: 3), type: ReferenceType())
			
			]
		)
	}
}
