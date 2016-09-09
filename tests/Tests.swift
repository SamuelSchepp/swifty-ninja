//
//  TokenStackTests.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 08/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import XCTest
import swifty_ninja

class FullTests: XCTestCase {
	func check(parserFunction: (Parser) -> ASTNode?, map: [String: ASTNode]) {
		map.forEach { source, target in
			print("==== Source ====")
			print(source)
			
			let tokenizer = Tokenizer(with: source)
			guard let tokens = tokenizer.tokenize() else { XCTFail(); return }
			
			// print("==== Tokens ====")
			// tokens.forEach({ print($0) })
			
			let parser = Parser(with: tokens)
			
			if let type_dec = parserFunction(parser) {
				if !parser.isDone() { XCTFail() }
				print("==== AST ====")
				print(type_dec)
				print()
				XCTAssertEqual(String(reflecting: target), String(reflecting: type_dec))
			}
			else {
				XCTFail()
			}
		}
	}
	
	func test_Type_Dec() {
		check(parserFunction: { return $0.parse_Type_Dec() }, map: [
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
				),
			"type NumberArray = Integer[][][];":
				Type_Dec(
					ident: "NumberArray",
					type: ArrayType(
						ident: "Integer",
						dims: 3
					)
				)
			]
		)
	}
	
	func test_ArrayType() {
		check(parserFunction: { return $0.parse_Type() }, map: [
			"Integer[]":
				ArrayType(
					ident: "Integer",
					dims: 1
				),
			"Bool[][]":
				ArrayType(
					ident: "Bool",
					dims: 2
				),
			"MyType[][][]":
				ArrayType(
					ident: "MyType",
					dims: 3
				)
			]
		)
	}
	
	func test_RecordType() {
		check(parserFunction: { return $0.parse_Type() }, map: [
			"record { Integer zähler; Integer nenner; }":
				RecordType(
					memb_decs: [
						Memb_Dec(
							type: IdentifierType(ident: "Integer"),
							ident: "zähler"),
						Memb_Dec(
							type: IdentifierType(ident: "Integer"),
							ident: "nenner")
					]
				),
			"record { Integer[] zählerListe; record { Integer lel; } nenner; }":
				RecordType(
					memb_decs: [
						Memb_Dec(
							type: ArrayType(
								ident: "Integer",
								dims: 1
							),
							ident: "zählerListe"),
						Memb_Dec(
							type: RecordType(
								memb_decs: [
									Memb_Dec(
										type: IdentifierType(ident: "Integer"),
										ident: "lel")
								]
							),
							ident: "nenner")
					]
				)
			]
		)
	}
}
