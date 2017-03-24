//
//  ExpressionTests.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 09/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation
import XCTest
import SwiftyNinjaLib
import SwiftyNinjaCore

class ExpressionTests: XCTestCase {
	func testArithmeticValue1() throws {
		try Helper.checkHeap(map: [
			"4 + 1":
				IntegerValue(value: 4 + 1)
			]
		)
	}
	
	func testArithmeticValue2() throws {
        try Helper.checkHeap(map: ["(4 - 7) * (10 + 11)":
                IntegerValue(value: -63),
            
            "64-9/((84*23)+25)-98/(23+3)":
                IntegerValue(value: 61)
            ]
        )
    }
	
	func testBool() throws {
        try Helper.checkHeap(map: [
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
}
