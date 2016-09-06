//
//  Tokenizer.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 06/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

enum Token { case
	BREAK,
	DO,
	ELSE,
	GLOBAL,
	IF,
	LOCAL,
	NEW,
	RECORD,
	RETURN,
	SIZEOF,
	TYPE,
	VOID,
	WHILE,
	
	LPAREN,
	RPAREN,
	LCURL,
	RCURL,
	LBRACK,
	RBRACK,
	ASGN,
	COMMA,
	SEMIC,
	DOT,
	LOGOR,
	LOGAND,
	LOGNOT,
	EQ,
	NE,
	LT,
	LE,
	GT,
	GE,
	PLUS,
	MINUS,
	STAR,
	SLASH,
	PERCENT,
	
	NIL,
	
	BOOLEANLIT(value: Bool),
	INTEGERLIT(value: Int),
	CHARACTERLIT(value: String),
	STRINGLIT(value: String),
	IDENT(identifier: String)
}

class TokenMap {
	class var map: [String: Token] {
		get {
			return [
				"break":	.BREAK,
				"do":		.DO,
				"else":		.ELSE,
				"global":	.GLOBAL,
				"if":		.IF,
				"local"	:	.LOCAL,
				"new":		.NEW,
				"record":	.RECORD,
				"return":	.RETURN,
				"sizeof":	.SIZEOF,
				"type":		.TYPE,
				"void":		.VOID,
				"while":	.WHILE,
				
				"(":		.LPAREN,
				")":		.RPAREN,
				"{":		.LCURL,
				"}":		.RCURL,
				"[":		.LBRACK,
				"]":		.RBRACK,
				"=":		.ASGN,
				",":		.COMMA,
				";":		.SEMIC,
				".":		.DOT,
				"||":		.LOGOR,
				"&&":		.LOGAND,
				"!":		.LOGNOT,
				"==":		.EQ,
				"!=":		.NE,
				"<":		.LT,
				"<=":		.LE,
				">":		.GT,
				">=":		.GE,
				"+":		.PLUS,
				"-":		.MINUS,
				"*":		.STAR,
				"/":		.SLASH,
				"%":		.PERCENT,
				
				"nil":		.NIL,
				
				"true":		.BOOLEANLIT(value: true),
				"false":	.BOOLEANLIT(value: false),
				
				"'\n'":		.CHARACTERLIT(value: "\n"),
				"'\r'":		.CHARACTERLIT(value: "\r"),
				"'\t'":		.CHARACTERLIT(value: "\t"),
				// "'\b'":		.CHARACTERLIT(value: "\b"),
				// "'\a'":		.CHARACTERLIT(value: ""),
				"'\''":		.CHARACTERLIT(value: "'"),
				"'\"'":		.CHARACTERLIT(value: "\""),
				"'\\'":		.CHARACTERLIT(value: "\\")
			]
		}
	}
	
	class func getToken(forString: String) -> Token? {
		return map[forString]
	}
}
