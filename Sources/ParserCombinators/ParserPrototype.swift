//
//  ParserPrototype.swift
//  SwiftyNinja
//
//  Created by Samuel Schepp on 25/03/2017.
//
//

import Foundation

public typealias Parser<R> = (String) -> ParseResult<R>

extension Scanner {
	var remainingString: String {
		return self.string.substring(from: self.string.index(self.string.startIndex, offsetBy: self.scanLocation))
	}
}

extension String {
	public var p: Parser<String> {
		return StringParser(keyword: self)
	}
}

precedencegroup LeftAssociativity {
	associativity: left
}

public struct ParseResult<R> {
	public var result: R?
	public var remaining: String
	
	public init(result: R?, remaining: String) {
		self.result = result
		self.remaining = remaining
	}
	
	public init(remaining: String) {
		self.result = nil;
		self.remaining = remaining
	}
}
