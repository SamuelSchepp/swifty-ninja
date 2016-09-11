//
//  ASTTests.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 11/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation
import XCTest

class ASTTests: XCTestCase {
	func check(input: String, targetAST: ASTNode) {
		let tokenizer = Tokenizer(with: input)
		let tokens = tokenizer.tokenize()
		let parser = Parser(with: tokens!)
		let ast = parser.parse_Stm()
		
		let isString = String(describing: ast!)
		let targetString = String(describing: targetAST)
		
		XCTAssertEqual(isString, targetString)
	}
	
	func testAssign() {
		check(input: "myInt = 3 + 4;", targetAST:
			Assign_Stm(
				_var: Var_Ident(
					ident: "myInt"
				),
				exp: Add_Exp_Binary(
					lhs: Primary_Exp_Integer(value: 3),
					rhs: Primary_Exp_Integer(value: 4),
					op: .PLUS)
				)
			)
	}
}
