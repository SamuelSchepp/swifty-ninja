//
//  NinjaScannerTests.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 05/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import XCTest

class ScannerTests: XCTestCase {
	func testBoolExpression() {
		[
			(
				"true",
				"true"
			),
			(
				"false",
				"false"
			),
			(
				"false && false",
				"(false && false)"
			),
			(
				"false || false",
				"(false || false)"
			),
			(
				"6 <= 8",
				"(6 <= 8)"
			),
			(
				"5 > 8 && 6 <= 8",
				"((5 > 8) && (6 <= 8))"
			),
			(
				"false || false && true",
				"(false || (false && true))"
			),
			(
				"(false || false) && true",
				"((false || false) && true)"
			),
			(
				"5 > 8 || 6 <= 8 && 4 == 5 || false",
				"(((5 > 8) || ((6 <= 8) && (4 == 5))) || false)"
			)
		].forEach { (string, target) in
				let scanner = BoolValueExpressionScanner(scanner: Scanner(string: string))
				print(string)
				if let res = scanner.scanBoolValueExpression() {
					XCTAssertEqual(res.description, target.description)
					print(res)
				}
				else {
					XCTFail()
				}
				print()
		}
	}
	
	func testSpecial() {
		let string = "(false || false) && true"
		let target = "((false || false) && true)"
		
		let scanner = BoolValueExpressionScanner(scanner: Scanner(string: string))
		print(string)
		if let res = scanner.scanBoolValueExpression() {
			XCTAssertEqual(res.description, target)
			print(res)
		}
		else {
			XCTFail()
		}
		print()
	}
	
	func testArithmeticExpression() {
		[
			(
				"34",
				"34"
			),
			(
				"42",
				"42"
			),
			(
				"0",
				"0"
			),
			(
				"1",
				"1"
			),
			(
				"-345",
				"-345"
			),
			(
				"+353",
				"353"
			),
			(
				"85",
				"85"
			),
			(
				"34 + 42",
				"(34 + 42)"
			),
			(
				"42 - 454",
				"(42 - 454)"
			),
			(
				"42 - 454 + 5",
				"((42 - 454) + 5)"
			),
			(
				"5 - 42 * 454",
				"(5 - (42 * 454))"
			),
			(
				"5 / 5 - -6 / +7 - 42 * -454",
				"(((5 / 5) - (-6 / 7)) - (42 * -454))"
			),
			(
				"5 / (5 --6) /+7 - 42* -454",
				"(((5 / (5 - -6)) / 7) - (42 * -454))"
			),
			(
				"1 * 2 * 3",
				"((1 * 2) * 3)"
			),
			(
				"1 * (2 * 3)",
				"(1 * (2 * 3))"
			),
			(
				"(((1 * (2 * 3))))",
				"(1 * (2 * 3))"
			),
			(
				"(((1 * 2 * 3)))",
				"((1 * 2) * 3)"
			),
			(
				"(((5)))",
				"5"
			),
			(
				"(5*(5-2))",
				"(5 * (5 - 2))"
			)
		].forEach { (string, target) in
			let scanner = ArithmeticValueExpressionScanner(scanner: Scanner(string: string))
			print(string)
			if let res = scanner.scanArithmeticExpression() {
				XCTAssertEqual(res.description, target.description)
				print(res)
			}
			else {
				XCTFail()
			}
			print()
		}
	}
}
