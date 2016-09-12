//
//  Tokenizer.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 06/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

class Tokenizer {
	let scanner: Scanner
	
	init(with: String) {
		scanner = Scanner(string: with)
	}
	
	func tokenize() -> [Token]? {
		var tokens = [Token]()
		
		while !scanner.isAtEnd {
			guard let nT = scan() else { return .none }
			tokens.append(nT)
		}
		
		if isDone() {
			return tokens
		}
		else {
			return .none
		}
	}
	
	func isDone() -> Bool {
		return scanner.isAtEnd
	}
	
	private func scan() -> Token? {
		skipComments()
		
		if let token = scanOperators                () { return token }
		if let token = scanBooleanLiteral			() { return token }
		if let token = scanHexIntegerLiteral		() { return token }
		if let token = scanDecimalIntegerLiteral	() { return token }
		if let token = scanCharacterLiteral			() { return token }
		if let token = scanStringLiteral			() { return token }
		if let token = scanIdentifier				() { return token }
		
		return .none
	}
	
	private func skipComments() {
		if scanner.scanString("//", into: nil) {
			scanner.scanUpTo("\n", into: nil)
			scanner.scanString("\n", into: nil)
		}
		if(scanner.scanString("/*", into: nil)) {
			scanner.scanUpTo("*/", into: nil)
			scanner.scanString("*/", into: nil)
		}
	}
	
	private func scanOperators() -> Token? {
		for token in TokenMap.operatorMap.keys {
			let location = scanner.scanLocation
			if scanner.scanString(token, into: nil) {
				return TokenMap.operatorMap[token]
			}
			else {
				scanner.scanLocation = location
			}
		}
		return .none
	}
	
	private func scanDecimalIntegerLiteral() -> Token? {
		var buffer: Int = 0
		let location = scanner.scanLocation
		
		if !scanner.scanInt(&buffer) {
			scanner.scanLocation = location
			return .none
		}
		
		return INTEGERLIT(value: buffer)
	}
	
	private func scanBooleanLiteral() -> Token? {
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

	
	private func scanHexIntegerLiteral() -> Token? {
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
	
	private func scanCharacterLiteral() -> Token? {
		var buffer: NSString? = ""
		let location = scanner.scanLocation
		
		if !scanner.scanString("'", into: nil) {
			scanner.scanLocation = location
			return .none
		}
		
		scanner.scanUpTo("'", into: &buffer)
		
		if (buffer!.length != 1 && !["\\n", "\\r", "\\t"].contains(buffer! as String)) {
			scanner.scanLocation = location
			return .none
		}
		
		if !scanner.scanString("'", into: nil) {
			scanner.scanLocation = location
			return .none
		}
		
		var character: Character
		let s = buffer! as String
		switch s {
		case "\\n":
			character = "\n"
		case "\\r":
			character = "\r"
		case "\\t":
			character = "\t"
		default:
			character = s.characters.first!
		}
		
		return CHARACTERLIT(value: character)
	}
	
	private func scanStringLiteral() -> Token? {
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
	
	private func scanIdentifier() -> Token? {
		var buffer: NSString? = ""
		let location = scanner.scanLocation
		
		if !scanner.scanCharacters(from: CharacterSet.alphanumerics, into: &buffer) {
			scanner.scanLocation = location
			return .none
		}
        
        let s = buffer! as String
        if let keyword = TokenMap.keywordMap[s] {
            return keyword
        }
        else {
            return IDENT(value: buffer! as String)
        }
	}
}
