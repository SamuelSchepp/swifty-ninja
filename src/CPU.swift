//
//  CPU.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 13/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

class CPU {
	let globalEnvironment: GlobalEnvironment
	
	init(globalEnvironment: GlobalEnvironment) {
		self.globalEnvironment = globalEnvironment
	}
	
    func isTrue(addr: ReferenceValue) throws -> Bool {
		if let value = try globalEnvironment.heap.get(addr: addr) as? BooleanValue {
			return value.value
		}
		else {
			throw REPLError.TypeMissmatch
		}
	}
	
	// MARK: Unary
	
    func unaryPlus(unaryRef: ReferenceValue) throws -> ReferenceValue {
		guard let unary = try globalEnvironment.heap.get(addr: unaryRef) as? IntegerValue else {
			throw REPLError.TypeMissmatch
		}
		
		let ref = try globalEnvironment.heap.malloc(size: 1)
		let value = IntegerValue(value: unary.value)
		try globalEnvironment.heap.set(value: value, addr: ref)
		return ref
	}
	
	func unaryMinus(unaryRef: ReferenceValue) throws -> ReferenceValue {
		guard let unary = try globalEnvironment.heap.get(addr: unaryRef) as? IntegerValue else {
			throw REPLError.TypeMissmatch
		}
		
		let ref = try globalEnvironment.heap.malloc(size: 1)
		let value = IntegerValue(value: -unary.value)
		try globalEnvironment.heap.set(value: value, addr: ref)
		return ref
	}
	
	func unaryLogNot(unaryRef: ReferenceValue) throws -> ReferenceValue {
		guard let unary = try globalEnvironment.heap.get(addr: unaryRef) as? BooleanValue else {
			throw REPLError.TypeMissmatch
		}
		
		let ref = try globalEnvironment.heap.malloc(size: 1)
		let value = BooleanValue(value: !unary.value)
		try globalEnvironment.heap.set(value: value, addr: ref)
		return ref
	}
	
	// MARK: Binary
	
    func binaryMul(leftRef: ReferenceValue, rightRef: ReferenceValue) throws -> ReferenceValue {
		guard let left = try globalEnvironment.heap.get(addr: leftRef) as? IntegerValue else {
			throw REPLError.TypeMissmatch
		}
		guard let right = try globalEnvironment.heap.get(addr: rightRef) as? IntegerValue else {
			throw REPLError.TypeMissmatch
		}
		
		let ref = try globalEnvironment.heap.malloc(size: 1)
		let value = IntegerValue(value: left.value * right.value)
		try globalEnvironment.heap.set(value: value, addr: ref)
		return ref
	}
	
	func binaryDiv(leftRef: ReferenceValue, rightRef: ReferenceValue) throws -> ReferenceValue {
		guard let left = try globalEnvironment.heap.get(addr: leftRef) as? IntegerValue else {
			throw REPLError.TypeMissmatch
		}
		guard let right = try globalEnvironment.heap.get(addr: rightRef) as? IntegerValue else {
			throw REPLError.TypeMissmatch
		}
		
		let ref = try globalEnvironment.heap.malloc(size: 1)
		let value = IntegerValue(value: left.value / right.value)
		try globalEnvironment.heap.set(value: value, addr: ref)
		return ref
	}
	
	func binaryMod(leftRef: ReferenceValue, rightRef: ReferenceValue) throws -> ReferenceValue {
		guard let left = try globalEnvironment.heap.get(addr: leftRef) as? IntegerValue else {
			throw REPLError.TypeMissmatch
		}
		guard let right = try globalEnvironment.heap.get(addr: rightRef) as? IntegerValue else {
			throw REPLError.TypeMissmatch
		}
		
		let ref = try globalEnvironment.heap.malloc(size: 1)
		let value = IntegerValue(value: left.value % right.value)
		try globalEnvironment.heap.set(value: value, addr: ref)
		return ref
	}
	
	func binaryPlus(leftRef: ReferenceValue, rightRef: ReferenceValue) throws -> ReferenceValue {
		guard let left = try globalEnvironment.heap.get(addr: leftRef) as? IntegerValue else {
			throw REPLError.TypeMissmatch
		}
		guard let right = try globalEnvironment.heap.get(addr: rightRef) as? IntegerValue else {
			throw REPLError.TypeMissmatch
		}
		
		let ref = try globalEnvironment.heap.malloc(size: 1)
		let value = IntegerValue(value: left.value + right.value)
		try globalEnvironment.heap.set(value: value, addr: ref)
		return ref
	}
	
	func binaryMinus(leftRef: ReferenceValue, rightRef: ReferenceValue) throws -> ReferenceValue {
		guard let left = try globalEnvironment.heap.get(addr: leftRef) as? IntegerValue else {
			throw REPLError.TypeMissmatch
		}
		guard let right = try globalEnvironment.heap.get(addr: rightRef) as? IntegerValue else {
			throw REPLError.TypeMissmatch
		}
		
		let ref = try globalEnvironment.heap.malloc(size: 1)
		let value = IntegerValue(value: left.value - right.value)
		try globalEnvironment.heap.set(value: value, addr: ref)
		return ref
	}
	
