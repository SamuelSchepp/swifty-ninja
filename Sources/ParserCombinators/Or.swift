//
//  Or.swift
//  SwiftyNinja
//
//  Created by Samuel Schepp on 25/03/2017.
//
//

import Foundation

infix operator ~|~: LeftAssociativity

public func ~|~ <R1, R2>(first: @escaping Parser<R1>, second: @escaping Parser<R2>) -> Parser<(R1?, R2?)> {
	return { string in
		let res1 = first(string)
		if let _ = res1.result {
			return ParseResult(result: (res1.result, Optional.none), remaining: res1.remaining)
		}
		
		let res2 = second(string)
		if let _ = res2.result {
			return ParseResult(result: (Optional.none, res2.result), remaining: res2.remaining)
		}
		
		return ParseResult(remaining: string)
	}
}
