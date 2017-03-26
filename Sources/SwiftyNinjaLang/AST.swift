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

public protocol ASTNode: CustomStringConvertible { }

public class Program: ASTNode {
	public let glob_decs: Glob_Decs
	
	public init(glob_decs: Glob_Decs) {
		self.glob_decs = glob_decs
	}
	
	public var description: String { get { return glob_decs.description } }
}

// MARK: Global Declarations

public class Glob_Decs: ASTNode {
	public let glob_decs: [Glob_Dec]
	
	public init(glob_decs: [Glob_Dec]) {
		self.glob_decs = glob_decs
	}
	
	public var description: String { get { return glob_decs.description } }
}

public protocol Glob_Dec: ASTNode { }

public class Type_Dec: Glob_Dec {
	public let ident: String
	public let type: TypeExpression
	
	public init(ident: String, type: TypeExpression) {
		self.ident = ident
		self.type = type
	}
	
	public var description: String {
		get {
			return "Type_Dec(\(ident) = \(type))"
		}
	}
}

public class Gvar_Dec: Glob_Dec {
	public let ident: String
	public let type: TypeExpression
	
	public init(ident: String, type: TypeExpression) {
		self.ident = ident
		self.type = type
	}
	
	public var description: String {
		get {
			return "Gvar_Dec(\(type) \(ident))"
		}
	}
}

public class Func_Dec: Glob_Dec {
	public let type: TypeExpression?
	public let ident: String
	public let par_decs: [Par_Dec]
	public let lvar_decs: [Lvar_Dec]
	public let stms: Stms
	
	public init(type: TypeExpression?, ident: String, par_decs: [Par_Dec], lvar_decs: [Lvar_Dec], stms: Stms) {
		self.type = type
		self.ident = ident
		self.par_decs = par_decs
		self.lvar_decs = lvar_decs
		self.stms = stms
	}
	
	public var description: String {
		get {
			return "Func_Dec(\(type) \(ident) (\(par_decs)) { \(lvar_decs) \n \(stms) }"
		}
	}
}

// MARK: Types

public protocol TypeExpression: ASTNode { }

public class IdentifierTypeExpression: TypeExpression {
	public let ident: String
	
	public init(ident: String) {
		self.ident = ident
	}
	
	public var description: String {
		get {
			return "IdentifierType(\(ident))"
		}
	}
}

public class ArrayTypeExpression: TypeExpression {
	public let ident: String
	public let dims: Int
	
	public init(ident: String, dims: Int) {
		self.ident = ident
		self.dims = dims
	}
	
	public var description: String {
		get {
			let d = "[]".repeated(times: dims)
			return "ArrayType(\(ident)\(d))"
		}
	}
}

public class RecordTypeExpression: TypeExpression {
	public let memb_decs: [Memb_Dec]
	
	public init(memb_decs: [Memb_Dec]) {
		self.memb_decs = memb_decs
	}
	
	public var description: String {
		get {
			let mem = memb_decs.reduce("", { return $0 + $1.description + " " })
            return "RecordType( \(mem))"
		}
	}
}

public class Memb_Dec: ASTNode {
	public let type: TypeExpression
	public let ident: String
	
	public init(type: TypeExpression, ident: String) {
		self.type = type;
		self.ident = ident;
	}
	
	public var description: String {
		get {
			return "\(type) \(ident);"
		}
	}
}

// MARK: Function

public class Par_Dec: ASTNode {
	public let type: TypeExpression
	public let ident: String
	
	public init(type: TypeExpression, ident: String) {
		self.type = type
		self.ident = ident
	}
	
	public var description: String {
		get {
			return "\(type) \(ident)"
		}
	}
}

public class Lvar_Dec: ASTNode {
	public let type: TypeExpression
	public let ident: String
	
	public init(type: TypeExpression, ident: String) {
		self.type = type
		self.ident = ident
	}
	
	public var description: String {
		get {
			return "local \(type) \(ident);"
		}
	}
}





