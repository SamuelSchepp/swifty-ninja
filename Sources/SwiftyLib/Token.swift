//
//  Tokenizer.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 06/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

protocol Token {
	var line: Int { get }
}

struct BREAK:	Token { let line: Int }
struct DO:		Token { let line: Int }
struct GLOBAL:	Token { let line: Int }
struct IF:		Token { let line: Int }
struct ELSE:	Token { let line: Int }
struct LOCAL:	Token { let line: Int }
struct NEW:		Token { let line: Int }
struct RECORD:	Token { let line: Int }
struct RETURN:	Token { let line: Int }
struct SIZEOF:	Token { let line: Int }
struct TYPE:	Token { let line: Int }
struct VOID:	Token { let line: Int }
struct WHILE:	Token { let line: Int }
struct NIL:		Token { let line: Int }

struct LPAREN:	Token { let line: Int }
struct RPAREN:	Token { let line: Int }
struct LCURL:	Token { let line: Int }
struct RCURL:	Token { let line: Int }
struct LBRACK:	Token { let line: Int }
struct RBRACK:	Token { let line: Int }
struct ASGN:	Token { let line: Int }
struct COMMA:	Token { let line: Int }
struct SEMIC:	Token { let line: Int }
struct DOT:		Token { let line: Int }
struct LOGOR:	Token { let line: Int }
struct LOGAND:	Token { let line: Int }
struct LOGNOT:	Token { let line: Int }
struct EQ:		Token { let line: Int }
struct NE:		Token { let line: Int }
struct LT:		Token { let line: Int }
struct LE:		Token { let line: Int }
struct GT:		Token { let line: Int }
struct GE:		Token { let line: Int }
struct PLUS:	Token { let line: Int }
struct MINUS:	Token { let line: Int }
struct STAR:	Token { let line: Int }
struct SLASH:	Token { let line: Int }
struct PERCENT:	Token { let line: Int }

struct BOOLEANLIT: Token {
	let line: Int 
	let value: Bool
}
struct INTEGERLIT: Token {
	let line: Int 
	let value: Int
}
struct CHARACTERLIT: Token {
	let line: Int 
	let value: Character
}
struct STRINGLIT: Token {
	let line: Int 
	let value: String
}
struct IDENT: Token {
	let line: Int 
	let value: String
}

class TokenMap {
	class func keywordMap(line: Int) -> [String: Token] {
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
    
	class func operatorMap(line: Int) -> [String: Token] {
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
