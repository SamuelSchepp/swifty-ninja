//
//  AST$Statement.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 11/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

// MARK: Statements

public protocol Stm: ASTNode { }

public struct Empty_Stm: Stm {
	public init() {
		
	}
	
	public var description: String {
		get {
			return "Empty_Stm()"
		}
	}
}

public struct Compound_Stm: Stm {
	public let stms: Stms
	
	public init(stms: Stms) {
		self.stms = stms
	}
	
	public var description: String {
		get {
			return "Compound_Stm(\(stms))"
		}
	}
}

public struct Stms: ASTNode {
	public let stms: [Stm]
	
	public init(stms: [Stm]) {
		self.stms = stms
	}
	
	public var description: String {
		get {
			return "Stms(\(stms))"
		}
	}
}

public struct Assign_Stm: Stm {
	public let _var: Var
	public let exp: Exp
	
	public init(_var: Var, exp: Exp) {
		self._var = _var
		self.exp = exp
	}
	
	public var description: String {
		get {
			return "Assign_Stm(\(_var) = \(exp))"
		}
	}
}

public struct If_Stm: Stm {
	public let exp: Exp
	public let stm: Stm
	public let elseStm: Stm?
	
	public init(exp: Exp, stm: Stm, elseStm: Stm?) {
		self.exp = exp
		self.stm = stm
		self.elseStm = elseStm
	}
	
	public var description: String {
		get {
			return "If_Stm(\(exp) \(stm) \(elseStm))"
		}
	}
}

public struct While_Stm: Stm {
	public let exp: Exp
	public let stm: Stm
	
	public init(exp: Exp, stm: Stm) {
		self.exp = exp
		self.stm = stm
	}
	
	public var description: String {
		get {
			return "While_Stm(\(exp) \(stm))"
		}
	}
}

public struct Do_Stm: Stm {
	public let stm: Stm
	public let exp: Exp
	
	public init(exp: Exp, stm: Stm) {
		self.exp = exp
		self.stm = stm
	}
	
	public var description: String {
		get {
			return "do \(stm) while (\(exp));"
		}
	}
}

public struct Break_Stm: Stm {
	public init() {
		
	}
	
	public var description: String {
		get {
			return "break;"
		}
	}
}

public struct Call_Stm: Stm {
	public let ident: String
	public let args: [Arg]
	
	public init(ident: String, args: [Arg]) {
		self.ident = ident
		self.args = args
	}
	
	public var description: String {
		get {
			return "\(ident)(\(args);"
		}
	}
}

public struct Arg: ASTNode {
	public let exp: Exp
	
	public init(exp: Exp) {
		self.exp = exp
	}
	
	public var description: String {
		get {
			return "\(exp)"
		}
	}
}

public struct Return_Stm: Stm {
	public let exp: Exp?
	
	public init(exp: Exp?) {
		self.exp = exp
	}
	
	public var description: String {
		get {
			return "return \(exp);"
		}
	}
}
