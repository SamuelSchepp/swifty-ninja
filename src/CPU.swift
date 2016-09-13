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
	
	var lhsRegister: ReferenceValue
	var rhsRegister: ReferenceValue
	var unaryRegister: ReferenceValue
	var resultRegister: ReferenceValue
	
	init(globalEnvironment: GlobalEnvironment) {
		self.globalEnvironment = globalEnvironment
		lhsRegister = ReferenceValue.null()
		rhsRegister = ReferenceValue.null()
		unaryRegister = ReferenceValue.null()
		resultRegister = ReferenceValue.null()
	}
	
	func error() {
		print("<cpu_error>")
	}
	
	func isTrue() -> Bool {
		guard let rhsVal = globalEnvironment.heapGet(addr: unaryRegister) as? BooleanValue else { error(); return false }
		return rhsVal.value
	}
	
	// MARK: Unary
	
	func unaryPlus() {
		guard let rhsVal = globalEnvironment.heapGet(addr: unaryRegister) as? IntegerValue else { error(); return }
		let res = IntegerValue(value: rhsVal.value)
		let newRef = globalEnvironment.malloc(size: 1)
		globalEnvironment.heapSet(value: res, addr: newRef)
		
		resultRegister = newRef
	}
	
	func unaryMinus() {
		guard let rhsVal = globalEnvironment.heapGet(addr: unaryRegister) as? IntegerValue else { error(); return }
		let res = IntegerValue(value: -rhsVal.value)
		let newRef = globalEnvironment.malloc(size: 1)
		globalEnvironment.heapSet(value: res, addr: newRef)
		
		resultRegister = newRef
	}
	
	func unaryLogNot() {
		guard let rhsVal = globalEnvironment.heapGet(addr: unaryRegister) as? BooleanValue else { error(); return }
		let res = BooleanValue(value: !rhsVal.value)
		let newRef = globalEnvironment.malloc(size: 1)
		globalEnvironment.heapSet(value: res, addr: newRef)
		
		resultRegister = newRef
	}
	
	// MARK: Binary
	
	func binaryMul() {
		guard let rhsVal = globalEnvironment.heapGet(addr: rhsRegister) as? IntegerValue else { error(); return }
		guard let lhsVal = globalEnvironment.heapGet(addr: lhsRegister) as? IntegerValue else { error(); return }
		
		let res = IntegerValue(value: lhsVal.value * rhsVal.value)
		
		let newRef = globalEnvironment.malloc(size: 1)
		globalEnvironment.heapSet(value: res, addr: newRef)
		resultRegister = newRef
	}
	
	func binaryDiv() {
		guard let rhsVal = globalEnvironment.heapGet(addr: rhsRegister) as? IntegerValue else { error(); return }
		guard let lhsVal = globalEnvironment.heapGet(addr: lhsRegister) as? IntegerValue else { error(); return }
		
		let res = IntegerValue(value: lhsVal.value / rhsVal.value)
		
		let newRef = globalEnvironment.malloc(size: 1)
		globalEnvironment.heapSet(value: res, addr: newRef)
		resultRegister = newRef
	}
	
	func binaryMod() {
		guard let rhsVal = globalEnvironment.heapGet(addr: rhsRegister) as? IntegerValue else { error(); return }
		guard let lhsVal = globalEnvironment.heapGet(addr: lhsRegister) as? IntegerValue else { error(); return }
		
		let res = IntegerValue(value: lhsVal.value % rhsVal.value)
		
		let newRef = globalEnvironment.malloc(size: 1)
		globalEnvironment.heapSet(value: res, addr: newRef)
		resultRegister = newRef
	}
	
	func binaryPlus() {
		guard let rhsVal = globalEnvironment.heapGet(addr: rhsRegister) as? IntegerValue else { error(); return }
		guard let lhsVal = globalEnvironment.heapGet(addr: lhsRegister) as? IntegerValue else { error(); return }
		
		let res = IntegerValue(value: lhsVal.value + rhsVal.value)
		
		let newRef = globalEnvironment.malloc(size: 1)
		globalEnvironment.heapSet(value: res, addr: newRef)
		resultRegister = newRef
	}
	
	func binaryMinus() {
		guard let rhsVal = globalEnvironment.heapGet(addr: rhsRegister) as? IntegerValue else { error(); return }
		guard let lhsVal = globalEnvironment.heapGet(addr: lhsRegister) as? IntegerValue else { error(); return }
		
		let res = IntegerValue(value: lhsVal.value - rhsVal.value)
		
		let newRef = globalEnvironment.malloc(size: 1)
		globalEnvironment.heapSet(value: res, addr: newRef)
		resultRegister = newRef
	}
	
	// MARJK: Rel
	
	func relEQ() {
		guard let rhsVal = globalEnvironment.heapGet(addr: rhsRegister) as? IntegerValue else { error(); return }
		guard let lhsVal = globalEnvironment.heapGet(addr: lhsRegister) as? IntegerValue else { error(); return }
		
		let res = BooleanValue(value: lhsVal.value == rhsVal.value)
		
		let newRef = globalEnvironment.malloc(size: 1)
		globalEnvironment.heapSet(value: res, addr: newRef)
		resultRegister = newRef
	}
	
	func relNE() {
		guard let rhsVal = globalEnvironment.heapGet(addr: rhsRegister) as? IntegerValue else { error(); return }
		guard let lhsVal = globalEnvironment.heapGet(addr: lhsRegister) as? IntegerValue else { error(); return }
		
		let res = BooleanValue(value: lhsVal.value != rhsVal.value)
		
		let newRef = globalEnvironment.malloc(size: 1)
		globalEnvironment.heapSet(value: res, addr: newRef)
		resultRegister = newRef
	}
	
	func relGT() {
		guard let rhsVal = globalEnvironment.heapGet(addr: rhsRegister) as? IntegerValue else { error(); return }
		guard let lhsVal = globalEnvironment.heapGet(addr: lhsRegister) as? IntegerValue else { error(); return }
		
		let res = BooleanValue(value: lhsVal.value > rhsVal.value)
		
		let newRef = globalEnvironment.malloc(size: 1)
		globalEnvironment.heapSet(value: res, addr: newRef)
		resultRegister = newRef
	}
	
	func relGE() {
		guard let rhsVal = globalEnvironment.heapGet(addr: rhsRegister) as? IntegerValue else { error(); return }
		guard let lhsVal = globalEnvironment.heapGet(addr: lhsRegister) as? IntegerValue else { error(); return }
		
		let res = BooleanValue(value: lhsVal.value >= rhsVal.value)
		
		let newRef = globalEnvironment.malloc(size: 1)
		globalEnvironment.heapSet(value: res, addr: newRef)
		resultRegister = newRef
	}
	
	func relLT() {
		guard let rhsVal = globalEnvironment.heapGet(addr: rhsRegister) as? IntegerValue else { error(); return }
		guard let lhsVal = globalEnvironment.heapGet(addr: lhsRegister) as? IntegerValue else { error(); return }
		
		let res = BooleanValue(value: lhsVal.value < rhsVal.value)
		
		let newRef = globalEnvironment.malloc(size: 1)
		globalEnvironment.heapSet(value: res, addr: newRef)
		resultRegister = newRef
	}
	
	func relLE() {
		guard let rhsVal = globalEnvironment.heapGet(addr: rhsRegister) as? IntegerValue else { error(); return }
		guard let lhsVal = globalEnvironment.heapGet(addr: lhsRegister) as? IntegerValue else { error(); return }
		
		let res = BooleanValue(value: lhsVal.value <= rhsVal.value)
		
		let newRef = globalEnvironment.malloc(size: 1)
		globalEnvironment.heapSet(value: res, addr: newRef)
		resultRegister = newRef
	}
	
	// MARK: Boolean
	
	func booleanAnd() {
		guard let rhsVal = globalEnvironment.heapGet(addr: rhsRegister) as? BooleanValue else { error(); return }
		guard let lhsVal = globalEnvironment.heapGet(addr: lhsRegister) as? BooleanValue else { error(); return }
		
		let res = BooleanValue(value: lhsVal.value && rhsVal.value)
		
		let newRef = globalEnvironment.malloc(size: 1)
		globalEnvironment.heapSet(value: res, addr: newRef)
		resultRegister = newRef
	}
	
	func booleanOr() {
		guard let rhsVal = globalEnvironment.heapGet(addr: rhsRegister) as? BooleanValue else { error(); return }
		guard let lhsVal = globalEnvironment.heapGet(addr: lhsRegister) as? BooleanValue else { error(); return }
		
		let res = BooleanValue(value: lhsVal.value || rhsVal.value)
		
		let newRef = globalEnvironment.malloc(size: 1)
		globalEnvironment.heapSet(value: res, addr: newRef)
		resultRegister = newRef
	}
}