	// MARJK: Rel
	
	func relEQ(leftRef: ReferenceValue, rightRef: ReferenceValue) throws -> ReferenceValue {
		do {
			/* Compare Integer */
			guard let left = try globalEnvironment.heap.get(addr: leftRef) as? IntegerValue else {
				throw REPLError.TypeMissmatch
			}
			guard let right = try globalEnvironment.heap.get(addr: rightRef) as? IntegerValue else {
				throw REPLError.TypeMissmatch
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
					throw REPLError.TypeMissmatch
				}
				guard let right = try globalEnvironment.heap.get(addr: rightRef) as? CharacterValue else {
					throw REPLError.TypeMissmatch
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
	
	func relNE(leftRef: ReferenceValue, rightRef: ReferenceValue) throws -> ReferenceValue {
		do {
			/* Compare Integer */
			guard let left = try globalEnvironment.heap.get(addr: leftRef) as? IntegerValue else {
				throw REPLError.TypeMissmatch
			}
			guard let right = try globalEnvironment.heap.get(addr: rightRef) as? IntegerValue else {
				throw REPLError.TypeMissmatch
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
					throw REPLError.TypeMissmatch
				}
				guard let right = try globalEnvironment.heap.get(addr: rightRef) as? CharacterValue else {
					throw REPLError.TypeMissmatch
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
	
	func relGT(leftRef: ReferenceValue, rightRef: ReferenceValue) throws -> ReferenceValue {
		guard let left = try globalEnvironment.heap.get(addr: leftRef) as? IntegerValue else {
			throw REPLError.TypeMissmatch
		}
		guard let right = try globalEnvironment.heap.get(addr: rightRef) as? IntegerValue else {
			throw REPLError.TypeMissmatch
		}
		
		let ref = try globalEnvironment.heap.malloc(size: 1)
		let value = BooleanValue(value: left.value > right.value)
		try globalEnvironment.heap.set(value: value, addr: ref)
		return ref
	}
	
	func relGE(leftRef: ReferenceValue, rightRef: ReferenceValue) throws -> ReferenceValue {
		guard let left = try globalEnvironment.heap.get(addr: leftRef) as? IntegerValue else {
			throw REPLError.TypeMissmatch
		}
		guard let right = try globalEnvironment.heap.get(addr: rightRef) as? IntegerValue else {
			throw REPLError.TypeMissmatch
		}
		
		let ref = try globalEnvironment.heap.malloc(size: 1)
		let value = BooleanValue(value: left.value >= right.value)
		try globalEnvironment.heap.set(value: value, addr: ref)
		return ref
	}
	
	func relLT(leftRef: ReferenceValue, rightRef: ReferenceValue) throws -> ReferenceValue {
		guard let left = try globalEnvironment.heap.get(addr: leftRef) as? IntegerValue else {
			throw REPLError.TypeMissmatch
		}
		guard let right = try globalEnvironment.heap.get(addr: rightRef) as? IntegerValue else {
			throw REPLError.TypeMissmatch
		}
		
		let ref = try globalEnvironment.heap.malloc(size: 1)
		let value = BooleanValue(value: left.value < right.value)
		try globalEnvironment.heap.set(value: value, addr: ref)
		return ref
	}
	
	func relLE(leftRef: ReferenceValue, rightRef: ReferenceValue) throws -> ReferenceValue {
		guard let left = try globalEnvironment.heap.get(addr: leftRef) as? IntegerValue else {
			throw REPLError.TypeMissmatch
		}
		guard let right = try globalEnvironment.heap.get(addr: rightRef) as? IntegerValue else {
			throw REPLError.TypeMissmatch
		}
		
		let ref = try globalEnvironment.heap.malloc(size: 1)
		let value = BooleanValue(value: left.value <= right.value)
		try globalEnvironment.heap.set(value: value, addr: ref)
		return ref
	}
	
	// MARK: Boolean
	
	func booleanAnd(leftRef: ReferenceValue, rightRef: ReferenceValue) throws -> ReferenceValue {
		guard let left = try globalEnvironment.heap.get(addr: leftRef) as? BooleanValue else {
			throw REPLError.TypeMissmatch
		}
		guard let right = try globalEnvironment.heap.get(addr: rightRef) as? BooleanValue else {
			throw REPLError.TypeMissmatch
		}
		
		let ref = try globalEnvironment.heap.malloc(size: 1)
		let value = BooleanValue(value: left.value && right.value)
		try globalEnvironment.heap.set(value: value, addr: ref)
		return ref
	}
	
	func booleanOr(leftRef: ReferenceValue, rightRef: ReferenceValue) throws -> ReferenceValue {
		guard let left = try globalEnvironment.heap.get(addr: leftRef) as? BooleanValue else {
			throw REPLError.TypeMissmatch
		}
		guard let right = try globalEnvironment.heap.get(addr: rightRef) as? BooleanValue else {
			throw REPLError.TypeMissmatch
		}
		
        let ref = try globalEnvironment.heap.malloc(size: 1)
		let value = BooleanValue(value: left.value || right.value)
        try globalEnvironment.heap.set(value: value, addr: ref)
		return ref
	}
}
