//
//  NinjaParser.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 05/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

class NinjaScanner {
	private let scanner: Scanner
	
	init(string: String) {
		scanner = Scanner(string: string)
	}
	
	func scanSumBinaryArithmeticOp() -> BinaryArithmeticOp? {
		var result: NSString? = ""
		if(scanner.scanCharacters(from: CharacterSet(charactersIn: "+-"), into: &result)) {
			if let op = BinaryArithmeticOp(rawValue: result as! String) {
				return op
			}
		}
		return .none
	}
	
	func scanProductBinaryArithmeticOp() -> BinaryArithmeticOp? {
		var result: NSString? = ""
		if(scanner.scanCharacters(from: CharacterSet(charactersIn: "*/%"), into: &result)) {
			if let op = BinaryArithmeticOp(rawValue: result as! String) {
				return op
			}
		}
		return .none
	}
	
	
	func scanArithmeticExpression() -> ArithmeticExpression? {
		guard let sum = scanSumArithmeticExpression() else { return .none }
		return sum
	}
	
	func scanSumArithmeticExpression() -> ArithmeticExpression? {
		guard let product = scanProductArithmeticExpression() else { return .none }
		guard let rest = scanSumArithmeticExpressionTail(currentExpr: product) else { return product }
		return rest
	}
	
	func scanSumArithmeticExpressionTail(currentExpr: ArithmeticExpression) -> ArithmeticExpression? {
		guard let op = scanSumBinaryArithmeticOp() else { return currentExpr }
		guard let product2 = scanProductArithmeticExpression() else { return .none }
		
		let current: ArithmeticExpression = BinaryArithmeticExpression(lhs: currentExpr, rhs: product2, op: op)
		
		guard let tailed = scanSumArithmeticExpressionTail(currentExpr: current) else { return current }
		
		return tailed
	}
	
	func scanProductArithmeticExpression() -> ArithmeticExpression? {
		guard let value = scanValueArithmeticExpression() else { return .none }
		guard let rest = scanProductArithmeticExpressionTail(currentExpr: value) else { return value }
		return rest
	}
	
	func scanProductArithmeticExpressionTail(currentExpr: ArithmeticExpression) -> ArithmeticExpression? {
		guard let op = scanProductBinaryArithmeticOp() else { return currentExpr }
		guard let product2 = scanValueArithmeticExpression() else { return .none }
		
		let current: ArithmeticExpression = BinaryArithmeticExpression(lhs: currentExpr, rhs: product2, op: op)
		
		guard let tailed = scanProductArithmeticExpressionTail(currentExpr: current) else { return current }
		
		return tailed
	}
	
	func scanValueArithmeticExpression() -> ArithmeticExpression? {
		guard let immidiate = scanImmidiateArithmeticExpression() else { return .none }
		return immidiate
	}
	
	func scanImmidiateArithmeticExpression() -> ImmidiateArithmeticExpression? {
		var result = 0
		if(scanner.scanInt(&result)) {
			return ImmidiateArithmeticExpression(value: result)
		}
		return .none
		
	}
}
