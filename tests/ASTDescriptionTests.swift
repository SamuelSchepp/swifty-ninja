//
//  ASTTests.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 07/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import XCTest

class ASTDescriptionTests: XCTestCase {
	func testStringExtension() {
		XCTAssertEqual("[]".repeated(times: 0), "")
		XCTAssertEqual("[]".repeated(times: 1), "[]")
		XCTAssertEqual("[]".repeated(times: 2), "[][]")
		XCTAssertEqual("[]".repeated(times: 3), "[][][]")
		XCTAssertEqual("[]".repeated(times: 4), "[][][][]")
	}
    
    func test_Type_Dec() {
        /* test identifier type */
        let type0 = Type_Dec (
            ident: Ident(value: "Number"),
            type: IdentifierType(ident: Ident(value: "Integer"))
        )
        print(type0.description)
        XCTAssertEqual(type0.description, "type Number = Integer;")
        
        /* test array type */
        let type1 = Type_Dec (
            ident: Ident(value: "IntList"),
            type: ArrayType(
                ident: Ident(value: "Integer"),
                dims: 1
            )
        )
        print(type1.description)
        XCTAssertEqual(type1.description, "type IntList = Integer[];")
        
        /* test record type */
        let type2 = Type_Dec (
            ident: Ident(value: "LinkedList"),
            type: RecordType(
                memb_decs: [
                    Memb_Dec(type: IdentifierType(ident: Ident(value: "LinkedList")), ident: Ident(value: "next")),
                    Memb_Dec(type: IdentifierType(ident: Ident(value: "Integer")), ident: Ident(value: "value"))
                ]
            )
        )
        print(type2.description)
        XCTAssertEqual(type2.description, "type LinkedList = record {\nLinkedList next;\nInteger value;\n};")
    }
    
    func test_Gvar_Dec() {
        let gvar0 = Gvar_Dec(
            type: IdentifierType(ident: Ident(value: "Integer")),
            ident: Ident(value: "x")
        )
        print(gvar0.description)
        XCTAssertEqual(gvar0.description, "global Integer x;")
        
        let gvar1 = Gvar_Dec(
            type: RecordType(
                memb_decs: [
                    Memb_Dec(type: IdentifierType(ident: Ident(value: "LinkedList")), ident: Ident(value: "next")),
                    Memb_Dec(type: IdentifierType(ident: Ident(value: "Integer")), ident: Ident(value: "value"))
                ]
            ),
            ident: Ident(value: "myList")
        )
        print(gvar1.description)
        XCTAssertEqual(gvar1.description, "global record {\nLinkedList next;\nInteger value;\n} myList;")
    }
}
