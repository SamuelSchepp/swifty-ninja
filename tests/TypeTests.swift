//
//  TokenStackTests.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 08/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import XCTest

class TypeTests: XCTestCase {
	
	func test_Type_Dec() {
		Helper.check(map: [
			"type Fraction = record { Integer num; Integer den; };":
				.NotExhaustive,
			"type Number = Integer;":
				.NotExhaustive,
			"type NumberArray = Integer[][][];":
				.NotExhaustive
			]
		)
	}
	
	func test_ArrayType() {
		Helper.check(map: [
			"Integer[]":
				.NotExhaustive,
			"Bool[][]":
				.NotExhaustive,
			"MyType[][][]":
				.NotExhaustive
			]
		)
	}
	
	func test_RecordType() {
		Helper.check(map: [
			"record { }":
				.NotExhaustive,
			"record { Integer zähler; Integer nenner; }":
				.NotExhaustive,
			"record { Integer[] zählerListe; record { Integer lel; } nenner; }":
				.NotExhaustive
			]
		)
	}
}
