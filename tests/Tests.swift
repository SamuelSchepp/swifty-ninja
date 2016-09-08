//
//  TokenStackTests.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 08/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import XCTest

class FullTests: XCTestCase {
	func test_Type_Dec() {
		[
			"type Fraction = record { Integer num; Integer den; };":
				Type_Dec(
					ident: "Fraction",
					type: RecordType(
						memb_decs: [
							Memb_Dec(
								type: IdentifierType(ident: "Integer"),
								ident: "num"),
							Memb_Dec(
								type: IdentifierType(ident: "Integer"),
								ident: "den")
						]
					)
				),
			"type Number = Integer;":
				Type_Dec(
					ident: "Number",
					type: IdentifierType(
						ident: "Integer"
					)
				)
		].forEach { source, target in
			print("==== Source ====")
			print(source)
			
			let tokenizer = Tokenizer(with: source)
			let tokens = tokenizer.tokenize()
			
			print("==== Tokens ====")
			tokens.forEach({ print($0) })
			
			let parser = Parser(with: tokens)
			if let type_dec = parser.parse_Type_Dec() {
				print("==== AST ====")
				print(type_dec)
				XCTAssertEqual(target.description, type_dec.description)
			}
			
			print()
		}
	}
}
