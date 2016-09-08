//
//  Tokenizer.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 06/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

class Tokenizer {
	class func tokenize(string: String) -> [Token] {
		let scanner = Scanner(string: string)
		var tokens = [Token]()
		
		while !scanner.isAtEnd {
			guard let nT = scan(scanner: scanner) else { return tokens }
			tokens.append(nT)
		}
		
		return tokens
	}
	
	private class func scan(scanner: Scanner) -> Token? {
		skipComments(scanner: scanner)
		
		if let token = scanKeywordsAndOperators		(scanner: scanner) { return token }
		if let token = scanBooleanLiteral			(scanner: scanner) { return token }
		if let token = scanHexIntegerLiteral		(scanner: scanner) { return token }
		if let token = scanDecimalIntegerLiteral	(scanner: scanner) { return token }
		if let token = scanCharacterLiteral			(scanner: scanner) { return token }
		if let token = scanStringLiteral			(scanner: scanner) { return token }
		if let token = scanIdentifier				(scanner: scanner) { return token }
		
		return .none
	}
	
	private class func skipComments(scanner: Scanner) {
		if scanner.scanString("//", into: nil) {
			scanner.scanUpTo("\n", into: nil)
			scanner.scanString("\n", into: nil)
		}
		if(scanner.scanString("/*", into: nil)) {
			scanner.scanUpTo("*/", into: nil)
			scanner.scanString("*/", into: nil)
		}
	}
	
	private class func scanKeywordsAndOperators(scanner: Scanner) -> Token? {
		for token in TokenMap.map.keys {
			let location = scanner.scanLocation
			if scanner.scanString(token, into: nil) {
				return TokenMap.map[token]
			}
			else {
				scanner.scanLocation = location
			}
		}
		return .none
	}
	
	private class func scanDecimalIntegerLiteral(scanner: Scanner) -> Token? {
		var buffer: Int = 0
		let location = scanner.scanLocation
		
		if !scanner.scanInt(&buffer) {
			scanner.scanLocation = location
			return .none
		}
		
		return INTEGERLIT(value: buffer)
	}
	
	private class func scanBooleanLiteral(scanner: Scanner) -> Token? {
		let location = scanner.scanLocation
		if scanner.scanString("true", into: nil) {
			return BOOLEANLIT(value: true)
		}
		else {
			scanner.scanLocation = location
		}
		
		if !scanner.scanString("false", into: nil) {
			scanner.scanLocation = location
			return .none
		}
		
		return BOOLEANLIT(value: false)
	}

	
	private class func scanHexIntegerLiteral(scanner: Scanner) -> Token? {
		var buffer: UInt32 = 0
		let location = scanner.scanLocation
		
		if !scanner.scanString("0x", into: nil) {
			scanner.scanLocation = location
			return .none
		}
		
		if !scanner.scanHexInt32(&buffer) {
			scanner.scanLocation = location
			return .none
		}
		return INTEGERLIT(value: Int(buffer))
	}
	
	private class func scanCharacterLiteral(scanner: Scanner) -> Token? {
		var buffer: NSString? = ""
		let location = scanner.scanLocation
		
		if !scanner.scanString("'", into: nil) {
			scanner.scanLocation = location
			return .none
		}
		
		scanner.scanUpTo("'", into: &buffer)
		
		if (buffer!.length != 1 && !["\\n", "\\r", "\\t", "\\b", "\\a", "\\'", "\"", "\\"].contains(buffer! as String)) {
			scanner.scanLocation = location
			return .none
		}
		
		if !scanner.scanString("'", into: nil) {
			scanner.scanLocation = location
			return .none
		}
		
		return CHARACTERLIT(value: buffer! as String)
	}
	
	private class func scanStringLiteral(scanner: Scanner) -> Token? {
		var buffer: NSString? = ""
		let location = scanner.scanLocation
		
		if !scanner.scanString("\"", into: nil) {
			scanner.scanLocation = location
			return .none
		}
		
		scanner.scanUpTo("\"", into: &buffer)
		
		if !scanner.scanString("\"", into: nil) {
			scanner.scanLocation = location
			return .none
		}
		
		return STRINGLIT(value: buffer! as String)
	}
	
	private class func scanIdentifier(scanner: Scanner) -> Token? {
		var buffer: NSString? = ""
		let location = scanner.scanLocation
		
		if !scanner.scanCharacters(from: CharacterSet.alphanumerics, into: &buffer) {
			scanner.scanLocation = location
			return .none
		}
		
		return IDENT(value: buffer! as String)
	}
}
