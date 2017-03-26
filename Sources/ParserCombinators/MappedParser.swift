//
//  MappedParser.swift
//  SwiftyNinja
//
//  Created by Samuel Schepp on 25/03/2017.
//
//

import Foundation

public func ^^ <R, M>(parser: @escaping Parser<R>, function: @escaping (R) -> M) -> Parser<M> {
	return { string in
		let parseResult = parser(string)
		guard let res = parseResult.result else {
			return ParseResult(remaining: string)
		}
		
		return ParseResult(result: function(res), remaining: parseResult.remaining)
	}
}

infix operator ^^: LeftAssociativity
