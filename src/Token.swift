//
//  Tokenizer.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 06/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

protocol Token: CustomStringConvertible {
	var identifier: String { get }
}

struct StdToken: Token {
	let identifier: String
	
	var description: String {
		get {
			return "StdToken(\(identifier))"
		}
	}
}

struct ValueToken<Type: CustomStringConvertible>: Token {
	let identifier: String
	let value: Type
	
	var description: String {
		get {
			return "ValueToken(\(identifier), \(value.description))"
		}
	}
}

class TokenMap {
	static let keywordsAndOperators = [
		"break",
		"do",
		"else",
		"global",
		"if",
		"local",
		"new",
		"record",
		"return",
		"sizeof",
		"type",
		"void",
		"while",
		"nil",
		
		"(",
		")",
		"{",
		"}",
		"[",
		"]",
		"=",
		",",
		";",
		".",
		"||",
		"&&",
		"!",
		"==",
		"!=",
		"<",
		"<=",
		">",
		">=",
		"+",
		"-",
		"*",
		"/",
		"%"
	]
}
