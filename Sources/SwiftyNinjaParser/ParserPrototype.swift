//
//  ParserPrototype.swift
//  SwiftyNinja
//
//  Created by Samuel Schepp on 25/03/2017.
//
//

import Foundation

public class Parser<R> {
	func parse(string: String) -> (R?, String) {
		return (nil, string)
	}
}

extension Scanner {
	var remainingString: String {
		return self.string.substring(from: self.string.index(self.string.startIndex, offsetBy: self.scanLocation))
	}
}

extension String {
	public var p: StringParser {
		return StringParser(keyword: self)
	}
}

precedencegroup LeftAssociativity {
	associativity: left
}
