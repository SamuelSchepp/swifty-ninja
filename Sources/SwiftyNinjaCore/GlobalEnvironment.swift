//
//  GlobalEnvironment.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 10/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

public class GlobalEnvironment {
    public var typeDecMap: [String: Type]
    public var varTypeMap: [String: Type]
    public var globalVariables: [String: ReferenceValue]
    public var functions: [String: Function]
	public var outputBuffer: String
	
    public var localStack: Stack<LocalEnvironment>
    public let heap: Heap
    
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
	
	public func resetVarRef(ident: String, value: ReferenceValue) {
		if localStack.hasElements() {
			if localStack.peek()!.variables.keys.contains(ident) {
				localStack.peek()!.variables[ident] = value
			}
		}
		if globalVariables.keys.contains(ident) {
			globalVariables[ident] = value
		}
	}
	
	public func findReferenceOfVariable(ident: String) throws -> ReferenceValue {
		if let ref = localStack.peek()?.variables[ident] {
			return ref
		}
		if let ref = globalVariables[ident] {
			return ref
		}
		throw REPLError.UnresolvableReference(ident: ident)
	}
	
	public func findTypeOfVariable(ident: String) throws -> Type {
		if let ty = localStack.peek()?.varTypeMap[ident] {
			return ty
		}
		if let ty = varTypeMap[ident] {
			return ty
		}
		throw REPLError.UnresolvableType(ident: ident)
	}
	
	public func findTypeOfTypeIdentifier(ident: String) throws -> Type {
		if let ty = typeDecMap[ident] {
			return ty
		}
		throw REPLError.UnresolvableType(ident: ident)
	}
    
    public func identifierExists(ident: String) -> Bool {
        return typeDecMap.keys.contains(ident) ||
            varTypeMap.keys.contains(ident) ||
            globalVariables.keys.contains(ident) ||
            functions.keys.contains(ident) || localStack.peek()?.identifierExists(ident: ident) ?? false
    }
	
	public func output(string: String) {
		outputBuffer += string;
		print(string, separator: "", terminator: "")
	}
	
	// MARK: Other
	
	public func dump() {
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
	
	public func heapPeek() throws -> Value {
		return try heap.last()
	}
}
