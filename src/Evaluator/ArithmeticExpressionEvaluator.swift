//
//  ArithmeticExpressionEvaluator.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 05/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

class ArithmeticExpressionEvaluator {
	class func eval(expr: ArithmeticValueExpression) -> Int {
		switch expr {
		case let immidiate as ArithmeticImmidiateValueExpression:
			return eval(immidiateExpr: immidiate)
		case let binary as OperatedArithmeticValueExpression:
			return eval(binaryExpr: binary)
		default: return 0
		}
	}
	
	private class func eval(immidiateExpr: ArithmeticImmidiateValueExpression) -> Int {
		return immidiateExpr.value
	}
	
	private class func eval(binaryExpr: OperatedArithmeticValueExpression) -> Int {
		let lhs = eval(expr: binaryExpr.lhs)
		let rhs = eval(expr: binaryExpr.rhs)
		
		switch binaryExpr.op {
		case .Add:
			return lhs + rhs
		case .Sub:
			return lhs - rhs
		case .Mul:
			return lhs * rhs
		case .Div:
			return lhs / rhs
		case .Mod:
			return lhs % rhs
		}
	}
}
