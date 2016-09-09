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
		Helper.check({ return $0.parse_Type_Dec() }, map: [
			"type Fraction = record { Integer num; Integer den; };":
				"type Fraction = record { Integer num; Integer den; };",
			"type Number = Integer;":
				"type Number = Integer;",
			"type NumberArray = Integer[][][];":
				"type NumberArray = Integer[][][];"
			]
		)
	}
	
	func test_ArrayType() {
		Helper.check({ return $0.parse_Type() }, map: [
			"Integer[]":
				"Integer[]",
			"Bool[][]":
				"Bool[][]",
			"MyType[][][]":
				"MyType[][][]"
			]
		)
	}
	
	func test_RecordType() {
		Helper.check({ return $0.parse_Type() }, map: [
			"record { Integer zähler; Integer nenner; }":
				"record { Integer zähler; Integer nenner; }",
			"record { Integer[] zählerListe; record { Integer lel; } nenner; }":
				"record { Integer[] zählerListe; record { Integer lel; } nenner; }"
			]
		)
	}
}
