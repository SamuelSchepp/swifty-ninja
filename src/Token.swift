//
//  Tokenizer.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 06/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

protocol Token { }

struct BREAK:	Token { }
struct DO:		Token { }
struct GLOBAL:	Token { }
struct IF:		Token { }
struct ELSE:	Token { }
struct LOCAL:	Token { }
struct NEW:		Token { }
struct RECORD:	Token { }
struct RETURN:	Token { }
struct SIZEOF:	Token { }
struct TYPE:	Token { }
struct VOID:	Token { }
struct WHILE:	Token { }
struct NIL:		Token { }

struct LPAREN:	Token { }
struct RPAREN:	Token { }
struct LCURL:	Token { }
struct RCURL:	Token { }
struct LBRACK:	Token { }
struct RBRACK:	Token { }
struct ASGN:	Token { }
struct COMMA:	Token { }
struct SEMIC:	Token { }
struct DOT:		Token { }
struct LOGOR:	Token { }
struct LOGAND:	Token { }
struct LOGNOT:	Token { }
struct EQ:		Token { }
struct NE:		Token { }
struct LT:		Token { }
struct LE:		Token { }
struct GT:		Token { }
struct GE:		Token { }
struct PLUS:	Token { }
struct MINUS:	Token { }
struct STAR:	Token { }
struct SLASH:	Token { }
struct PERCENT:	Token { }

struct BOOLEANLIT: Token {
	let value: Bool
}
struct INTEGERLIT: Token {
	let value: Int
}
struct CHARACTERLIT: Token {
	let value: Character
}
struct STRINGLIT: Token {
	let value: String
}
struct IDENT: Token {
	let value: String
}

class TokenMap {
	class var map: [String: Token] {
		get {
			return [
				"break":	BREAK(),
				"do":		DO(),
				"else":		ELSE(),
				"global":	GLOBAL(),
				"if":		IF(),
				"local"	:	LOCAL(),
				"new":		NEW(),
				"record":	RECORD(),
				"return":	RETURN(),
				"sizeof":	SIZEOF(),
				"type":		TYPE(),
				"void":		VOID(),
				"while":	WHILE(),
				
				"(":		LPAREN(),
				")":		RPAREN(),
				"{":		LCURL(),
				"}":		RCURL(),
				"[":		LBRACK(),
				"]":		RBRACK(),
				"=":		ASGN(),
				",":		COMMA(),
				";":		SEMIC(),
				".":		DOT(),
				"||":		LOGOR(),
				"&&":		LOGAND(),
				"!":		LOGNOT(),
				"==":		EQ(),
				"!=":		NE(),
				"<":		LT(),
				"<=":		LE(),
				">":		GT(),
				">=":		GE(),
				"+":		PLUS(),
				"-":		MINUS(),
				"*":		STAR(),
				"/":		SLASH(),
				"%":		PERCENT(),
				
				"nil":		NIL()
			]
		}
	}
}
