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
	var value: Int
	
	var description: String {
		get {
			return "[Integer] \(value)"
		}
	}
	
}

struct BooleanObject: Object {
	var value: Bool
	
	var description: String {
		get {
			return "[Boolean] \(value)"
		}
	}
}

struct StringObject: Object {
	var value: String
	
	var description: String {
		get {
			return "[String] \(value)"
		}
	}
}

struct CharacterObject: Object {
	var value: Character
	
	var description: String {
		get {
			return "[Character] \(value)"
		}
	}
}

struct RecordObject: Object {
	let idents: [String: ReferenceObject]
	
	var description: String {
		get {
			return "[Record]"
		}
	}
}

struct ArrayObject: Object {
	let idents: [ReferenceObject]
	
	var description: String {
		get {
			return "[Record]"
		}
	}
}

struct ReferenceObject: Object {
	var value: UnsafePointer<Object>?
	
	var description: String {
		get {
			return "[Reference] \(value) -> \((value?.pointee.description ?? "NULL"))"
		}
	}
}
