//
//  Tokenizer.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 06/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation
import SwiftyNinjaLang
import SwiftyNinjaUtils

public enum TokenizerError: Error {
	case TokenizerError(line: Int)
}

public class Tokenizer {
	public let input: String
	
	public init(with: String) {
		input = with
	}
	
	public func tokenize() throws -> [Token]  {
		var tokens = [Token]()
		
		let lines = input.components(separatedBy: "\n")
		for i in 0..<lines.count {
			let line = lines[i]
			let scanner = Scanner(string: line)
			scanner.charactersToBeSkipped?.insert("\t")
			while true {
				guard let nT = scan(scanner: scanner, line: i + 1) else { break }
				tokens.append(nT)
			}
			/* if !scanner.isAtEndPlatform {
				throw TokenizerError.TokenizerError(line: i + 1)
			}*/
		}
		
		return tokens
	}
	
	private func scan(scanner: Scanner, line: Int) -> Token? {
		skipComments(scanner: scanner, line: line)
		
		if let token = scanOperators				(scanner: scanner, line: line) { return token }
		if let token = scanBooleanLiteral			(scanner: scanner, line: line) { return token }
		if let token = scanHexIntegerLiteral		(scanner: scanner, line: line) { return token }
		if let token = scanDecimalIntegerLiteral	(scanner: scanner, line: line) { return token }
		if let token = scanCharacterLiteral			(scanner: scanner, line: line) { return token }
		if let token = scanStringLiteral			(scanner: scanner, line: line) { return token }
		if let token = scanIdentifier				(scanner: scanner, line: line) { return token }
		
		return .none
	}
	
	private func skipComments(scanner: Scanner, line: Int) {
		if scanner.scanString(string: "//") != nil {
			let oldskipper = scanner.charactersToBeSkipped
			scanner.charactersToBeSkipped = CharacterSet()
			_ = scanner.scanUpToString("\n")
			_ = scanner.scanString(string: "\n")
			scanner.charactersToBeSkipped = oldskipper
			skipComments(scanner: scanner, line: line)
		}
		if scanner.scanString(string: "/*") != nil {
			let oldskipper = scanner.charactersToBeSkipped
			scanner.charactersToBeSkipped = CharacterSet()
			_ = scanner.scanUpToString("*/")
			_ = scanner.scanString(string: "*/")
			scanner.charactersToBeSkipped = oldskipper
			skipComments(scanner: scanner, line: line)
		}
	}
	
	private func scanOperators(scanner: Scanner, line: Int) -> Token? {
		for token in TokenMap.operatorMap(line: line).keys {
			let location = scanner.scanLocation
			if scanner.scanString(string: token) != nil {
				return TokenMap.operatorMap(line: line)[token]
			}
			else {
				scanner.scanLocation = location
			}
		}
		return .none
	}
	
	private func scanDecimalIntegerLiteral(scanner: Scanner, line: Int) -> Token? {
		let location = scanner.scanLocation
		
		guard let buffer = scanner.scanInteger() else {
			scanner.scanLocation = location
			return .none
		}
		
		return INTEGERLIT(line: line, value: buffer)
	}
	
	private func scanBooleanLiteral(scanner: Scanner, line: Int) -> Token? {
		let location = scanner.scanLocation
		if scanner.scanString(string: "true") != nil {
			return BOOLEANLIT(line: line, value: true)
		}
		else {
			scanner.scanLocation = location
		}
		
		if scanner.scanString(string: "false") == nil {
			scanner.scanLocation = location
			return .none
		}
		
		return BOOLEANLIT(line: line, value: false)
	}

	
	private func scanHexIntegerLiteral(scanner: Scanner, line: Int) -> Token? {
		let location = scanner.scanLocation
		
		if scanner.scanString(string: "0x") == nil {
			scanner.scanLocation = location
			return .none
		}
		
		guard let buffer = scanner.scanHexInt() else {
			scanner.scanLocation = location
			return .none
		}
		return INTEGERLIT(line: line, value: Int(buffer))
	}
	
	private func scanCharacterLiteral(scanner: Scanner, line: Int) -> Token? {
		let location = scanner.scanLocation
		
		if scanner.scanString(string: "'") == nil {
			scanner.scanLocation = location
			return .none
		}
		
		let oldskipper = scanner.charactersToBeSkipped
		scanner.charactersToBeSkipped = .none
		
		if scanner.scanString(string: "\u{5C}\u{27}") != nil {
			if scanner.scanString(string: "'") == nil {
				scanner.scanLocation = location
				return .none
			}
			return CHARACTERLIT(line: line, value: "\u{27}")
		}
		
		let buffer = scanner.scanUpToString("'")
		scanner.charactersToBeSkipped = oldskipper
		
		var s = buffer ?? "" as String
		s = s.replacingOccurrences(of: "\u{5C}n", with: "\u{A}")		// \n 
		s = s.replacingOccurrences(of: "\u{5C}r", with: "\u{D}")		// \r
		s = s.replacingOccurrences(of: "\u{5C}t", with: "\u{9}")		// \t
		s = s.replacingOccurrences(of: "\u{5C}\u{22}", with: "\u{22}")	// \"
		s = s.replacingOccurrences(of: "\u{5C}\u{5C}", with: "\u{5C}")	// \\
		
		if (s.characters.count != 1) {
			scanner.scanLocation = location
			return .none
		}
		
		if scanner.scanString(string: "'") == nil {
			scanner.scanLocation = location
			return .none
		}
		
		
		return CHARACTERLIT(line: line, value: s.characters.first!)
	}
	private func scanStringLiteral(scanner: Scanner, line: Int) -> Token? {
		let location = scanner.scanLocation
		
		if scanner.scanString(string: "\"") == nil {
			scanner.scanLocation = location
			return .none
		}
		
		let oldskipper = scanner.charactersToBeSkipped
		scanner.charactersToBeSkipped = .none
		let buffer = scanner.scanUpToString("\"")
		
		if scanner.scanString(string: "\"") == nil {
			scanner.scanLocation = location
			scanner.charactersToBeSkipped = oldskipper
			return .none
		}
		
		scanner.charactersToBeSkipped = oldskipper
		
		var buf: String = buffer ?? "" as String
		
		buf = buf.replacingOccurrences(of: "\\n", with: "\n")
		buf = buf.replacingOccurrences(of: "\\r", with: "\r")
		buf = buf.replacingOccurrences(of: "\\t", with: "\t")
		buf = buf.replacingOccurrences(of: "\\\u{22}", with: "\"")
		
		return STRINGLIT(line: line, value: buf)
	}
	
	private func scanIdentifier(scanner: Scanner, line: Int) -> Token? {
		let location = scanner.scanLocation
		
		guard let buffer = scanner.scanCharactersFromSet(CharacterSet.alphanumerics) else {
			scanner.scanLocation = location
			return .none
		}
        
        let s = buffer as String
		if let keyword = TokenMap.keywordMap(line: line)[s] {
            return keyword
        }
        else {
            return IDENT(line: line, value: s)
        }
	}
}
