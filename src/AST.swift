//
//  AST.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 04/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation


protocol ASTNode: CustomStringConvertible { }

// MARK: Value Expression

protocol ValueExpression: ASTNode { }

struct FunctionCallValueExpression: ValueExpression {
	let functionIdentifier: String
	let parameterList: [String]
	
	public var description: String {
		get {
			return "\(functionIdentifier)(\(parameterList));"
		}
	}
}

// MARK: Arithmetic Value Expression

protocol ArithmeticValueExpression: ValueExpression { }

struct ArithmeticImmidiateValueExpression: ArithmeticValueExpression {
	let value: Int
	
	public var description: String {
		get {
			return "\(value)"
		}
	}
}

struct ArithmeticIdentifierValueExpression: ArithmeticValueExpression {
	let identifier: String
	
	public var description: String {
		get {
			return "\(identifier)"
		}
	}
}

struct OperatedArithmeticValueExpression: ArithmeticValueExpression {
	let lhs: ArithmeticValueExpression
	let rhs: ArithmeticValueExpression
	let op: ArithmeticOp
	
	public var description: String {
		get {
			return "(\(lhs) \(op.rawValue) \(rhs))"
		}
	}
}

enum ArithmeticOp: String { case
	Add = "+",
	Sub = "-",
	Mul = "*",
	Div = "/",
	Mod = "%"
}

// MARK: Bool Value Expression

protocol BoolValueExpression: ValueExpression { }

struct BoolImmidiateValueExpression: BoolValueExpression {
	let value: Bool
	
	public var description: String {
		get {
			return "\(value)"
		}
	}
}

struct BoolIdentififerValueExpression: BoolValueExpression {
	let identififer: String
	
	public var description: String {
		get {
			return "\(identififer)"
		}
	}
}

struct BoolConjunctionValueExpression: BoolValueExpression {
	let lhs: BoolValueExpression
	let rhs: BoolValueExpression
	let op: BoolConjunctionOp
	
	public var description: String {
		get {
			return "(\(lhs) \(op.rawValue) \(rhs))"
		}
	}
}

struct BoolComparisonValueExpression: BoolValueExpression {
	let lhs: ArithmeticValueExpression
	let rhs: ArithmeticValueExpression
	let op: BoolComparisonOp
	
	public var description: String {
		get {
			return "(\(lhs) \(op.rawValue) \(rhs))"
		}
	}
}

enum BoolComparisonOp: String { case
	Equal        = "==",
	NotEqual     = "!=",
	GreaterThan  = ">",
	LessThan	 = "<",
	GreaterEqual = ">=",
	LessEqual	 = "<="
}

enum BoolConjunctionOp: String { case
	And			 = "&&",
	Or			 = "||"
}

// MARK: Type Expression

protocol TypeExpression: ASTNode { }

struct IntegerType: TypeExpression {
	public var description: String {
		get {
			return "Integer"
		}
	}
}

// MARK: Statement

protocol Statement: ASTNode { }

struct LocalDeclarationStatement: Statement {
	let type: TypeExpression
	let name: String
	
	public var description: String {
		get {
			return "local \(type) \(name);"
		}
	}
}

struct AssignmentStatement: Statement {
	let targetIdentifier: String
	let value: ValueExpression
	
	public var description: String {
		get {
			return "\(targetIdentifier) = \(value);"
		}
	}
}

struct WhileStatement: Statement {
	let condition: BoolValueExpression
	let statements: [Statement]
	
	public var description: String {
		get {
			let stmts = statements.reduce("", { return $0 + $1.description + "\n" })
			return "while(\(condition)) {\n\(stmts)}"
		}
	}
}

struct IfStatement: Statement {
	let condition: BoolValueExpression
	let statements: [Statement]
	let elseStatement: ElseStatement?
	
	public var description: String {
		get {
			let stmts = statements.reduce("", { return $0 + $1.description + "\n" })
			var ifStr = "if(\(condition)) {\n\(stmts)}"
			if let elseStr = elseStatement {
				ifStr = ifStr + elseStr.description
			}
			return ifStr
		}
	}
}

struct ElseStatement: ASTNode {
	let statements: [Statement]
	
	public var description: String {
		get {
			let stmts = statements.reduce("", { return $0 + $1.description + "\n" })
			return "else {\n\(stmts)}"
		}
	}
}
