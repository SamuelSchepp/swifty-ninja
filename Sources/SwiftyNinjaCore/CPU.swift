//
//  CPU.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 13/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

public class CPU {
	public let globalEnvironment: GlobalEnvironment
	
	public init(globalEnvironment: GlobalEnvironment) {
		self.globalEnvironment = globalEnvironment
	}
	
    public func isTrue(addr: ReferenceValue) throws -> Bool {
		if let value = try globalEnvironment.heap.get(addr: addr) as? BooleanValue {
			return value.value
		}
		else {
			throw REPLError.TypeMissmatch(expected: "BooleanValue", context: "isTrue")
		}
	}
	
	// MARK: Unary
	
    public func unaryPlus(unaryRef: ReferenceValue) throws -> ReferenceValue {
		guard let unary = try globalEnvironment.heap.get(addr: unaryRef) as? IntegerValue else {
			throw REPLError.TypeMissmatch(expected: "IntegerValue", context: "unaryPlus")
		}
		
		let ref = try globalEnvironment.heap.malloc(size: 1)
		let value = IntegerValue(value: unary.value)
		try globalEnvironment.heap.set(value: value, addr: ref)
		return ref
	}
	
	public func unaryMinus(unaryRef: ReferenceValue) throws -> ReferenceValue {
		guard let unary = try globalEnvironment.heap.get(addr: unaryRef) as? IntegerValue else {
			throw REPLError.TypeMissmatch(expected: "IntegerValue", context: "unaryMinus")
		}
		
		let ref = try globalEnvironment.heap.malloc(size: 1)
		let value = IntegerValue(value: -unary.value)
		try globalEnvironment.heap.set(value: value, addr: ref)
		return ref
	}
	
	public func unaryLogNot(unaryRef: ReferenceValue) throws -> ReferenceValue {
		guard let unary = try globalEnvironment.heap.get(addr: unaryRef) as? BooleanValue else {
			throw REPLError.TypeMissmatch(expected: "BooleanValue", context: "unaryLogNot")
		}
		
		let ref = try globalEnvironment.heap.malloc(size: 1)
		let value = BooleanValue(value: !unary.value)
		try globalEnvironment.heap.set(value: value, addr: ref)
		return ref
	}
	
	// MARK: Binary
	
    public func binaryMul(leftRef: ReferenceValue, rightRef: ReferenceValue) throws -> ReferenceValue {
		guard let left = try globalEnvironment.heap.get(addr: leftRef) as? IntegerValue else {
			throw REPLError.TypeMissmatch(expected: "IntegerValue", context: "binaryMul")
		}
		guard let right = try globalEnvironment.heap.get(addr: rightRef) as? IntegerValue else {
			throw REPLError.TypeMissmatch(expected: "IntegerValue", context: "binaryMul")
		}
		
		let ref = try globalEnvironment.heap.malloc(size: 1)
		let value = IntegerValue(value: left.value * right.value)
		try globalEnvironment.heap.set(value: value, addr: ref)
		return ref
	}
	
	public func binaryDiv(leftRef: ReferenceValue, rightRef: ReferenceValue) throws -> ReferenceValue {
		guard let left = try globalEnvironment.heap.get(addr: leftRef) as? IntegerValue else {
			throw REPLError.TypeMissmatch(expected: "IntegerValue", context: "binaryDiv")
		}
		guard let right = try globalEnvironment.heap.get(addr: rightRef) as? IntegerValue else {
			throw REPLError.TypeMissmatch(expected: "IntegerValue", context: "binaryDiv")
		}
		
		let ref = try globalEnvironment.heap.malloc(size: 1)
		let value = IntegerValue(value: left.value / right.value)
		try globalEnvironment.heap.set(value: value, addr: ref)
		return ref
	}
	
	public func binaryMod(leftRef: ReferenceValue, rightRef: ReferenceValue) throws -> ReferenceValue {
		guard let left = try globalEnvironment.heap.get(addr: leftRef) as? IntegerValue else {
			throw REPLError.TypeMissmatch(expected: "IntegerValue", context: "binaryMod")
		}
		guard let right = try globalEnvironment.heap.get(addr: rightRef) as? IntegerValue else {
			throw REPLError.TypeMissmatch(expected: "IntegerValue", context: "binaryMod")
		}
		
		let ref = try globalEnvironment.heap.malloc(size: 1)
		let value = IntegerValue(value: left.value % right.value)
		try globalEnvironment.heap.set(value: value, addr: ref)
		return ref
	}
	
