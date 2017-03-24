//
//  Framework.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 14/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

struct Framework {
	static let writeInteger = SystemFunction(
		type: .none,
		ident: "writeInteger",
		par_decs: [Par_Dec(type: IdentifierTypeExpression(ident: "Integer"), ident: "nr")],
		callee: { globalInvironment in
			let ref = try globalInvironment.findReferenceOfVariable(ident: "nr")
			if let value = try globalInvironment.heap.get(addr: ref) as? IntegerValue {
				globalInvironment.output(string: String(value.value))
				throw REPLControlFlow.ReturnVoid
			}
			throw REPLError.TypeMissmatch(expected: "IntegerValue", context: "writeInteger")
		}
	)
	
	static let writeCharacter = SystemFunction(
		type: .none,
		ident: "writeCharacter",
		par_decs: [Par_Dec(type: IdentifierTypeExpression(ident: "Character"), ident: "chr")],
		callee: { globalInvironment in
			let ref = try globalInvironment.findReferenceOfVariable(ident: "chr")
			if let value = try globalInvironment.heap.get(addr: ref) as? CharacterValue {
				globalInvironment.output(string: String(value.value))
				throw REPLControlFlow.ReturnVoid
			}
			throw REPLError.TypeMissmatch(expected: "CharacterValue", context: "writeCharacter")
		}
	)
	
	static let readInteger = SystemFunction(
		type: IdentifierTypeExpression(ident: "Integer"),
	    ident: "readInteger",
	    par_decs: [],
	    callee: { (globalInvironment: GlobalEnvironment) in
			guard let input = readLine() else { throw REPLError.TypeMissmatch(expected: "Integer Input", context: "readInteger") }
			guard let nr = Int(input) else { throw REPLError.TypeMissmatch(expected: "Integer Input", context: "readInteger") }
			let ref = try globalInvironment.heap.malloc(size: 1);
			try globalInvironment.heap.set(value: IntegerValue(value: nr), addr: ref);
			throw REPLControlFlow.ReturnValue(ref: ref);
		}
	)
	
	static let sysDump = SystemFunction(
		type: .none,
		ident: "sysDump",
		par_decs: [],
		callee: { (globalInvironment: GlobalEnvironment) in
			globalInvironment.dump();
		}
	)
	
	static let writeString = SystemFunction(
		type: .none,
		ident: "writeString",
		par_decs: [Par_Dec(type: ArrayTypeExpression(ident: "Character", dims: 1), ident: "string")],
		callee: { (globalInvironment: GlobalEnvironment) in
			let refToArray = try globalInvironment.findReferenceOfVariable(ident: "string")
			guard let size = try globalInvironment.heap.get(addr: refToArray) as? SizeValue else {
				throw REPLError.TypeMissmatch(expected: "SizeValue", context: "writeString")
			}
			var index = 0;
			while(index < size.value) {
				guard let refToValue = try globalInvironment.heap.get(addr: ReferenceValue(value: refToArray.value + index + 1)) as? ReferenceValue else {
					throw REPLError.TypeMissmatch(expected: "ReferenceValue", context: "writeString")
				}
				guard let char = try globalInvironment.heap.get(addr: refToValue) as? CharacterValue else {
					throw REPLError.TypeMissmatch(expected: "CharacterValue", context: "writeString")
				}
				globalInvironment.output(string: String(char.value))
				index += 1
			}
		}
	)
	
	static let char2int = SystemFunction(
		type: IdentifierTypeExpression(ident: "Integer"),
		ident: "char2int",
		par_decs: [Par_Dec(type: IdentifierTypeExpression(ident: "Character"), ident: "c")],
		callee: { globInvi in
			let refToChar = try globInvi.findReferenceOfVariable(ident: "c")
			guard let charValue = try globInvi.heap.get(addr: refToChar) as? CharacterValue else {
				throw REPLError.TypeMissmatch(expected: "CharacterValue", context: "char2int")
			}
			let refToInt = try globInvi.heap.malloc(size: 1)
			let s = String(charValue.value).unicodeScalars
			try globInvi.heap.set(value: IntegerValue(value: Int(s[s.startIndex].value)), addr: refToInt)
			
			throw REPLControlFlow.ReturnValue(ref: refToInt)
		}
	)
	
	static let int2char = SystemFunction(
		type: IdentifierTypeExpression(ident: "Character"),
		ident: "int2char",
		par_decs: [Par_Dec(type: IdentifierTypeExpression(ident: "Integer"), ident: "i")],
		callee: { globInvi in
			let refToInt = try globInvi.findReferenceOfVariable(ident: "i")
			guard let intValue = try globInvi.heap.get(addr: refToInt) as? IntegerValue else {
				throw REPLError.TypeMissmatch(expected: "IntegerValue", context: "int2char")
			}
			let refToChar = try globInvi.heap.malloc(size: 1)
			try globInvi.heap.set(value: CharacterValue(value: Character(UnicodeScalar(intValue.value)!)), addr: refToChar)
			
			throw REPLControlFlow.ReturnValue(ref: refToChar)
		}
	)
}
