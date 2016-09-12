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
	var resultRegister: ReferenceValue
	
	init(globalEnvironment: GlobalEnvironment) {
		self.globalEnvironment = globalEnvironment
	}
	
	func error() {
		print("<cpu_error>")
	}
	
	// MARK: Unary
	
	func unaryPlus() {
		guard let rhsVal = globalEnvironment.heapGet(addr: rhsRegister) as? IntegerValue else { error(); return }
		let res = IntegerValue(value: rhsVal.value)
		let newRef = globalEnvironment.malloc(size: 1)
		globalEnvironment.heapSet(value: res, addr: newRef)
		
		resultRegister = newRef
	}
	
	func unaryMinus() {
		guard let rhsVal = globalEnvironment.heapGet(addr: rhsRegister) as? IntegerValue else { error(); return }
		let res = IntegerValue(value: -rhsVal.value)
		let newRef = globalEnvironment.malloc(size: 1)
		globalEnvironment.heapSet(value: res, addr: newRef)
		
		resultRegister = newRef
	}
	
	func unaryLogNot() {
		guard let rhsVal = globalEnvironment.heapGet(addr: rhsRegister) as? BooleanValue else { error(); return }
		let res = BooleanValue(value: !rhsVal.value)
		let newRef = globalEnvironment.malloc(size: 1)
		globalEnvironment.heapSet(value: res, addr: newRef)
		
		resultRegister = newRef
	}
}
