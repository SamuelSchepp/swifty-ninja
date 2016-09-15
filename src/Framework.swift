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
				print(value.value, separator: "", terminator: "")
				throw REPLControlFlow.ReturnVoid
			}
			throw REPLError.TypeMissmatch
		}
	)
	
	static let writeCharacter = SystemFunction(
		type: .none,
		ident: "writeCharacter",
		par_decs: [Par_Dec(type: IdentifierTypeExpression(ident: "Character"), ident: "chr")],
		callee: { globalInvironment in
			let ref = try globalInvironment.findReferenceOfVariable(ident: "chr")
			if let value = try globalInvironment.heap.get(addr: ref) as? CharacterValue {
				print(value.value, separator: "", terminator: "")
				throw REPLControlFlow.ReturnVoid
			}
			throw REPLError.TypeMissmatch
		}
	)
	
	static let readInteger = SystemFunction(
		type: IdentifierTypeExpression(ident: "Integer"),
	    ident: "readInteger",
	    par_decs: [],
	    callee: { (globalInvironment: GlobalEnvironment) in
			guard let input = readLine() else { throw REPLError.TypeMissmatch }
			guard let nr = Int(input) else { throw REPLError.TypeMissmatch }
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
}
