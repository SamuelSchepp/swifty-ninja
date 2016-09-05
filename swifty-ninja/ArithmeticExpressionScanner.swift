//
//  NinjaParser.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 05/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

class ArithmeticExpressionScanner {
	private let scanner: Scanner
	private let ninjaScanner: NinjaScanner
	
	init(scanner: Scanner) {
		self.scanner = scanner
		ninjaScanner = NinjaScanner(scanner: scanner)
	}
	
	// MARK: Interface
	
	func scanArithmeticExpression() -> ArithmeticExpression? {
		guard let sum = scanSumExpression() else {
			print("Expression expected")
			return .none
		}
		return sum
	}
	
	// MARK: Sum
	
	private func scanSumExpression() -> ArithmeticExpression? {
		guard let product = scanProductExpression() else {
			print("Expression expected")
			return .none
		}
		guard let rest = scanSumExpressionTail(currentExpr: product) else { return product }
		return rest
	}
	
	private func scanSumExpressionTail(currentExpr: ArithmeticExpression) -> ArithmeticExpression? {
		guard let op = scanSumOp() else { return currentExpr }
		guard let product2 = scanProductExpression() else {
			print("Expression expected after '\(op.rawValue)'")
			return .none
		}
		
		let current: ArithmeticExpression = BinaryArithmeticExpression(lhs: currentExpr, rhs: product2, op: op)
		
		guard let tailed = scanSumExpressionTail(currentExpr: current) else { return current }
		
		return tailed
	}
	
	private func scanSumOp() -> BinaryArithmeticOp? {
		if ninjaScanner.scanIdentifier(identifier: "+") {
			return .Add
		}
		if ninjaScanner.scanIdentifier(identifier: "-") {
			return .Sub
		}
		return .none
	}
	
	// MARK: Product
	
	private func scanProductExpression() -> ArithmeticExpression? {
		guard let value = scanValueExpression() else {
			print("Expression expected")
			return .none
		}
		guard let rest = scanProductExpressionTail(currentExpr: value) else { return value }
		return rest
	}
	
	private func scanProductExpressionTail(currentExpr: ArithmeticExpression) -> ArithmeticExpression? {
		guard let op = scanProductOp() else { return currentExpr }
		guard let product2 = scanValueExpression() else {
			print("Expression expected after '\(op.rawValue)'")
			return .none
		}
		
		let current: ArithmeticExpression = BinaryArithmeticExpression(lhs: currentExpr, rhs: product2, op: op)
		
		guard let tailed = scanProductExpressionTail(currentExpr: current) else { return current }
		
		return tailed
	}
	
	private func scanProductOp() -> BinaryArithmeticOp? {
		if ninjaScanner.scanIdentifier(identifier: "*") {
			return .Mul
		}
		if ninjaScanner.scanIdentifier(identifier: "/") {
			return .Div
		}
		if ninjaScanner.scanIdentifier(identifier: "%") {
			return .Mod
		}
		return .none
	}
	
	// MARK: Value
	
	private func scanValueExpression() -> ArithmeticExpression? {
		guard let immidiate = scanImmidiateExpression() else {
			if !ninjaScanner.scanOpenParanthesis() {
				print("'(' expected")
				return .none
			}
			guard let expr = scanArithmeticExpression() else {
				print("Expression expected after '('")
				return .none
			}
			if !ninjaScanner.scanCloseParanthesis() {
				print("')' expected")
				return .none
			}
			return expr
		}
		return immidiate
	}
	
	private func scanImmidiateExpression() -> ImmidiateArithmeticExpression? {
		var result = 0
		if(scanner.scanInt(&result)) {
			return ImmidiateArithmeticExpression(value: result)
		}
		return .none
		
	}
}
