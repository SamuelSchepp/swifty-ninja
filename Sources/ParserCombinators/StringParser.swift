//
//  StringParser.swift
//  SwiftyNinja
//
//  Created by Samuel Schepp on 25/03/2017.
//
//

import Foundation

public func StringParser(keyword : String) -> Parser<String> {
	return { string in
		var result: NSString?
		let scanner = Scanner(string: string)
		scanner.scanString(keyword, into: &result)
		
		guard let res = result as? String else {
			return ParseResult(remaining: string)
		}
		
		return ParseResult(result: res, remaining: scanner.remainingString)
	}
}
