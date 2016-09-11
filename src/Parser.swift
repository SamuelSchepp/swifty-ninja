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
		
		while(true) {
			if let type_dec = parse_Type_Dec() {
				glob_decs.append(type_dec)
				continue
			}
			if let gvar_dec = parse_Gvar_Dec() {
				glob_decs.append(gvar_dec)
				continue
			}
			if let func_dec = parse_Func_Dec() {
				glob_decs.append(func_dec)
				continue
			}
			
			break
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
	
	func parse_Func_Dec() -> Func_Dec? {
		let context = stack.context
		
		let type = parse_Type()
		
		guard let ident: IDENT	= stack.pop() else { stack.context = context; return .none }
		guard let _: LPAREN		= stack.pop() else { stack.context = context; return .none }
		let par_decs			= parse_Par_Decs()
		guard let _: RPAREN		= stack.pop() else { stack.context = context; return .none }
		guard let _: LCURL		= stack.pop() else { stack.context = context; return .none }
		let lvar_decs			= parse_Lvar_Decs()
		guard let stms			= parse_Stms() else { stack.context = context; return .none }
		guard let _: RCURL		= stack.pop() else { stack.context = context; return .none }
		
		return Func_Dec(type: type, ident: ident.value, par_decs: par_decs, lvar_decs: lvar_decs, stms: stms)
	}
	
	func parse_Par_Decs() -> [Par_Dec] {
		var par_decs = [Par_Dec]()
		
		if let par_dec = parse_Par_Dec() {
			par_decs.append(par_dec)
			guard let _: COMMA	= stack.pop() else {
				return par_decs
			}
			par_decs += parse_Par_Decs()
		}
		
		return par_decs
	}
	
	func parse_Par_Dec() -> Par_Dec? {
		let context = stack.context
		
		guard let type = parse_Type() else { stack.context = context; return .none }
		guard let ident: IDENT = stack.pop() else { stack.context = context; return .none }
		
		return Par_Dec(type: type, ident: ident.value)
	}
	
	func parse_Lvar_Decs() -> [Lvar_Dec] {
		var lvar_decs = [Lvar_Dec]()
		
		if let lvar_dec = parse_Lvar_Dec() {
			lvar_decs.append(lvar_dec)
			lvar_decs += parse_Lvar_Decs()
		}
		
		return lvar_decs
	}
	
	func parse_Lvar_Dec() -> Lvar_Dec? {
		let context = stack.context
		
		guard let _: LOCAL		= stack.pop() else { stack.context = context; return .none }
		guard let type			= parse_Type() else { stack.context = context; return .none }
		guard let ident: IDENT	= stack.pop() else { stack.context = context; return .none }
		guard let _: SEMIC		= stack.pop() else { stack.context = context; return .none }
		
		return Lvar_Dec(type: type, ident: ident.value)
	}
}
