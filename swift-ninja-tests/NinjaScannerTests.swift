//
//  NinjaScannerTests.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 05/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import XCTest

class NinjaScannerTests: XCTestCase {
	func testImmidiateArithmeticExpression() {
		[("34", 34), ("42", 42), ("0", 0), ("1", 1), ("-345", -345), ("+353", 353), ("85", 85)].forEach { (string, number) in
			let ninjaScanner = NinjaScanner(string: string)
			
			let target = ImmidiateArithmeticExpression(value: number)
			
			if let res = ninjaScanner.scanArithmeticExpression() {
				print(res)
				XCTAssertEqual(res.description, target.description)
			}
			else {
				XCTFail()
			}
		}
	}
	
	func testBinaryArithmeticExpression() {
		[
			(
				"34 + 42",
				BinaryArithmeticExpression(
					lhs: ImmidiateArithmeticExpression(value: 34),
					rhs: ImmidiateArithmeticExpression(value: 42),
					op:  BinaryArithmeticOp.Add
				)
			),
			(
				"42 - 454",
				BinaryArithmeticExpression(
					lhs: ImmidiateArithmeticExpression(value: 42),
					rhs: ImmidiateArithmeticExpression(value: 454),
					op: BinaryArithmeticOp.Sub
				)
			),
			(
				"42 - 454 + 5",
				BinaryArithmeticExpression(
					lhs: BinaryArithmeticExpression(
						lhs: ImmidiateArithmeticExpression(value: 42),
						rhs: ImmidiateArithmeticExpression(value: 454),
						op: BinaryArithmeticOp.Sub
					),
					rhs: ImmidiateArithmeticExpression(value: 5),
					op: BinaryArithmeticOp.Add
				)
			),
			(
				"5 - 42 * 454",
				BinaryArithmeticExpression(
					lhs: ImmidiateArithmeticExpression(value: 5),
					rhs: BinaryArithmeticExpression(
						lhs: ImmidiateArithmeticExpression(value: 42),
						rhs: ImmidiateArithmeticExpression(value: 454),
						op: BinaryArithmeticOp.Mul
					),
					op: BinaryArithmeticOp.Sub
				)
			)
		].forEach { (string, target) in
			let ninjaScanner = NinjaScanner(string: string)
			
			if let res = ninjaScanner.scanArithmeticExpression() {
				XCTAssertEqual(res.description, target.description)
				print(res)
			}
			else {
				XCTFail()
			}
		}
	}
}
