//
//  Objects.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 10/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

public protocol Value: CustomStringConvertible { }

public struct IntegerValue: Value {
	public var value: Int
	
	public init(value: Int) {
		self.value = value
	}
	
	public var description: String {
		get {
			return "\(value) <Integer>"
		}
	}
}

public struct SizeValue: Value {
	public var value: Int
	
	public init(value: Int) {
		self.value = value
	}
	
	public var description: String {
		get {
			return "\(value) <Size>"
		}
	}
}

public struct ReferenceValue: Value {
	public let value: Int
	
	public init(value: Int) {
		self.value = value
	}
	
	public var description: String {
		get {
			if value == 0 {
				return "<Null Reference>"
			}
			return "0x\(String(format: "%08x", value)) <Reference>"
		}
	}
	
	public static func null() -> ReferenceValue {
		return ReferenceValue(value: 0)
	}
}

public struct UninitializedValue: Value {
	public var description: String {
		get {
			return "<Uninitialized>"
		}
	}
}

public struct BooleanValue: Value {
	public var value: Bool
	
	public init(value: Bool) {
		self.value = value
	}
	
	public var description: String {
		get {
			return "\(value) <Boolean>"
		}
	}
}

public struct CharacterValue: Value {
	public var value: Character
	
	public init(value: Character) {
		self.value = value
	}
	
	public var description: String {
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
