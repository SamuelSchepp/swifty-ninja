//
//  FollowedBy.swift
//  SwiftyNinja
//
//  Created by Samuel Schepp on 25/03/2017.
//
//

import Foundation

public class FollowedBy<R1, R2> : Parser<(R1, R2)> {
	let first : Parser<R1>
	let second: Parser<R2>
	
	public init(first: Parser<R1>, second: Parser<R2>) {
		self.first = first
		self.second = second
	}
	
	public override func parse(string: String) -> ((R1, R2)?, String) {
		let res1 = first.parse(string: string)
		guard let result1 = res1.0 else {
			return (nil, string)
		}
		
		let res2 = second.parse(string: res1.1)
		guard let result2 = res2.0 else {
			return (nil, string)
		}
		
		return ((result1, result2), res2.1)
	}
}

public func ~>~ <R1, R2>(first: Parser<R1>, second: Parser<R2>) -> FollowedBy<R1, R2> {
	return FollowedBy(first: first, second: second)
}

infix operator ~>~: LeftAssociativity
