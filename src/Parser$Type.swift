//
//  Parser$Type.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 11/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

extension Parser {
	
	// MARK: Type
	
	func parse_Type() -> TypeExpression? {
		let context = stack.context
		
		if let ident: IDENT = stack.pop() {
			if let _: LBRACK = stack.pop() {
				guard let _: RBRACK = stack.pop() else { stack.context = context; return .none }
				guard let more_dims = parse_More_Dims() else { stack.context = context; return .none }
				return ArrayTypeExpression(ident: ident.value, dims: more_dims + 1)
			}
			else {
				return IdentifierTypeExpression(ident: ident.value)
			}
		}
		else {
			guard let _: RECORD = stack.pop() else { stack.context = context; return .none }
			guard let _: LCURL = stack.pop() else { stack.context = context; return .none }
			guard let memb_dec_list = parse_Mem_Dec_List() else { stack.context = context; return .none }
			guard let _: RCURL = stack.pop() else { stack.context = context; return .none }
			
			return RecordTypeExpression(memb_decs: memb_dec_list)
		}
	}
	
	func parse_More_Dims() -> Int? {
		let context = stack.context
		
		var dims = 0
		while(true) {
			guard let _: LBRACK = stack.pop() else { break }
			guard let _: RBRACK = stack.pop() else { stack.context = context; return .none }
			dims += 1
		}
		return dims
	}
	
	func parse_Mem_Dec_List() -> [Memb_Dec]? {
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
