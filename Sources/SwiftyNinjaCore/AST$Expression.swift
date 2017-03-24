//
//  AST$Expression.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 11/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

// MARK: Expression Boolean

public protocol Exp: ASTNode { }

public protocol Or_Exp: Exp { }

public struct Or_Exp_Binary: Or_Exp {
	public let lhs: Or_Exp
	public let rhs: And_Exp
	
	public init(lhs: Or_Exp, rhs: And_Exp) {
		self.lhs = lhs
		self.rhs = rhs
	}
	
	public var description: String {
		get {
			return "(\(lhs) || \(rhs))"
		}
	}
}

public protocol And_Exp: Or_Exp { }

public struct And_Exp_Binary: And_Exp {
	public let lhs: And_Exp
	public let rhs: Rel_Exp
	
	public init(lhs: And_Exp, rhs: Rel_Exp) {
		self.lhs = lhs
		self.rhs = rhs
	}
	
	public var description: String {
		get {
			return "(\(lhs) && \(rhs))"
		}
	}
}

public protocol Rel_Exp: And_Exp { }

public struct Rel_Exp_Binary: Rel_Exp {
	public let lhs: Add_Exp
	public let rhs: Add_Exp
	public let op: Rel_Exp_Binary_Op
	
	public init(lhs: Add_Exp, rhs: Add_Exp, op: Rel_Exp_Binary_Op) {
		self.lhs = lhs
		self.rhs = rhs
		self.op = op
	}
	
	public var description: String {
		get {
			return "(\(lhs) \(op.rawValue) \(rhs))"
		}
	}
}

public enum Rel_Exp_Binary_Op: String { case
	EQ = "==",
	NE = "!=",
	LT = "<",
	LE = "<=",
	GT = ">",
	GE = ">="
}

// MARK: Expression Arithmetic

public protocol Add_Exp: Rel_Exp { }

public struct Add_Exp_Binary: Add_Exp {
	public let lhs: Add_Exp
	public let rhs: Mul_Exp
	public let op: Add_Exp_Binary_Op
	
	public init(lhs: Add_Exp, rhs: Mul_Exp, op: Add_Exp_Binary_Op) {
		self.lhs = lhs
		self.rhs = rhs
		self.op = op
	}
	
	public var description: String {
		get {
			return "(\(lhs) \(op.rawValue) \(rhs))"
		}
	}
}

public enum Add_Exp_Binary_Op: String { case
	PLUS = "+",
	MINUS = "-"
}

public protocol Mul_Exp: Add_Exp { }

public struct Mul_Exp_Binary: Mul_Exp {
	public let lhs: Mul_Exp
	public let rhs: Unary_Exp
	public let op: Mul_Exp_Binary_Op
	
	public init(lhs: Mul_Exp, rhs: Unary_Exp, op: Mul_Exp_Binary_Op) {
		self.lhs = lhs
		self.rhs = rhs
		self.op = op
	}
	
	public var description: String {
		get {
			return "(\(lhs) \(op.rawValue) \(rhs))"
		}
	}
}

public enum Mul_Exp_Binary_Op: String { case
	STAR = "*",
	SLASH = "/",
	PERCENT = "%"
}

public protocol Unary_Exp: Mul_Exp { }

public struct Unary_Exp_Impl: Unary_Exp {
	public let op: Unary_Exp_Impl_Op
	public let rhs: Unary_Exp
	
	public init(op: Unary_Exp_Impl_Op, rhs: Unary_Exp) {
		self.rhs = rhs
		self.op = op
	}
	
	public var description: String {
		get {
			return "(\(op.rawValue)\(rhs))"
		}
	}
}

public enum Unary_Exp_Impl_Op: String { case
	PLUS = "+",
	MINUS = "-",
	LOGNOT = "!"
}

public protocol Primary_Exp: Unary_Exp { }

public struct Primary_Exp_Nil: Primary_Exp {
	public init() {
		
	}
	
	public var description: String {
		get {
			return "Primary_Exp_Nil"
		}
	}
}

public struct Primary_Exp_Integer: Primary_Exp {
	public let value: Int
	
	public init(value: Int) {
		self.value = value
	}
	
	public var description: String {
		get {
			return "Primary_Exp_Integer(\(value))"
		}
	}
}

public struct Primary_Exp_Character: Primary_Exp {
	public let value: Character
	
	public init(value: Character) {
		self.value = value
	}
	
	public var description: String {
		get {
			return "Primary_Exp_Character('\(value)')"
		}
	}
}

public struct Primary_Exp_Boolean: Primary_Exp {
	public let value: Bool
	
	public init(value: Bool) {
		self.value = value
	}
	
	public var description: String {
		get {
			return "Primary_Exp_Boolean(\(value))"
		}
	}
}

public struct Primary_Exp_String: Primary_Exp {
	public let value: String
	
	public init(value: String) {
		self.value = value
	}
	
	public var description: String {
		get {
			return "Primary_Exp_String(\"\(value)\")"
		}
	}
}

public struct Primary_Exp_Sizeof: Primary_Exp {
	public let exp: Exp
	
	public init(exp: Exp) {
		self.exp = exp
	}
	
	public var description: String {
		get {
			return "Primary_Exp_Sizeof(\(exp))"
		}
	}
}

public struct Primary_Exp_Exp: Primary_Exp {
	public let exp: Exp
	
	public init(exp: Exp) {
		self.exp = exp
	}
	
	public var description: String {
		get {
			return "Primary_Exp_Exp(\(exp))"
		}
	}
}

public struct Primary_Exp_Call: Primary_Exp {
	public let ident: String
	public let args: [Arg]
	
	public init(ident: String, args: [Arg]) {
		self.ident = ident
		self.args = args
	}
	
	public var description: String {
		get {
			return "Primary_Exp_Call(\(ident)(\(args)))"
		}
	}
}

public protocol Var: Primary_Exp { }

public struct Var_Ident: Var {
	public let ident: String
	
	public init(ident: String) {
		self.ident = ident
	}
	
	public var description: String {
		get {
			return "Var_Ident(\(ident))"
		}
	}
}

public struct Var_Array_Access: Var {
	public let primary_exp: Primary_Exp
	public let brack_exp: Exp
	
	public init(primary_exp: Primary_Exp, brack_exp: Exp) {
		self.primary_exp = primary_exp
		self.brack_exp = brack_exp
	}
	
	public var description: String {
		get {
			return "Var_Array_Access(\(primary_exp)[\(brack_exp)])"
		}
	}
}

public struct Var_Field_Access: Var {
	public let primary_exp: Primary_Exp
	public let ident: String
	
	public init(primary_exp: Primary_Exp, ident: String) {
		self.primary_exp = primary_exp
		self.ident = ident
	}
	
	public var description: String {
		get {
			return "Var_Field_Access(\(primary_exp).\(ident))"
		}
	}
}

public protocol New_Obj_Spec: Primary_Exp { }

public struct New_Obj_Spec_Ident: New_Obj_Spec {
	public let ident: String
	
	public init(ident: String) {
		self.ident = ident
	}
	
	public var description: String {
		get {
			return "New_Obj_Spec_Ident(new(\(ident)))"
		}
	}
}

public struct New_Obj_Spec_Array: New_Obj_Spec {
	public let ident: String
	public let exp: Exp
	public let more_dims: Int
	
	public init(ident: String, exp: Exp, more_dims: Int) {
		self.ident = ident
		self.exp = exp
		self.more_dims = more_dims
	}
	
	public var description: String {
		get {
			let mor = "[]".repeated(times: more_dims)
			return "new(\(ident)[\(exp)]\(mor));"
		}
	}
}
