//
//  OptionalParser.swift
//  SwiftyNinja
//
//  Created by Samuel Schepp on 25/03/2017.
//
//

import Foundation

public class OptionalParser<R>: Parser<R?> {
	let parentParser: Parser<R>
	
	public init(parent: Parser<R>) {
		self.parentParser = parent
	}
	
	public override func parse(string: String) -> (R??, String) {
		let parseResult = parentParser.parse(string: string)
		guard let res = parseResult.0 else {
			return (Optional(Optional.none), string)
		}
		
		return (Optional(Optional<R>(res)), parseResult.1)
	}
}

prefix operator ?~

public prefix func ?~ <R>(parser: Parser<R>) -> OptionalParser<R> {
	return OptionalParser(parent: parser)
}
