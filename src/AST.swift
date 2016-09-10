//
//  AST.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 04/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

extension String {
	func repeated(times: Int) -> String {
		var buffer = ""
		for _ in 0..<times {
			buffer += self
		}
		return buffer
	}
}

protocol ASTNode: CustomStringConvertible { }

struct Program: ASTNode {
	let glob_decs: [Glob_Dec]
	
	var description: String { get { return glob_decs.description } }
}

// MARK: Global Declarations

protocol Glob_Dec: ASTNode { }

struct Type_Dec: Glob_Dec {
	let ident: String
	let type: TypeExpression
	
	var description: String {
		get {
			return "Type_Dec(\(ident) = \(type))"
		}
	}
}

struct Gvar_Dec: Glob_Dec {
	let type: TypeExpression
	let ident: String
	
	var description: String {
		get {
			return "Gvar_Dec(\(type) \(ident))"
		}
	}
}

struct Func_Dec: Glob_Dec {
	let type: TypeExpression?
	let ident: String
	let par_decs: [Par_Dec]
	let lvar_decs: [Lvar_Dec]
	let stms: [Stm]
	
	var description: String {
		get {
			return "Func_Dec(\(type) \(ident))"
		}
	}
}

// MARK: Types

protocol TypeExpression: ASTNode { }

struct IdentifierTypeExpression: TypeExpression {
	let ident: String
	
	var description: String {
		get {
			return "IdentifierType(\(ident))"
		}
	}
}

struct ArrayTypeExpression: TypeExpression {
	let ident: String
	let dims: Int
	
	var description: String {
		get {
			let d = "[]".repeated(times: dims)
			return "ArrayType(\(ident)\(d))"
		}
	}
}

struct RecordTypeExpression: TypeExpression {
	let memb_decs: [Memb_Dec]
	
	var description: String {
		get {
			let mem = memb_decs.reduce("", { return $0 + $1.description + " " })
            return "RecordType( \(mem))"
		}
	}
}

struct Memb_Dec: ASTNode {
	let type: TypeExpression
	let ident: String
	
	var description: String {
		get {
			return "\(type) \(ident);"
		}
	}
}

// MARK: Function

struct Par_Dec: ASTNode {
	let type: TypeExpression
	let ident: String
	
	var description: String {
		get {
			return "\(type) \(ident)"
		}
	}
}

struct Lvar_Dec: ASTNode {
	let type: TypeExpression
	let ident: String
	
	var description: String {
		get {
			return "local \(type) \(ident);"
		}
	}
}

// MARK: Statements

protocol Stm: ASTNode { }

struct Empty_Stm: Stm {
	var description: String {
		get {
			return "Empty_Stm()"
		}
	}
}

struct Compound_Stm: Stm {
	let stms: [Stm]
	
	var description: String {
		get {
			return "Compound_Stm(...)"
		}
	}
}

struct Assign_Stm: Stm {
	let _var: Var
	let exp: Exp
	
	var description: String {
		get {
			return "Assign_Stm(\(_var) = \(exp))"
		}
	}
}

struct If_Stm: Stm {
	let exp: Exp
	let stm: Stm
	let elseStm: Stm?
	
	var description: String {
		get {
			return "If_Stm(\(exp) \(stm) \(elseStm))"
		}
	}
}

struct While_Stm: Stm {
	let exp: Exp
	let stm: Stm
	
	var description: String {
		get {
			return "While_Stm(\(exp) \(stm))"
		}
	}
}

struct Do_Stm: Stm {
	let stm: Stm
	let exp: Exp
	
	var description: String {
		get {
			return "do \(stm) while (\(exp));"
		}
	}
}

struct Break_Stm: Stm {
	var description: String {
		get {
			return "break;"
		}
	}
}

struct Call_Stm: Stm {
	let ident: String
	let args: [Arg]
	
	var description: String {
		get {
			return "\(ident)(\(args);"
		}
	}
}

struct Arg: ASTNode {
	let exp: Exp
	
	var description: String {
		get {
			return "\(exp)"
		}
	}
}

struct Return_Stm: Stm {
	let exp: Exp?
	
	var description: String {
		get {
			if let ex = exp {
				return "return \(ex);"
			}
			else {
				return "return;"
			}
		}
	}
}

// MARK: Other

protocol Var: Primary_Exp { }

struct Var_Ident: Var {
	let ident: String
	
	var description: String {
		get {
			return "Var_Ident(\(ident))"
		}
	}
}

struct Var_Array_Access: Var {
	let primary_exp: Primary_Exp
	let brack_exp: Exp
	
	var description: String {
		get {
			return "Var_Array_Access(\(primary_exp)[\(brack_exp)])"
		}
	}
}

struct Var_Field_Access: Var {
	let primary_exp: Primary_Exp
	let ident: String
	
