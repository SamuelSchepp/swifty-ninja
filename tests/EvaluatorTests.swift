//
//  EvaluatorTests.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 05/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import XCTest

class EvaluatorTests: XCTestCase {
	func testExpression() {
		[
			(
				"34",
				34
			),
			(
				"42",
				42
			),
			(
				"0",
				0
			),
			(
				"1",
				1
			),
			(
				"-345",
				-345
			),
			(
				"+353",
				353
			),
			(
				"85",
				85
			),
			(
				"34 + 42",
				76
			),
			(
				"42 - 454",
				-412
			),
			(
				"42 - 454 + 5",
				-407
			),
			(
				"5 - 42 * 454",
				-19063
			),
			(
				"5 / 5 - -6 / +7 - 42 * -454",
				19069
			),
			(
				"5 / (5 --6) /+7 - 42* -454",
				19068
			),
			(
				"1 * 2 * 3",
				6
			),
			(
				"1 * (2 * 3)",
				6
			),
			(
				"(((6 / (3 / 2))))",
				6
			),
			(
				"(((6 / 3 / 2)))",
				1
			),
			(
				"(((5)))",
				5
			),
			(
				"(5*(5-2))",
				15
			)
		].forEach { (string, target) in
				let scanner = ArithmeticValueExpressionScanner(scanner: Scanner(string: string))
				print(string)
				if let res = scanner.scanArithmeticExpression() {
					let result = ArithmeticExpressionEvaluator.eval(expr: res)
					print(result)
					XCTAssertEqual(result, target)
				}
				else {
					XCTFail()
				}
				print()
		}
	}
}
