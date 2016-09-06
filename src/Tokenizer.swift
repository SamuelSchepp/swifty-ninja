//
//  Tokenizer.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 06/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

class Tokenizer {
	public class func tokenize(string: String) -> [Token] {
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
		
		if let token = scanMappedToken				(scanner: scanner) { return token }
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
	
	private class func scanMappedToken(scanner: Scanner) -> Token? {
		for tokenString in TokenMap.map.keys {
			let location = scanner.scanLocation
			if scanner.scanString(tokenString, into: nil) {
				return TokenMap.map[tokenString]!
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
		if scanner.scanInt(&buffer) {
			return .INTEGERLIT(value: buffer)
		}
		else {
			scanner.scanLocation = location
			return .none
		}
	}
	
	private class func scanHexIntegerLiteral(scanner: Scanner) -> Token? {
		var buffer: UInt32 = 0
		let location = scanner.scanLocation
		if !scanner.scanString("0x", into: nil) {
			scanner.scanLocation = location
			return .none
		}
		if scanner.scanHexInt32(&buffer) {
			return .INTEGERLIT(value: Int(buffer))
		}
		else {
			scanner.scanLocation = location
			return .none
		}
	}
	
	private class func scanCharacterLiteral(scanner: Scanner) -> Token? {
		var buffer: NSString? = ""
		let location = scanner.scanLocation
		
		if !scanner.scanString("'", into: nil) {
			scanner.scanLocation = location
			return .none
		}
		
		if !scanner.scanUpTo("'", into: &buffer) {
			scanner.scanLocation = location
			return .none
		}
		
		if (buffer!.length != 1) {
			scanner.scanLocation = location
			return .none
		}
		
		if !scanner.scanString("'", into: nil) {
			scanner.scanLocation = location
			return .none
		}
		
		return .CHARACTERLIT(value: String(describing: buffer!))
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
		
		return .STRINGLIT(value: String(describing: buffer!))
		
	}
	
	private class func scanIdentifier(scanner: Scanner) -> Token? {
		var buffer: NSString? = ""
		let location = scanner.scanLocation
		
		if !scanner.scanCharacters(from: CharacterSet.alphanumerics, into: &buffer) {
			scanner.scanLocation = location
			return .none
		}
		
		return .IDENT(identifier: String(describing: buffer!))
		
	}
}
