//
//  NinjaParser.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 05/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

class ArithmeticValueExpressionScanner {
	private let scanner: Scanner
	private let ninjaScanner: NinjaScanner
	
	init(scanner: Scanner) {
		self.scanner = scanner
		ninjaScanner = NinjaScanner(scanner: scanner)
	}
	
	// MARK: Interface
	
	func scanArithmeticExpression() -> ArithmeticValueExpression? {
		guard let sum = scanSum() else {
			return .none
		}
		return sum
	}
	
	// MARK: Sum
	
	private func scanSum() -> ArithmeticValueExpression? {
		guard let product = scanProduct() else {
			return .none
		}
		guard let rest = scanSumTail(currentExpr: product) else { return product }
		return rest
	}
	
	private func scanSumTail(currentExpr: ArithmeticValueExpression) -> ArithmeticValueExpression? {
		guard let op = scanSumOp() else { return currentExpr }
		guard let product2 = scanProduct() else {
			return .none
		}
		
		let current = OperatedArithmeticValueExpression(lhs: currentExpr, rhs: product2, op: op)
		
		guard let tailed = scanSumTail(currentExpr: current) else { return current }
		
		return tailed
	}
	
	private func scanSumOp() -> ArithmeticOp? {
		if ninjaScanner.scanIdentifier(identifier: "+") {
			return .Add
		}
		if ninjaScanner.scanIdentifier(identifier: "-") {
			return .Sub
		}
		return .none
	}
	
	// MARK: Product
	
	private func scanProduct() -> ArithmeticValueExpression? {
		guard let value = scanValue() else {
			return .none
		}
		guard let rest = scanProductTail(currentExpr: value) else { return value }
		return rest
	}
	
	private func scanProductTail(currentExpr: ArithmeticValueExpression) -> ArithmeticValueExpression? {
		guard let op = scanProductOp() else { return currentExpr }
		guard let product2 = scanValue() else {
			return .none
		}
		
		let current = OperatedArithmeticValueExpression(lhs: currentExpr, rhs: product2, op: op)
		
		guard let tailed = scanProductTail(currentExpr: current) else { return current }
		
		return tailed
	}
	
	private func scanProductOp() -> ArithmeticOp? {
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
	
	private func scanValue() -> ArithmeticValueExpression? {
		guard let immidiate = scanImmidiate() else {
			if !ninjaScanner.scanOpenParanthesis() {
				return .none
			}
			guard let expr = scanArithmeticExpression() else {
				return .none
			}
			if !ninjaScanner.scanCloseParanthesis() {
				return .none
			}
			return expr
		}
		return immidiate
	}
	
	private func scanImmidiate() -> ArithmeticImmidiateValueExpression? {
		var result = 0
		if(scanner.scanInt(&result)) {
			return ArithmeticImmidiateValueExpression(value: result)
		}
		return .none
		
	}
}
