//
//  MappedParser.swift
//  SwiftyNinja
//
//  Created by Samuel Schepp on 25/03/2017.
//
//

import Foundation

public class MappedParser<R, M>: Parser<M> {
	
	let parentParser: Parser<R>
	let mapFunction: (R) -> M
	
	public init(parent: Parser<R>, mapFunction: @escaping (R) -> M) {
		self.mapFunction = mapFunction
		self.parentParser = parent
	}
	
	public override func parse(string: String) -> (M?, String) {
		let parseResult = parentParser.parse(string: string)
		guard let res = parseResult.0 else {
			return (nil, string)
		}
		
		return (mapFunction(res), parseResult.1)
	}
}

public func ^^ <R, M>(parser: Parser<R>, function: @escaping (R) -> M) -> MappedParser<R, M> {
	return MappedParser(parent: parser, mapFunction: function)
}

infix operator ^^: LeftAssociativity
