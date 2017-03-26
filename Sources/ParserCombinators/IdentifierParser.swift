//
//  IdentifierParser.swift
//  SwiftyNinja
//
//  Created by Samuel Schepp on 25/03/2017.
//
//

import Foundation

public let IdentifierParser: () -> Parser<String> = { keyword in
	return { string in
		var result: NSString?
		let scanner = Scanner(string: string)
		scanner.scanCharacters(from: CharacterSet.alphanumerics, into: &result)
		
		guard let res = result as? String else {
			return ParseResult(remaining: string)
		}
		
		return ParseResult(result: res, remaining: scanner.remainingString)
	}
}
