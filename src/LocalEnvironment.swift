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
	
	init() {
		varTypeMap = [:]
		variables = [:]
	}
	
	func identifierExists(ident: String) -> Bool {
		return varTypeMap.keys.contains(ident) ||
			variables.keys.contains(ident)
	}
}
