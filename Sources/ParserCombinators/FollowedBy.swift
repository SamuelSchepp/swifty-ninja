//
//  FollowedBy.swift
//  SwiftyNinja
//
//  Created by Samuel Schepp on 25/03/2017.
//
//

import Foundation

public func ~~ <R1, R2>(first: @escaping Parser<R1>, second: @escaping Parser<R2>) -> Parser<(R1, R2)> {
	return { string in 
		let res1 = first(string)
		guard let result1 = res1.result else {
			return ParseResult(remaining: string)
		}
		
		let res2 = second(res1.remaining)
		guard let result2 = res2.result else {
			return ParseResult(remaining: string)
		}
		
		return ParseResult(result: (result1, result2), remaining: res2.remaining) 
	}
}

// First
public func ~<~ <R1, R2>(first: @escaping Parser<R1>, second: @escaping Parser<R2>) -> Parser<R1> {
	return { string in 
		let res1 = first(string)
		guard let result1 = res1.result else {
			return ParseResult(remaining: string)
		}
		
		let res2 = second(res1.remaining)
		guard let _ = res2.result else {
			return ParseResult(remaining: string)
		}
		
		return ParseResult(result: result1, remaining: res2.remaining) 
	}
}

// Second
public func ~>~ <R1, R2>(first: @escaping Parser<R1>, second: @escaping Parser<R2>) -> Parser<R2> {
	return { string in 
		let res1 = first(string)
		guard let _ = res1.result else {
			return ParseResult(remaining: string)
		}
		
		let res2 = second(res1.remaining)
		guard let result2 = res2.result else {
			return ParseResult(remaining: string)
		}
		
		return ParseResult(result: result2, remaining: res2.remaining) 
	}
}

infix operator ~~: LeftAssociativity
infix operator ~>~: LeftAssociativity
infix operator ~<~: LeftAssociativity
