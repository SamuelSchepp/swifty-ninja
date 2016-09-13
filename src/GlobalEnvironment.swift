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
	
    var localStack: Stack<LocalEnvironment>
    let heap: Heap
    
    init() {
        typeDecMap = [
            "Integer": IntegerType(),
            "Boolean": BooleanType(),
            "String": StringType(),
            "Character": CharacterType()
        ]
        
        varTypeMap = [:]
        globalVariables = [:]
        functions = [
            "writeInteger": SystemFunction(
                type: .none,
                ident: "writeInteger",
                par_decs: [Par_Dec(type: IdentifierTypeExpression(ident: "Integer"), ident: "nr")],
                callee: { globalInvironment in
                    guard let ref = globalInvironment.findReferenceOfVariable(ident: "nr") else { return .UnresolvableReference(ident: "nr") }
                    
                    let valueRes = globalInvironment.heap.get(addr: ref)
                    switch valueRes {
                    case .SuccessValue(let val as IntegerValue):
                        print(val.value, separator: "", terminator: "")
                        return .SuccessVoid
                    default:
                        return valueRes
                    }
                }
            )
        ]
		
		localStack = Stack()
		heap = Heap()
    }
	
	// MARK: Variables
	
	func setVarRef(ident: String, value: ReferenceValue) {
		if localStack.hasElements() {
			if localStack.peek()!.variables.keys.contains(ident) {
				localStack.peek()!.variables[ident] = value
			}
		}
		if globalVariables.keys.contains(ident) {
			globalVariables[ident] = value
		}
	}
	
	func findReferenceOfVariable(ident: String) -> ReferenceValue? {
		if let ref = localStack.peek()?.variables[ident] {
			return ref
		}
		if let ref = globalVariables[ident] {
			return ref
		}
		return .none
	}
	
	func findTypeOfVariable(ident: String) -> Type? {
		if let ty = localStack.peek()?.varTypeMap[ident] {
			return ty
		}
		if let ty = varTypeMap[ident] {
			return ty
		}
		return .none
	}
    
    func identifierExists(ident: String) -> Bool {
        return typeDecMap.keys.contains(ident) ||
            varTypeMap.keys.contains(ident) ||
            globalVariables.keys.contains(ident) ||
            functions.keys.contains(ident) || localStack.peek()?.identifierExists(ident: ident) ?? false
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
		print("==== Functions ====")
		functions.forEach { key, value in
			let left = String.padding("\"\(key)\":")(toLength: width, withPad: " ", startingAt: 0)
			print("\(left)\(value.signature)")
		}
		print()
		print("==== Heap ====")
		heap.dump()
	}
	
	func heapPeek() -> Value {
		return heap.last!
	}
}
