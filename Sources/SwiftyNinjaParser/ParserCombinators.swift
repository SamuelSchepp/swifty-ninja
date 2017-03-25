//
//  ParserCombinators.swift
//  SwiftyNinja
//
//  Created by Samuel Schepp on 25/03/2017.
//
//

import Foundation

public class FollowedBy<T1: Parser, T2: Parser> : Parser {
	let first : T1
	let second: T2
	
	public init(first:T1, second:T2) {
		self.first = first
		self.second = second
	}
	
	typealias R1 = T1.Target
	typealias R2 = T2.Target
	
	public func parse(string: String) -> ((R1, R2)?, String) {
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

public class MappedParser<P1: Parser, R>: Parser {
	public typealias Target = R
	
	typealias R1 = P1.Target
	
	let parentParser: P1
	let mapFunction: (R1) -> Target
	
	public init(parent: P1, mapFunction: @escaping (R1) -> Target) {
		self.mapFunction = mapFunction
		self.parentParser = parent
	}
	
	public func parse(string: String) -> (R?, String) {
		let parseResult = parentParser.parse(string: string)
		guard let res = parseResult.0 else {
			return (nil, string)
		}
		
		return (mapFunction(res), parseResult.1)
	}
}

public class OptionalParser<P1: Parser>: Parser {
	public typealias Target = P1.Target?
	
	let parentParser: P1
	
	public init(parent: P1) {
		self.parentParser = parent
	}
	
	public func parse(string: String) -> (Target?, String) {
		let parseResult = parentParser.parse(string: string)
		guard let res = parseResult.0 else {
			return (Optional<Target>(Optional<P1.Target>.none), string)
		}
		
		return (Optional<Target>(Optional<P1.Target>(res)), parseResult.1)
	}
}

precedencegroup LeftAssociativity {
	associativity: left
}

infix operator ~>~: LeftAssociativity
public func ~>~ <T1: Parser, T2: Parser>(first: T1, second: T2) -> FollowedBy<T1,T2> {
	return FollowedBy(first: first, second: second)
}

infix operator ^^: LeftAssociativity
public func ^^ <P: Parser, R>(parser: P, function: @escaping (P.Target) -> R) -> MappedParser<P, R> {
	return MappedParser(parent: parser, mapFunction: function)
}

prefix operator ?~
public prefix func ?~ <P: Parser>(parser: P) -> OptionalParser<P> {
	return OptionalParser(parent: parser)
}