	public func binaryPlus(leftRef: ReferenceValue, rightRef: ReferenceValue) throws -> ReferenceValue {
		guard let left = try globalEnvironment.heap.get(addr: leftRef) as? IntegerValue else {
			throw REPLError.TypeMissmatch(expected: "IntegerValue", context: "binaryPlus")
		}
		guard let right = try globalEnvironment.heap.get(addr: rightRef) as? IntegerValue else {
			throw REPLError.TypeMissmatch(expected: "IntegerValue", context: "binaryPlus")
		}
		
		let ref = try globalEnvironment.heap.malloc(size: 1)
		let value = IntegerValue(value: left.value + right.value)
		try globalEnvironment.heap.set(value: value, addr: ref)
		return ref
	}
	
	public func binaryMinus(leftRef: ReferenceValue, rightRef: ReferenceValue) throws -> ReferenceValue {
		guard let left = try globalEnvironment.heap.get(addr: leftRef) as? IntegerValue else {
			throw REPLError.TypeMissmatch(expected: "IntegerValue", context: "binaryMinus")
		}
		guard let right = try globalEnvironment.heap.get(addr: rightRef) as? IntegerValue else {
			throw REPLError.TypeMissmatch(expected: "IntegerValue", context: "binaryMinus")
		}
		
		let ref = try globalEnvironment.heap.malloc(size: 1)
		let value = IntegerValue(value: left.value - right.value)
		try globalEnvironment.heap.set(value: value, addr: ref)
		return ref
	}
	
	// MARJK: Rel
	
	public func relEQ(leftRef: ReferenceValue, rightRef: ReferenceValue) throws -> ReferenceValue {
		do {
			/* Compare Integer */
			guard let left = try globalEnvironment.heap.get(addr: leftRef) as? IntegerValue else {
				throw REPLError.TypeMissmatch(expected: "IntegerValue", context: "relEQ")
			}
			guard let right = try globalEnvironment.heap.get(addr: rightRef) as? IntegerValue else {
				throw REPLError.TypeMissmatch(expected: "IntegerValue", context: "relEQ")
			}
			
			let ref = try globalEnvironment.heap.malloc(size: 1)
			let value = BooleanValue(value: left.value == right.value)
			try globalEnvironment.heap.set(value: value, addr: ref)
			return ref
		}
		catch _ {
			do {
				/* Compare Character */
				guard let left = try globalEnvironment.heap.get(addr: leftRef) as? CharacterValue else {
					throw REPLError.TypeMissmatch(expected: "CharacterValue", context: "relEQ")
				}
				guard let right = try globalEnvironment.heap.get(addr: rightRef) as? CharacterValue else {
					throw REPLError.TypeMissmatch(expected: "CharacterValue", context: "relEQ")
				}
				
				let ref = try self.globalEnvironment.heap.malloc(size: 1)
				let value = BooleanValue(value: left.value == right.value)
				try globalEnvironment.heap.set(value: value, addr: ref)
				return ref
			}
			catch _ {
				/* Compare Reference */
				let ref = try self.globalEnvironment.heap.malloc(size: 1)
				let value = BooleanValue(value: leftRef.value == rightRef.value)
				try globalEnvironment.heap.set(value: value, addr: ref)
				return ref
			}
		}
	}
	
