//
//  GlobalEnvironment.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 10/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

class GlobalEnvironment {
    var typeDecMap: [String: Type]
    var varTypeMap: [String: Type]
    var variables: [String: ReferenceValue]
    var functions: [String: Func_Dec]
	var localStack: Stack<LocalEnvironment>
	
	private var heap: [Value]
    
    init() {
        typeDecMap = [
            "Integer": IntegerType(),
            "Boolean": BooleanType(),
            "String": StringType(),
            "Character": CharacterType()
        ]
        
        varTypeMap = [:]
        variables = [:]
        functions = [:]
		
		localStack = Stack()
		
		heap = [UninitializedValue()]
    }
	
	func heapGet(addr: ReferenceValue) -> Value? {
		if checkBounds(addr: addr) {
			return heap[addr.value]
		}
		return .none
	}
	
	func heapSet(value: Value, addr: ReferenceValue) -> Bool {
		if checkBounds(addr: addr) {
			heap[addr.value] = value
			return true
		}
		else {
			return false
		}
	}
	
	func setVarRef(ident: String, value: ReferenceValue) {
		if variables.keys.contains(ident) {
			variables[ident] = value
		}
		if localStack.hasElements() {
			if localStack.peek()!.variables.keys.contains(ident) {
				localStack.peek()!.variables[ident] = value
			}
		}
	}
	
	func findReferenceOfVariable(ident: String) -> ReferenceValue? {
		if let ref = variables[ident] {
			return ref
		}
		if let ref = localStack.peek()?.variables[ident] {
			return ref
		}
		return .none
	}
	
	func findTypeOfVariable(ident: String) -> Type? {
		if let ty = varTypeMap[ident] {
			return ty
		}
		if let ty = localStack.peek()?.varTypeMap[ident] {
			return ty
		}
		return .none
	}
	
	private func checkBounds(addr: ReferenceValue) -> Bool {
		return addr.value < heap.count && addr.value > 0
	}
    
    func identifierExists(ident: String) -> Bool {
        return typeDecMap.keys.contains(ident) ||
            varTypeMap.keys.contains(ident) ||
            variables.keys.contains(ident) ||
            functions.keys.contains(ident) || localStack.peek()?.identifierExists(ident: ident) ?? false
    }
	
	func malloc(size: Int) -> ReferenceValue {
		if size <= 0 {
			return ReferenceValue(value: -1)
		}
		
		let start = heap.count
		for _ in 0..<size {
			heap.append(UninitializedValue())
		}
		
		return ReferenceValue(value: start)
	}
	
	func dump() {
		let width = 20
		print("==== Type Declarations ====")
		typeDecMap.forEach { key, value in
			let left = String.padding("\"\(key)\":")(toLength: width, withPad: " ", startingAt: 0)
			print("\(left)\(value)")
		}
		print()
		print("==== Variable Types ====")
		varTypeMap.forEach { key, value in
			let left = String.padding("\"\(key)\":")(toLength: width, withPad: " ", startingAt: 0)
			print("\(left)\(value)")
		}
		print()
		print("==== Variables ====")
		variables.forEach { key, value in
			let left = String.padding("\"\(key)\":")(toLength: width, withPad: " ", startingAt: 0)
			print("\(left)\(value)")
		}
		print()
		print("==== Functions ====")
		functions.forEach { key, value in
			let left = String.padding("\"\(key)\":")(toLength: width, withPad: " ", startingAt: 0)
			print("\(left)\(value.signature)")
		}
		print()
		print("==== Heap ====")
		for i in 1..<heap.count {
			print("\(ReferenceValue(value: i))  \(heap[i])")
		}
		print()
	}
}