	var description: String {
		get {
			return "Var_Field_Access(\(primary_exp).\(ident))"
		}
	}
}

// MARK: Expression Boolean

protocol Exp: ASTNode { }

protocol Or_Exp: Exp { }

struct Or_Exp_Binary: Or_Exp {
	let lhs: Or_Exp
	let rhs: And_Exp
	
	var description: String {
		get {
			return "(\(lhs) || \(rhs))"
		}
	}
}

protocol And_Exp: Or_Exp { }

struct And_Exp_Binary: And_Exp {
	let lhs: And_Exp
	let rhs: Rel_Exp
	
	var description: String {
		get {
			return "(\(lhs) && \(rhs))"
		}
	}
}

protocol Rel_Exp: And_Exp { }

struct Rel_Exp_Binary: Rel_Exp {
	let lhs: Add_Exp
	let rhs: Add_Exp
	let op: Rel_Exp_Binary_Op
	
	var description: String {
		get {
			return "(\(lhs) \(op.rawValue) \(rhs))"
		}
	}
}

enum Rel_Exp_Binary_Op: String { case
	EQ = "==",
	NE = "!=",
	LT = "<",
	LE = "<=",
	GT = ">",
	GE = ">="
}

// MARK: Expression Arithmetic

protocol Add_Exp: Rel_Exp { }

struct Add_Exp_Binary: Add_Exp {
	let lhs: Add_Exp
	let rhs: Mul_Exp
	let op: Add_Exp_Binary_Op
	
	var description: String {
		get {
			return "(\(lhs) \(op.rawValue) \(rhs))"
		}
	}
}

enum Add_Exp_Binary_Op: String { case
	PLUS = "+",
	MINUS = "-"
}

protocol Mul_Exp: Add_Exp { }

struct Mul_Exp_Binary: Mul_Exp {
	let lhs: Mul_Exp
	let rhs: Unary_Exp
	let op: Mul_Exp_Binary_Op
	
	var description: String {
		get {
			return "(\(lhs) \(op.rawValue) \(rhs))"
		}
	}
}

enum Mul_Exp_Binary_Op: String { case
	STAR = "*",
	SLASH = "/",
	PERCENT = "%"
}

protocol Unary_Exp: Mul_Exp { }

struct Unary_Exp_Impl: Unary_Exp {
	let op: Unary_Exp_Impl_Op
	let rhs: Unary_Exp
	
	var description: String {
		get {
			return "(\(op.rawValue)\(rhs))"
		}
	}
}

enum Unary_Exp_Impl_Op: String { case
	PLUS = "+",
	MINUS = "-",
	LOGNOT = "!"
}

protocol Primary_Exp: Unary_Exp { }

struct Primary_Exp_Nil: Primary_Exp {
	var description: String {
		get {
			return "Primary_Exp_Nil"
		}
	}
}

struct Primary_Exp_Integer: Primary_Exp {
	let value: Int
	
	var description: String {
		get {
			return "Primary_Exp_Integer(\(value))"
		}
	}
}

struct Primary_Exp_Character: Primary_Exp {
	let value: Character
	
	var description: String {
		get {
			return "Primary_Exp_Character('\(value)')"
		}
	}
}

struct Primary_Exp_Boolean: Primary_Exp {
	let value: Bool
	
	var description: String {
		get {
			return "Primary_Exp_Boolean(\(value))"
		}
	}
}

struct Primary_Exp_String: Primary_Exp {
	let value: String
	
	var description: String {
		get {
			return "Primary_Exp_String(\"\(value)\")"
		}
	}
}

struct Primary_Exp_Sizeof: Primary_Exp {
	let exp: Exp
	
	var description: String {
		get {
			return "Primary_Exp_Sizeof(\(exp))"
		}
	}
}

struct Primary_Exp_Exp: Primary_Exp {
	let exp: Exp
	
	var description: String {
		get {
			return "Primary_Exp_Exp(\(exp))"
		}
	}
}

struct Primary_Exp_Call: Primary_Exp {
	let ident: String
	let args: [Arg]
	
	var description: String {
		get {
			return "Primary_Exp_Call(\(ident)(\(args)))"
		}
	}
}

protocol New_Obj_Spec: Primary_Exp { }

struct New_Obj_Spec_Ident: New_Obj_Spec {
	let ident: String
	
	var description: String {
		get {
			return "New_Obj_Spec_Ident(new(\(ident)))"
		}
	}
}

struct New_Obj_Spec_Array: New_Obj_Spec {
	let ident: String
	let exp: Exp
	let more_dims: Int
	
	var description: String {
		get {
			let mor = "[]".repeated(times: more_dims)
			return "new(\(ident)[\(exp)]\(mor));"
		}
	}
}


