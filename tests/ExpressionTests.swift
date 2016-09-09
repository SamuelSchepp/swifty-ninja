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
		Helper.check({ return $0.parse_Exp() }, map: [
			"a + b":
				Add_Exp_Binary(
					lhs: Var_Ident(ident: "a"),
					rhs: Var_Ident(ident: "b"),
					op: Add_Exp_Binary_Op.PLUS
				),
			"(4 - 6) * (x + 7)":
				Mul_Exp_Binary(
					lhs: Primary_Exp_Exp(exp: Add_Exp_Binary(
						lhs: Primary_Exp_Integer(value: 4),
						rhs: Primary_Exp_Integer(value: 6),
						op: Add_Exp_Binary_Op.MINUS
					)),
					rhs: Primary_Exp_Exp(exp: Add_Exp_Binary(
						lhs: Var_Ident(ident: "x"),
						rhs: Primary_Exp_Integer(value: 7),
						op: Add_Exp_Binary_Op.PLUS
					)),
					op: Mul_Exp_Binary_Op.STAR
				)
			]
		)
	}
}
