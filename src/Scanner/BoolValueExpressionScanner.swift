//
//  BoolExpressionScanner.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 05/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

class BoolValueExpressionScanner {
	private let scanner: Scanner
	private let ninjaScanner: NinjaScanner
	private let arithmeticValueExpressionScanner: ArithmeticValueExpressionScanner
	
	init(scanner: Scanner) {
		self.scanner = scanner
		ninjaScanner = NinjaScanner(scanner: scanner)
		arithmeticValueExpressionScanner = ArithmeticValueExpressionScanner(scanner: scanner)
	}
	
	// MARK: Interface
	
	func scanBoolValueExpression() -> BoolValueExpression? {
		guard let conj = scanOrConjunction() else {
			return .none
		}
		return conj
	}
	
	// MARK: Or Conjunction
	
	private func scanOrConjunction() -> BoolValueExpression? {
		guard let value = scanAndConjunction() else {
			return .none
		}
		guard let rest = scanOrConjunctionTail(currentExpr: value) else { return value }
		return rest
	}
	
	private func scanOrConjunctionTail(currentExpr: BoolValueExpression) -> BoolValueExpression? {
		guard let op = scanOrConjunctionOp() else { return currentExpr }
		guard let product2 = scanAndConjunction() else {
			return .none
		}
		
		let current = BoolConjunctionValueExpression(lhs: currentExpr, rhs: product2, op: op)
		
		guard let tailed = scanOrConjunctionTail(currentExpr: current) else { return current }
		
		return tailed
	}
	
	private func scanOrConjunctionOp() -> BoolConjunctionOp? {
		if ninjaScanner.scanIdentifier(identifier: "||") {
			return .Or
		}
		return .none
	}
	
	// MARK: And Conjunction
	
	private func scanAndConjunction() -> BoolValueExpression? {
		guard let value = scanComparison() else {
			return .none
		}
		guard let rest = scanAndConjunctionTail(currentExpr: value) else { return value }
		return rest
	}
	
	private func scanAndConjunctionTail(currentExpr: BoolValueExpression) -> BoolValueExpression? {
		guard let op = scanAndConjunctionOp() else { return currentExpr }
		guard let product2 = scanComparison() else {
			return .none
		}
		
		let current = BoolConjunctionValueExpression(lhs: currentExpr, rhs: product2, op: op)
		
		guard let tailed = scanAndConjunctionTail(currentExpr: current) else { return current }
		
		return tailed
	}
	
	private func scanAndConjunctionOp() -> BoolConjunctionOp? {
		if ninjaScanner.scanIdentifier(identifier: "&&") {
			return .And
		}
		return .none
	}
	
	// MARK: Comparison
	
	private func scanComparison() -> BoolValueExpression? {
		let location = scanner.scanLocation
		guard let lhs = arithmeticValueExpressionScanner.scanArithmeticExpression() else {
			scanner.scanLocation = location
			guard let value = scanValue() else {
				return .none
			}
			return value
		}
		guard let op = scanComparisonOp() else {
			return .none
		}
		guard let rhs = arithmeticValueExpressionScanner.scanArithmeticExpression() else {
			return .none
		}
		
		return BoolComparisonValueExpression(lhs: lhs, rhs: rhs, op: op)
	}
	
	private func scanComparisonOp() -> BoolComparisonOp? {
		if ninjaScanner.scanIdentifier(identifier: "==") {
			return .Equal
		}
		if ninjaScanner.scanIdentifier(identifier: "!=") {
			return .NotEqual
		}
		if ninjaScanner.scanIdentifier(identifier: ">=") {
			return .GreaterEqual
		}
		if ninjaScanner.scanIdentifier(identifier: "<=") {
			return .LessEqual
		}
		if ninjaScanner.scanIdentifier(identifier: ">") {
			return .GreaterThan
		}
		if ninjaScanner.scanIdentifier(identifier: "<") {
			return .LessThan
		}
		return .none
	}
	
	// MARK: Value
	
	private func scanValue() -> BoolValueExpression? {
		guard let immidiate = scanImmidiateExpression() else {
			if !ninjaScanner.scanOpenParanthesis() {
				return .none
			}
			guard let expr = scanBoolValueExpression() else {
				return .none
			}
			if !ninjaScanner.scanCloseParanthesis() {
				return .none
			}
			return expr
		}
		return immidiate
	}
	
	private func scanImmidiateExpression() -> BoolImmidiateValueExpression? {
		if ninjaScanner.scanIdentifier(identifier: "true") {
			return BoolImmidiateValueExpression(value: true)
		}
		if ninjaScanner.scanIdentifier(identifier: "false") {
			return BoolImmidiateValueExpression(value: false)
		}
		return .none
		
	}
}
