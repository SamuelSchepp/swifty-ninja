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
			return "\(value) <Integer>"
		}
	}
}

struct SizeValue: Value {
	var value: Int
	
	var description: String {
		get {
			return "\(value) <Size>"
		}
	}
}

struct ReferenceValue: Value {
	let value: Int
	
	var description: String {
		get {
			if value == 0 {
				return "<Null Reference>"
			}
			return "0x\(String(format: "%08x", value)) <Reference>"
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
			return "\(value) <Boolean>"
		}
	}
}

struct CharacterValue: Value {
	var value: Character
	
	var description: String {
		get {
			if isprint(Int32(UnicodeScalar(String(value))!.value)) > 0 {
				return "\(value) <Character>"
			}
			else {
				return "0x\(String(format: "%08x", UnicodeScalar(String(value))!.value)) <Character>"
			}
		}
	}
}
