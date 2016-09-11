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
				.SuccessDeclaration,
			"type Number = Integer;":
				.SuccessDeclaration,
			"type NumberArray = Integer[][][];":
				.SuccessDeclaration
			]
		)
	}
	
	func test_ArrayType() {
		Helper.check(map: [
			"Integer[]":
                .SuccessType(type: ArrayType(base: IntegerType(), dims: 1)),
			"Boolean[][]":
                .SuccessType(type: ArrayType(base: BooleanType(), dims: 2)),
			"MyType[][][]":
				.UnresolvableType(ident: "MyType")
			]
		)
	}
	
	func test_RecordType() {
		Helper.check(map: [
			"record { }":
                .SuccessType(type: RecordType(fields: [:])),
			"record { Integer zähler; Integer nenner; }":
                .SuccessType(type: RecordType(fields: ["zähler": IntegerType(), "nenner": IntegerType()])),
			"record { Integer[] zählerListe; record { Integer lel; } nenner; }":
				.SuccessType(type:
                    RecordType(fields: [
                        "zählerListe": ArrayType(
                            base: IntegerType(),
                            dims: 1
                        ),
                        "nenner": RecordType(
                            fields: ["lel": IntegerType()]
                        )
                    ])
                )
			]
		)
	}
}