	public func relNE(leftRef: ReferenceValue, rightRef: ReferenceValue) throws -> ReferenceValue {
		do {
			/* Compare Integer */
			guard let left = try globalEnvironment.heap.get(addr: leftRef) as? IntegerValue else {
				throw REPLError.TypeMissmatch(expected: "IntegerValue", context: "relNE")
			}
			guard let right = try globalEnvironment.heap.get(addr: rightRef) as? IntegerValue else {
				throw REPLError.TypeMissmatch(expected: "IntegerValue", context: "relNE")
			}
			
			let ref = try globalEnvironment.heap.malloc(size: 1)
			let value = BooleanValue(value: left.value != right.value)
			try globalEnvironment.heap.set(value: value, addr: ref)
			return ref
		}
		catch _ {
			do {
				/* Compare Character */
				guard let left = try globalEnvironment.heap.get(addr: leftRef) as? CharacterValue else {
					throw REPLError.TypeMissmatch(expected: "CharacterValue", context: "relNE")
				}
				guard let right = try globalEnvironment.heap.get(addr: rightRef) as? CharacterValue else {
					throw REPLError.TypeMissmatch(expected: "CharacterValue", context: "relNE")
				}
				
				let ref = try self.globalEnvironment.heap.malloc(size: 1)
				let value = BooleanValue(value: left.value != right.value)
				try globalEnvironment.heap.set(value: value, addr: ref)
				return ref
			}
			catch _ {
				/* Compare Reference */
				let ref = try self.globalEnvironment.heap.malloc(size: 1)
				let value = BooleanValue(value: leftRef.value != rightRef.value)
				try globalEnvironment.heap.set(value: value, addr: ref)
				return ref
			}
		}
	}
	
	public func relGT(leftRef: ReferenceValue, rightRef: ReferenceValue) throws -> ReferenceValue {
		guard let left = try globalEnvironment.heap.get(addr: leftRef) as? IntegerValue else {
			throw REPLError.TypeMissmatch(expected: "IntegerValue", context: "relGT")
		}
		guard let right = try globalEnvironment.heap.get(addr: rightRef) as? IntegerValue else {
			throw REPLError.TypeMissmatch(expected: "IntegerValue", context: "relGT")
		}
		
		let ref = try globalEnvironment.heap.malloc(size: 1)
		let value = BooleanValue(value: left.value > right.value)
		try globalEnvironment.heap.set(value: value, addr: ref)
		return ref
	}
	
	public func relGE(leftRef: ReferenceValue, rightRef: ReferenceValue) throws -> ReferenceValue {
		guard let left = try globalEnvironment.heap.get(addr: leftRef) as? IntegerValue else {
			throw REPLError.TypeMissmatch(expected: "IntegerValue", context: "relGE")
		}
		guard let right = try globalEnvironment.heap.get(addr: rightRef) as? IntegerValue else {
			throw REPLError.TypeMissmatch(expected: "IntegerValue", context: "relGE")
		}
		
		let ref = try globalEnvironment.heap.malloc(size: 1)
		let value = BooleanValue(value: left.value >= right.value)
		try globalEnvironment.heap.set(value: value, addr: ref)
		return ref
	}
	
	public func relLT(leftRef: ReferenceValue, rightRef: ReferenceValue) throws -> ReferenceValue {
		guard let left = try globalEnvironment.heap.get(addr: leftRef) as? IntegerValue else {
			throw REPLError.TypeMissmatch(expected: "IntegerValue", context: "relLT")
		}
		guard let right = try globalEnvironment.heap.get(addr: rightRef) as? IntegerValue else {
			throw REPLError.TypeMissmatch(expected: "IntegerValue", context: "relLT")
		}
		
		let ref = try globalEnvironment.heap.malloc(size: 1)
		let value = BooleanValue(value: left.value < right.value)
		try globalEnvironment.heap.set(value: value, addr: ref)
		return ref
	}
	
	public func relLE(leftRef: ReferenceValue, rightRef: ReferenceValue) throws -> ReferenceValue {
		guard let left = try globalEnvironment.heap.get(addr: leftRef) as? IntegerValue else {
			throw REPLError.TypeMissmatch(expected: "IntegerValue", context: "relLE")
		}
		guard let right = try globalEnvironment.heap.get(addr: rightRef) as? IntegerValue else {
			throw REPLError.TypeMissmatch(expected: "IntegerValue", context: "relLE")
		}
		
		let ref = try globalEnvironment.heap.malloc(size: 1)
		let value = BooleanValue(value: left.value <= right.value)
		try globalEnvironment.heap.set(value: value, addr: ref)
		return ref
	}
}
