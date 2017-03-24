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
    var globalVariables: [String: ReferenceValue]
    var functions: [String: Function]
	var outputBuffer: String
	
    var localStack: Stack<LocalEnvironment>
    let heap: Heap
    
    init() {
        typeDecMap = [
            "Integer": IntegerType(),
            "Boolean": BooleanType(),
            "Character": CharacterType()
        ]
        
        varTypeMap = [:]
        globalVariables = [:]
        functions = [
            "writeInteger": Framework.writeInteger,
            "writeCharacter": Framework.writeCharacter,
			"readInteger": Framework.readInteger,
			"sysDump" : Framework.sysDump,
			"writeString": Framework.writeString,
			"char2int": Framework.char2int,
			"int2char": Framework.int2char
        ]
		
		outputBuffer = ""
		
		localStack = Stack()
		heap = Heap()
    }
	
	// MARK: Variables
	
	func resetVarRef(ident: String, value: ReferenceValue) {
		if localStack.hasElements() {
			if localStack.peek()!.variables.keys.contains(ident) {
				localStack.peek()!.variables[ident] = value
			}
		}
		if globalVariables.keys.contains(ident) {
			globalVariables[ident] = value
		}
	}
	
	func findReferenceOfVariable(ident: String) throws -> ReferenceValue {
		if let ref = localStack.peek()?.variables[ident] {
			return ref
		}
		if let ref = globalVariables[ident] {
			return ref
		}
		throw REPLError.UnresolvableReference(ident: ident)
	}
	
	func findTypeOfVariable(ident: String) throws -> Type {
		if let ty = localStack.peek()?.varTypeMap[ident] {
			return ty
		}
		if let ty = varTypeMap[ident] {
			return ty
		}
		throw REPLError.UnresolvableType(ident: ident)
	}
	
	func findTypeOfTypeIdentifier(ident: String) throws -> Type {
		if let ty = typeDecMap[ident] {
			return ty
		}
		throw REPLError.UnresolvableType(ident: ident)
	}
    
    func identifierExists(ident: String) -> Bool {
        return typeDecMap.keys.contains(ident) ||
            varTypeMap.keys.contains(ident) ||
            globalVariables.keys.contains(ident) ||
            functions.keys.contains(ident) || localStack.peek()?.identifierExists(ident: ident) ?? false
    }
	
	func output(string: String) {
		outputBuffer += string;
		print(string, separator: "", terminator: "")
	}
	
	// MARK: Other
	
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
		globalVariables.forEach { key, value in
			let left = String.padding("\"\(key)\":")(toLength: width, withPad: " ", startingAt: 0)
			print("\(left)\(value)")
		}
		print()
		print("==== Stack ====")
		localStack.context.reversed().forEach { envi in
			envi.dump()
		}
		print()
		print("==== Functions ====")
		functions.forEach { key, value in
			let left = String.padding("\"\(key)\":")(toLength: width, withPad: " ", startingAt: 0)
			print("\(left)\(value.signature)")
		}
		print()
		print("==== Heap ====")
		heap.dump()
	}
	
	func heapPeek() throws -> Value {
		return try heap.last()
	}
}
