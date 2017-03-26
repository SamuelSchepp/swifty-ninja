//
//  IntegerParser.swift
//  SwiftyNinja
//
//  Created by Samuel Schepp on 26/03/2017.
//
//

import Foundation

public func IntegerParser() -> Parser<Int> { 
	return { string in
		var result: Int = 0
		let scanner = Scanner(string: string)
		
		if !scanner.scanInt(&result) {
			return ParseResult(remaining: string)
		}
		else {
			return ParseResult(result: result, remaining: scanner.remainingString)
		}
	}
}
