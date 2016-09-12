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
	let stms: Stms
	
	var description: String {
		get {
			return "Func_Dec(\(type) \(ident) (\(par_decs)) { \(lvar_decs) \n \(stms) }"
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





