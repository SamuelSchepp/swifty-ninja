//
//  Objects.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 10/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

protocol ObjectWrapper { }

protocol Object: CustomStringConvertible, ObjectWrapper { }

struct IntegerObject: Object {
	let value: Int
	
	var description: String {
		get {
			return "[Integer] \(value)"
		}
	}
	
}

struct BooleanObject: Object {
	let value: Bool
	
	var description: String {
		get {
			return "[Boolean] \(value)"
		}
	}
}

struct StringObject: Object {
	let value: String
	
	var description: String {
		get {
			return "[String] \(value)"
		}
	}
}

struct CharacterObject: Object {
	let value: Character
	
	var description: String {
		get {
			return "[Character] \(value)"
		}
	}
}

struct ReferenceObject: Object {
	let value: Object?
	
	var description: String {
		get {
			return "[Reference] \(value)"
		}
	}
}
