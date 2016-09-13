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
	func testArithmeticError() {
		Helper.checkResult(map: [
			"a + b":
				.UnresolvableReference(ident: "a"),
			
			"(4 - 6) * (x + 7)":
				.UnresolvableReference(ident: "x"),
			
			"!10":
                .WrongOperator(op: "!", type: IntegerType()),
			
			"554||5+8/5*65&&(75||5)*7/-9":
				.TypeMissmatch
			]
		)
	}
    
    func testArithmeticValue() {
        Helper.checkHeap(map: ["(4 - 7) * (10 + 11)":
                IntegerValue(value: -63),
            
            "64-9/((84*23)+25)-98/(23+3)":
                IntegerValue(value: 61)
            ]
        )
    }
	
	func testBool() {
        Helper.checkHeap(map: [
            "1 == 1":
                BooleanValue(value: true),
            
            "1 >= 0":
                BooleanValue(value: true),
            
			"true":
				BooleanValue(value: true),
			
			"false":
				BooleanValue(value: false),
			
			"false || true":
				BooleanValue(value: true),
			
			"true || false && true":
				BooleanValue(value: true),
			
			"(true || false) && false":
				BooleanValue(value: false),
			
			"true && !(false && true)":
                BooleanValue(value: true),
            
            "!false":
                BooleanValue(value: true)
			]
		)
	}
    
    func testBoolFail() {
        Helper.checkResult(map: [
            "false < true":
                .TypeMissmatch,
            
            "false &&":
                .ParseError(tokens: [BOOLEANLIT(value: false), LOGAND()]),
            ]
        )
    }
	
	func testNil() {
		Helper.checkResult(map: [
			"nil":
				.SuccessReference(ref: ReferenceValue.null(), type: ReferenceType())
			
			]
		)
	}
}
