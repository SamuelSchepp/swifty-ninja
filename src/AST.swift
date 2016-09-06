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
		for _ in 0...times {
			buffer += self
		}
		return buffer
	}
}

extension Array {
	static func mkString(from: [CustomStringConvertible], sep: String) -> String {
		return from.reduce("", { (akku: String, current: CustomStringConvertible) in
			return akku + current.description + sep
		})
	}
}

protocol ASTNode: CustomStringConvertible { }


struct Program: ASTNode {
	let glob_decs: [Glob_Dec]
	
	var description: String { get { return Array.mkString(from: glob_decs, sep: "\n") } }
}

//

struct Ident: ASTNode {
	let value: String
	
	var description: String { get { return value } }
}

// MARK: Global Declarations

protocol Glob_Dec: ASTNode { }

struct Type_Dec: Glob_Dec {
	let ident: Ident
	let type: Type
	
	var description: String { get { return "type \(ident) = \(type);" } }
}

struct Gvar_Dec: Glob_Dec {
	let type: Type
	let ident: Ident
	
	var description: String { get { return "global \(type) \(ident);" } }
}

struct Func_Dec: Glob_Dec {
	let type: Type?
	let ident: Ident
	let par_decs: [Par_Dec]
	let lvar_decs: [Lvar_Dec]
	let stms: [Stm]
	
	var description: String {
		get {
			let ty = type?.description ?? "void"
			let pars = Array.mkString(from: par_decs, sep: ", ")
			let lvars = Array.mkString(from: lvar_decs, sep: "\n")
			let sts = Array.mkString(from: stms, sep: "\n")
			
			return "\(ty) \(ident)(\(pars)) {\n" +
				"\(lvars)" +
				"\(sts)" +
				"}\n"
		}
	}
}

// MARK: Types

protocol Type: ASTNode { }

struct IdentifierType: Type {
	let ident: Ident
	
	var description: String {
		get {
			return ident.description
		}
	}
}

struct ArrayType: Type {
	let ident: Ident
	let dims: Int
	
	var description: String {
		get {
			let dim = "[]".repeated(times: dims)
			return "\(ident)\(dim)"
		}
	}
}

struct RecordType: Type {
	let memb_decs: [Memb_Dec]
	
	var description: String {
		get {
			return memb_decs.reduce("", { return $0 + $1.description + "\n" })
		}
	}
}

struct Memb_Dec: ASTNode {
	let type: Type
	let ident: Ident
	
	var description: String {
		get {
			return "\(type) \(ident);"
		}
	}
}

// MARK: Function

struct Par_Dec: ASTNode {
	let type: Type
	let ident: Ident
	
	var description: String {
		get {
			return "\(type) \(ident)"
		}
	}
}

struct Lvar_Dec: ASTNode {
	let type: Type
	let ident: Ident
	
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
			return ";"
		}
	}
}

struct Compound_Stm: Stm {
	let stms: [Stm]
	
	var description: String {
		get {
			return stms.mkString("\n")
		}
	}
}

struct Assign_Stm: Stm {
	let _var: Var
	let exp: Exp
}

struct If_Stm: Stm {
	let exp: Exp
	let stm: Stm
	let elseStm: Stm?
}

struct While_Stm: Stm {
	let exp: Exp
	let stm: Stm
}

struct Do_Stm: Stm {
	let stm: Stm
	let exp: Exp
}

struct Break_Stm: Stm {
	
}

struct Call_Stm: Stm {
	let ident: Ident
	let args: [Arg]
}

struct Arg: ASTNode {
	let exp: Exp
}

struct Return_Stm: Stm {
	let exp: Exp?
}

// MARK: Other

protocol Var: ASTNode { }

struct Var_Ident: Var {
	let ident: Ident
}

struct Var_Array_Access: Var {
	let primary_exp: Primary_Exp
	let brack_exp: Exp
}

struct Var_Field_Access: Var {
	let primary_exp: Primary_Exp
	let ident: Ident
}

// MARK: Expression Boolean

protocol Exp: ASTNode { }

protocol Or_Exp: Exp { }

struct Or_Exp_Binary: Or_Exp {
	let lhs: Or_Exp
	let rhs: And_Exp
}

protocol And_Exp: Or_Exp { }

struct And_Exp_Binary: Or_Exp {
	let lhs: And_Exp
	let rhs: Rel_Exp
}

protocol Rel_Exp: And_Exp { }

struct Rel_Exp_Binary: Rel_Exp {
	let lhs: Add_Exp
	let rhs: Add_Exp
	let op: Rel_Exp_Binary_Op
}

enum Rel_Exp_Binary_Op { case
	EQ, NE, LT, LE, GT, GE
}

// MARK: Expression Arithmetic

protocol Add_Exp: Rel_Exp { }

struct Add_Exp_Binary: Add_Exp {
	let lhs: Add_Exp
	let rhs: Mul_Exp
	let op: Add_Exp_Binary_Op
}

enum Add_Exp_Binary_Op { case
	PLUS, MINUS
}

protocol Mul_Exp: Add_Exp { }

struct Mul_Exp_Binary: Mul_Exp {
	let lhs: Mul_Exp
	let rhs: Unary_Exp
	let op: Mul_Exp_Binary_Op
}

enum Mul_Exp_Binary_Op { case
	STAR, SLASH, PERCENT
}

protocol Unary_Exp: Mul_Exp { }

struct Unary_Exp_Impl: Unary_Exp {
	let op: Unary_Exp_Impl_Op
	let rhs: Unary_Exp
}

enum Unary_Exp_Impl_Op { case
	PLUS, MINUS, LOGNOT
}

protocol Primary_Exp: Unary_Exp { }

struct Primary_Exp_Nil: Primary_Exp { }

struct Primary_Exp_Integer: Primary_Exp {
	let value: Int
}

struct Primary_Exp_Character: Primary_Exp {
	let value: String
}

struct Primary_Exp_Boolean: Primary_Exp {
	let value: Bool
}

struct Primary_Exp_String: Primary_Exp {
	let value: String
}

protocol New_Obj_Spec: Primary_Exp { }

struct New_Obj_Spec_Ident: New_Obj_Spec {
	let ident: Ident
}

struct New_Obj_Spec_Array: New_Obj_Spec {
	let ident: Ident
	let exp: Exp
	let more_dims: Int
}


