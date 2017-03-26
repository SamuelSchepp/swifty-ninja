//
//  Or.swift
//  SwiftyNinja
//
//  Created by Samuel Schepp on 25/03/2017.
//
//

import Foundation

public class Or<T> : Parser<T> {
	let first : Parser<T>
	let second: Parser<T>
	
	public typealias Target = T
	
	public init(first: Parser<T>, second: Parser<T>) {
		self.first = first
		self.second = second
	}
	
	public override func parse(string: String) -> (T?, String) {
		let res1 = first.parse(string: string)
		if let _ = res1.0 {
			return res1
		}
		else {
			return second.parse(string: res1.1)
		}
	}
}

infix operator ~|~: LeftAssociativity

public func ~|~ <R>(first: Parser<R>, second: Parser<R>) -> Or<R>{
	return Or(first: first, second: second)
}
