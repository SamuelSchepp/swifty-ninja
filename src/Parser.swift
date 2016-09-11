//
//  Parser.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 08/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

class Parser {
	var stack: TokenStack
	
	init(with: [Token]) {
		stack = TokenStack(with: with)
	}
	
	func isDone() -> Bool {
		let done = !stack.hasElements()
		return done
	}
	
	func parse_Program() -> Program? {
		let context = stack.context
		
		guard let glob_decs = parse_Glob_Decs() else { stack.context = context; return .none }
		
		return Program(glob_decs: glob_decs)
	}
	
	func parse_Glob_Decs() -> [Glob_Dec]? {
		var glob_decs = [Glob_Dec]()
		
		while(stack.hasElements()) {
			if let type_dec = parse_Type_Dec() {
				glob_decs.append(type_dec)
				continue
			}
			if let gvar_dec = parse_Gvar_Dec() {
				glob_decs.append(gvar_dec)
				continue
			}
			
			return .none
		}
		
		return glob_decs
	}
	
	// MARK: Type Dec
	
	func parse_Type_Dec() -> Type_Dec? {
		let context = stack.context
		
		guard let _: TYPE		= stack.pop() else { stack.context = context; return .none }
		guard let ident: IDENT	= stack.pop() else { stack.context = context; return .none }
		guard let _: ASGN		= stack.pop() else { stack.context = context; return .none }
		guard let type			= parse_Type() else { stack.context = context; return .none }
		guard let _: SEMIC		= stack.pop() else { stack.context = context; return .none }
		
		return Type_Dec(ident: ident.value, type: type)
	}
	
	// MARK: Gvar Dec
	
	func parse_Gvar_Dec() -> Gvar_Dec? {
		let context = stack.context
		
		guard let _: GLOBAL		= stack.pop() else { stack.context = context; return .none }
		guard let type			= parse_Type() else { stack.context = context; return .none }
		guard let ident: IDENT	= stack.pop() else { stack.context = context; return .none }
		guard let _: SEMIC		= stack.pop() else { stack.context = context; return .none }
		
		return Gvar_Dec(type: type, ident: ident.value)
	}
}
