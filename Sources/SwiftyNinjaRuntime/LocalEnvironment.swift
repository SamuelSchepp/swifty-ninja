//
//  LocalEnvironment.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 11/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

public class LocalEnvironment {
	public var varTypeMap: [String: Type]
	public var variables: [String: ReferenceValue]
	public var identifier: String
	
	public init(ident: String) {
		varTypeMap = [:]
		variables = [:]
		identifier = ident
	}
	
	public func identifierExists(ident: String) -> Bool {
		return varTypeMap.keys.contains(ident) ||
			variables.keys.contains(ident)
	}
	
	public func dump() {
		print("==== Stack Slot Start \"\(identifier)\" ====")
		let width = 20
		print("==== Local Variable Types ====")
		varTypeMap.forEach { (arg) in
			
			let (key, value) = arg
			let left = String.padding("\"\(key)\":")(toLength: width, withPad: " ", startingAt: 0)
			print("\(left)\(value)")
		}
		print()
		print("==== Local Variables ====")
		variables.forEach { (arg) in
			
			let (key, value) = arg
			let left = String.padding("\"\(key)\":")(toLength: width, withPad: " ", startingAt: 0)
			print("\(left)\(value)")
		}
		print("==== Stack Slot End ====")
		print()
	}
}
