//
//  Parser$Statement.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 11/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

extension Parser {
	// MARK: Stm List
	
	func parse_Stms() -> Stms? {
		if let stm = parse_Stm() {
			var stms = [Stm]()
			stms.append(stm)
			if let stmsP = parse_Stms() {
				stms += stmsP.stms
			}
			return Stms(stms: stms)
		}
		
		return Stms(stms: [])
	}
	
	func parse_Stm() -> Stm? {
		if let stm = parse_Empty_Stm() {
			return stm
		}
		if let stm = parse_Compound_Stm() {
			return stm
		}
		if let stm = parse_Assign_Stm() {
			return stm
		}
		if let stm = parse_If_Stm() {
			return stm
		}
		if let stm = parse_While_Stm() {
			return stm
		}
		if let stm = parse_Do_Stm() {
			return stm
		}
		if let stm = parse_Break_Stm() {
			return stm
		}
		if let stm = parse_Call_Stm() {
			return stm
		}
		if let stm = parse_Return_Stm() {
			return stm
		}
		
		return .none
	}
	
	func parse_Empty_Stm() -> Empty_Stm? {
		let context = stack.context
		guard let _: SEMIC = stack.pop() else { stack.context = context; return .none }
		return Empty_Stm()
	}
	
	func parse_Compound_Stm() -> Compound_Stm? {
		let context = stack.context
		
		guard let _: LCURL = stack.pop() else { stack.context = context; return .none }
		guard let stms = parse_Stms() else { stack.context = context; return .none }
		guard let _: RCURL = stack.pop() else { stack.context = context; return .none }
		
		return Compound_Stm(stms: stms)
	}
	
	func parse_Assign_Stm() -> Assign_Stm? {
		let context = stack.context
		
		guard let _var = parse_Var() else { stack.context = context; return .none }
		guard let _: ASGN = stack.pop() else { stack.context = context; return .none }
		guard let exp = parse_Exp() else { stack.context = context; return .none }
		guard let _: SEMIC = stack.pop() else { stack.context = context; return .none }
		
		return Assign_Stm(_var: _var, exp: exp)
	}
	
	func parse_If_Stm() -> If_Stm? {
		let context = stack.context
		
		guard let _: IF = stack.pop() else { stack.context = context; return .none }
		guard let _: LPAREN = stack.pop() else { stack.context = context; return .none }
		guard let exp = parse_Exp() else { stack.context = context; return .none }
		guard let _: RPAREN = stack.pop() else { stack.context = context; return .none }
		guard let stm = parse_Stm() else { stack.context = context; return .none }
		if let _: ELSE = stack.pop() {
			guard let elseStm = parse_Stm() else { stack.context = context; return .none }
			return If_Stm(exp: exp, stm: stm, elseStm: elseStm)
		}
		else {
			return If_Stm(exp: exp, stm: stm, elseStm: .none)
		}
	}
	
	func parse_While_Stm() -> While_Stm? {
		let context = stack.context
		
		guard let _: WHILE = stack.pop() else { stack.context = context; return .none }
		guard let _: LPAREN = stack.pop() else { stack.context = context; return .none }
		guard let exp = parse_Exp() else { stack.context = context; return .none }
		guard let _: RPAREN = stack.pop() else { stack.context = context; return .none }
		guard let stm = parse_Stm() else { stack.context = context; return .none }
		
		return While_Stm(exp: exp, stm: stm)
	}
	
	func parse_Do_Stm() -> Do_Stm? {
		let context = stack.context
		
		guard let _: DO = stack.pop() else { stack.context = context; return .none }
		guard let stm = parse_Stm() else { stack.context = context; return .none }
		guard let _: WHILE = stack.pop() else { stack.context = context; return .none }
		guard let _: LPAREN = stack.pop() else { stack.context = context; return .none }
		guard let exp = parse_Exp() else { stack.context = context; return .none }
		guard let _: RPAREN = stack.pop() else { stack.context = context; return .none }
		guard let _: SEMIC = stack.pop() else { stack.context = context; return .none }
		
		return Do_Stm(stm: stm, exp: exp)
	}
	
	func parse_Break_Stm() -> Break_Stm? {
		let context = stack.context
		
		guard let _: BREAK = stack.pop() else { stack.context = context; return .none }
		guard let _: SEMIC = stack.pop() else { stack.context = context; return .none }
		
		return Break_Stm()
	}
	
	func parse_Call_Stm() -> Call_Stm? {
		let context = stack.context
		
		guard let ident: IDENT = stack.pop() else { stack.context = context; return .none }
		guard let _: LPAREN = stack.pop() else { stack.context = context; return .none }
		guard let arg_list = parse_Arg_List() else { stack.context = context; return .none }
		guard let _: RPAREN = stack.pop() else { stack.context = context; return .none }
		guard let _: SEMIC = stack.pop() else { stack.context = context; return .none }
		
		return Call_Stm(ident: ident.value, args: arg_list)
	}
	
	func parse_Return_Stm() -> Return_Stm? {
		let context = stack.context
		
		guard let _: RETURN = stack.pop() else { stack.context = context; return .none }
		if let _: SEMIC = stack.pop() {
			return Return_Stm(exp: .none)
		}
		else {
			guard let exp = parse_Exp() else { stack.context = context; return .none }
			guard let _: SEMIC = stack.pop() else { stack.context = context; return .none }
			
			return Return_Stm(exp: exp)
		}
	}
}
