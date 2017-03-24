//
//  Tokenizer.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 06/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

public protocol Token {
	var line: Int { get }
}

public struct BREAK: Token { 
	public let line: Int 
	
	public init(line: Int) {
		self.line = line
	}
}

public struct DO: Token { 
	public let line: Int 
	
	public init(line: Int) {
		self.line = line
	}
}

public struct GLOBAL: Token { 
	public let line: Int 
	
	public init(line: Int) {
		self.line = line
	}
}

public struct IF: Token { 
	public let line: Int 
	
	public init(line: Int) {
		self.line = line
	}
}

public struct ELSE: Token { 
	public let line: Int 
	
	public init(line: Int) {
		self.line = line
	}
}

public struct LOCAL: Token { 
	public let line: Int 
	
	public init(line: Int) {
		self.line = line
	}
}

public struct NEW: Token { 
	public let line: Int 
	
	public init(line: Int) {
		self.line = line
	}
}

public struct RECORD: Token { 
	public let line: Int 
	
	public init(line: Int) {
		self.line = line
	}
}

public struct RETURN: Token { 
	public let line: Int 
	
	public init(line: Int) {
		self.line = line
	}
}

public struct SIZEOF: Token { 
	public let line: Int 
	
	public init(line: Int) {
		self.line = line
	}
}

public struct TYPE: Token { 
	public let line: Int 
	
	public init(line: Int) {
		self.line = line
	}
}

public struct VOID: Token { 
	public let line: Int 
	
	public init(line: Int) {
		self.line = line
	}
}

public struct WHILE: Token { 
	public let line: Int 
	
	public init(line: Int) {
		self.line = line
	}
}

public struct NIL: Token { 
	public let line: Int 
	
	public init(line: Int) {
		self.line = line
	}
}


public struct LPAREN: Token { 
	public let line: Int 
	
	public init(line: Int) {
		self.line = line
	}
}

public struct RPAREN: Token { 
	public let line: Int 
	
	public init(line: Int) {
		self.line = line
	}
}

public struct LCURL: Token { 
	public let line: Int 
	
	public init(line: Int) {
		self.line = line
	}
}

public struct RCURL: Token { 
	public let line: Int 
	
	public init(line: Int) {
		self.line = line
	}
}

public struct LBRACK: Token { 
	public let line: Int 
	
	public init(line: Int) {
		self.line = line
	}
}

public struct RBRACK: Token { 
	public let line: Int 
	
	public init(line: Int) {
		self.line = line
	}
}

public struct ASGN: Token { 
	public let line: Int 
	
	public init(line: Int) {
		self.line = line
	}
}

public struct COMMA: Token { 
	public let line: Int 
	
	public init(line: Int) {
		self.line = line
	}
}

public struct SEMIC: Token { 
	public let line: Int 
	
	public init(line: Int) {
		self.line = line
	}
}

public struct DOT: Token { 
	public let line: Int 
	
	public init(line: Int) {
		self.line = line
	}
}

public struct LOGOR: Token { 
	public let line: Int 
	
	public init(line: Int) {
		self.line = line
	}
}

public struct LOGAND: Token { 
	public let line: Int 
	
	public init(line: Int) {
		self.line = line
	}
}

public struct LOGNOT: Token { 
	public let line: Int 
	
	public init(line: Int) {
		self.line = line
	}
}

public struct EQ: Token { 
	public let line: Int 
	
	public init(line: Int) {
		self.line = line
	}
}

public struct NE: Token { 
	public let line: Int 
	
	public init(line: Int) {
		self.line = line
	}
}

public struct LT: Token { 
	public let line: Int 
	
	public init(line: Int) {
		self.line = line
	}
}

public struct LE: Token { 
	public let line: Int 
	
	public init(line: Int) {
		self.line = line
	}
}

public struct GT: Token { 
	public let line: Int 
	
	public init(line: Int) {
		self.line = line
	}
}

public struct GE: Token { 
	public let line: Int 
	
	public init(line: Int) {
		self.line = line
	}
}

public struct PLUS: Token { 
	public let line: Int 
	
	public init(line: Int) {
		self.line = line
	}
}

public struct MINUS: Token { 
	public let line: Int 
	
	public init(line: Int) {
		self.line = line
	}
}

public struct STAR: Token { 
	public let line: Int 
	
	public init(line: Int) {
		self.line = line
	}
}

public struct SLASH: Token { 
	public let line: Int 
	
	public init(line: Int) {
		self.line = line
	}
}

public struct PERCENT: Token { 
	public let line: Int 
	
	public init(line: Int) {
		self.line = line
	}
}


public struct BOOLEANLIT: Token {
	public let line: Int 
	public let value: Bool
	
	public init(line: Int, value: Bool) {
		self.line = line
		self.value = value
	}
}
public struct INTEGERLIT: Token {
	public let line: Int 
	public let value: Int
	
	public init(line: Int, value: Int) {
		self.line = line
		self.value = value
	}
}
public struct CHARACTERLIT: Token {
	public let line: Int 
	public let value: Character
	
	public init(line: Int, value: Character) {
		self.line = line
		self.value = value
	}
}
public struct STRINGLIT: Token {
	public let line: Int 
	public let value: String
	
	public init(line: Int, value: String) {
		self.line = line
		self.value = value
	}
}
public struct IDENT: Token {
	public let line: Int 
	public let value: String
	
	public init(line: Int, value: String) {
		self.line = line
		self.value = value
	}
}

public class TokenMap {
	public class func keywordMap(line: Int) -> [String: Token] {
		return [
			"break":	BREAK(line: line),
			"do":		DO(line: line),
			"else":		ELSE(line: line),
			"global":	GLOBAL(line: line),
			"if":		IF(line: line),
			"local"	:	LOCAL(line: line),
			"new":		NEW(line: line),
			"record":	RECORD(line: line),
			"return":	RETURN(line: line),
			"sizeof":	SIZEOF(line: line),
			"type":		TYPE(line: line),
			"void":		VOID(line: line),
			"while":	WHILE(line: line),
			"nil":		NIL(line: line)
		]
    }
    
	public class func operatorMap(line: Int) -> [String: Token] {
		return [
			"||":		LOGOR(line: line),
			"&&":		LOGAND(line: line),
			"!":		LOGNOT(line: line),
			"==":		EQ(line: line),
			"!=":		NE(line: line),
			"<":		LT(line: line),
			"<=":		LE(line: line),
			">":		GT(line: line),
			">=":		GE(line: line),
			"(":		LPAREN(line: line),
			")":		RPAREN(line: line),
			"{":		LCURL(line: line),
			"}":		RCURL(line: line),
			"[":		LBRACK(line: line),
			"]":		RBRACK(line: line),
			"=":		ASGN(line: line),
			",":		COMMA(line: line),
			";":		SEMIC(line: line),
			".":		DOT(line: line),
			"+":		PLUS(line: line),
			"-":		MINUS(line: line),
			"*":		STAR(line: line),
			"/":		SLASH(line: line),
			"%":		PERCENT(line: line)
		]
	}
}
