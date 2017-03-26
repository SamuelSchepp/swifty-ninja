//
//  OptionalParser.swift
//  SwiftyNinja
//
//  Created by Samuel Schepp on 25/03/2017.
//
//

import Foundation

prefix operator ?~

public prefix func ?~ <R>(parser: @escaping Parser<R>) -> Parser<R?> {
	return { string in
		let parseResult = parser(string)
		guard let res = parseResult.result else {
			return ParseResult(result: Optional(Optional.none), remaining: string)
		}
		
		return ParseResult(result: Optional(Optional<R>(res)), remaining: parseResult.remaining)
	}
}
