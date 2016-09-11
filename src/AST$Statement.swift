//
//  AST$Statement.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 11/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

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
	let stms: Stms
	
	var description: String {
		get {
			return "Compound_Stm(...)"
		}
	}
}

struct Stms: ASTNode {
	let stms: [Stm]
	
	var description: String {
		get {
			return "Stms"
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
