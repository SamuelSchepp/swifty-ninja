//
//  AST.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 04/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

enum BinaryArithmeticOp: String {
	case Add = "+", Sub = "-", Mul = "*", Div = "/", Mod = "%"
}

protocol ASTNode: CustomStringConvertible {
	
}

protocol ArithmeticExpression: ASTNode {
	
}

struct ImmidiateArithmeticExpression: ArithmeticExpression {
	let value: Int
	
	public var description: String {
		get {
			return "(\(value))"
		}
	}
}

struct BinaryArithmeticExpression: ArithmeticExpression {
	let lhs: ArithmeticExpression
	let rhs: ArithmeticExpression
	let op: BinaryArithmeticOp
	
	public var description: String {
		get {
			return "(\(lhs) \(op.rawValue) \(rhs))"
		}
	}
}
