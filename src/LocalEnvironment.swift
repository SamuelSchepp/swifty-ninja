//
//  LocalEnvironment.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 11/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

class LocalEnvironment {
	var varTypeMap: [String: Type]
	var variables: [String: ReferenceValue]
	var identifier: String
	
	init(ident: String) {
		varTypeMap = [:]
		variables = [:]
		identifier = ident
	}
	
	func identifierExists(ident: String) -> Bool {
		return varTypeMap.keys.contains(ident) ||
			variables.keys.contains(ident)
	}
	
	func dump() {
		print("==== Stack Slot Start \"\(identifier)\" ====")
		let width = 20
		print("==== Local Variable Types ====")
		varTypeMap.forEach { key, value in
			let left = String.padding("\"\(key)\":")(toLength: width, withPad: " ", startingAt: 0)
			print("\(left)\(value)")
		}
		print()
		print("==== Local Variables ====")
		variables.forEach { key, value in
			let left = String.padding("\"\(key)\":")(toLength: width, withPad: " ", startingAt: 0)
			print("\(left)\(value)")
		}
		print("==== Stack Slot End ====")
		print()
	}
}
