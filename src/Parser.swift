//
//  Parser.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 08/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

class Parser {
	let stack: TokenStack
	
	init(with: [Token]) {
		stack = TokenStack(with: with)
	}
	
	func parse_Program() -> Program? {
		var glob_decs = [Glob_Dec]()
		
		while(stack.hasElements()) {
			if let type_dec = parse_Type_Dec() {
				glob_decs.append(type_dec)
				continue
			}
			
			return .none
		}
		
		
		return Program(glob_decs: glob_decs)
	}
	
	func parse_Type_Dec() -> Type_Dec? {
		guard let _: TYPE		= stack.pop() else { return .none }
		guard let ident: IDENT	= stack.pop() else { return .none }
		guard let _: ASGN		= stack.pop() else { return .none }
		guard let type			= parse_Type() else { return .none }
		guard let _: SEMIC		= stack.pop() else { return .none }
		
		return Type_Dec(ident: ident.value, type: type)
	}
	
	func parse_Type() -> Type? {
		if let ident: IDENT = stack.pop() {
			if let _: LBRACK = stack.pop() {
				guard let _: RBRACK = stack.pop() else { return .none }
				return ArrayType(ident: ident.value, dims: 1)
			}
			else {
				return IdentifierType(ident: ident.value)
			}
		}
		else {
			guard let _: RECORD = stack.pop() else { return .none }
			guard let _: LCURL = stack.pop() else { return .none }
			let memb_dec_list = parse_Mem_Dec_List()
			guard let _: RCURL = stack.pop() else { return .none }
			
			return RecordType(memb_decs: memb_dec_list)
		}
	}
	
	func parse_Mem_Dec_List() -> [Memb_Dec] {
		var memb_dec_list = [Memb_Dec]()
		
		while(true) {
			guard let type = parse_Type() else { break }
			guard let ident: IDENT = stack.pop() else { break }
			guard let _: SEMIC = stack.pop() else { break }
			
			memb_dec_list.append(Memb_Dec(type: type, ident: ident.value))
		}
		
		return memb_dec_list
	}
}
