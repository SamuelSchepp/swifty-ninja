//
//  Objects.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 10/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

protocol Value: CustomStringConvertible { }

struct IntegerValue: Value {
	var value: Int
	
	var description: String {
		get {
			return "\(value)"
		}
	}
}

struct ReferenceValue: Value {
	let value: Int
	
	var description: String {
		get {
			if value == 0 {
				return "<Null>"
			}
			return "0x\(String(format: "%08x", value))"
		}
	}
	
	static func null() -> ReferenceValue {
		return ReferenceValue(value: 0)
	}
}

struct UninitializedValue: Value {
	var description: String {
		get {
			return "<Uninitialized>"
		}
	}
}

struct BooleanValue: Value {
	var value: Bool
	
	var description: String {
		get {
			return "\(value)"
		}
	}
}

struct CharacterValue: Value {
	var value: Character
	
	var description: String {
		get {
			return "\(value)"
		}
	}
}
