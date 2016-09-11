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
	
	// MARK: Stm List
	
	func parse_Stms() -> [Stm] {
		if let stm = parse_Stm() {
			var stms = [Stm]()
			stms.append(stm)
			stms += parse_Stms()
			return stms
		}
		
		return []
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
		let stms = parse_Stms()
		guard let _: LCURL = stack.pop() else { stack.context = context; return .none }
		
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
	
	// MARK: Expression
	
	func parse_Exp() -> Exp? {
		let context = stack.context
		
		guard let or_exp = parse_Or_Exp() else { stack.context = context; return .none }
		
		return or_exp
	}
	
	// MARK: Or
	
	func parse_Or_Exp() -> Or_Exp? {
		let context = stack.context
		
		guard let lhs = parse_And_Exp() else { stack.context = context; return .none }
		if let rest = parse_Or_Exp_Tail(currentExp: lhs) {
			return rest
		}
		else {
			return lhs
		}
	}
	
	func parse_Or_Exp_Tail(currentExp: Or_Exp) -> Or_Exp? {
		let context = stack.context
		
		guard let _: LOGOR = stack.pop() else { stack.context = context; return .none }
		guard let rhs = parse_And_Exp() else { stack.context = context; return .none }
		
		let current = Or_Exp_Binary(lhs: currentExp, rhs: rhs)
		
		guard let tailed = parse_Or_Exp_Tail(currentExp: current) else { return current }
		return tailed
	}
	
	// MARK: And
	
	func parse_And_Exp() -> And_Exp? {
		let context = stack.context
		
		guard let lhs = parse_Rel_Exp() else { stack.context = context; return .none }
		if let rest = parse_And_Exp_Tail(currentExp: lhs) {
			return rest
		}
		else {
			return lhs
		}
	}
	
	func parse_And_Exp_Tail(currentExp: And_Exp) -> And_Exp? {
		let context = stack.context
		
		guard let _: LOGAND = stack.pop() else { stack.context = context; return .none }
		guard let rhs = parse_Rel_Exp() else { stack.context = context; return .none }
		
		let current = And_Exp_Binary(lhs: currentExp, rhs: rhs)
		
		guard let tailed = parse_And_Exp_Tail(currentExp: current) else { return current }
		return tailed
	}
	
	// MARK: Rel
	
	func parse_Rel_Exp() -> Rel_Exp? {
		let context = stack.context
		
		guard let lhs = parse_Add_Exp() else { stack.context = context; return .none }
		if let op = stack.pop_Rel_Exp_Binary_Op() {
			guard let rhs = parse_Add_Exp() else { stack.context = context; return .none }
			return Rel_Exp_Binary(lhs: lhs, rhs: rhs, op: op)
		}
		else {
			return lhs
		}
	}
	
	// MARK: Add
	
	func parse_Add_Exp() -> Add_Exp? {
		let context = stack.context
		
		guard let lhs = parse_Mul_Exp() else { stack.context = context; return .none }
		if let rest = parse_Add_Exp_Tail(currentExp: lhs) {
			return rest
		}
		else {
			return lhs
		}
	}
	
	func parse_Add_Exp_Tail(currentExp: Add_Exp) -> Add_Exp? {
		let context = stack.context
		
		guard let op = stack.pop_Add_Exp_Binary_Op() else { stack.context = context; return .none }
		guard let rhs = parse_Mul_Exp() else { stack.context = context; return .none	}
		
		let current = Add_Exp_Binary(lhs: currentExp, rhs: rhs, op: op)
		
		guard let tailed = parse_Add_Exp_Tail(currentExp: current) else { return current }
		return tailed
	}
	
	// MARK: Mul
	
	func parse_Mul_Exp() -> Mul_Exp? {
		let context = stack.context
		
		guard let lhs = parse_Unary_Exp() else { stack.context = context; return .none }
		if let rest = parse_Mul_Exp_Tail(currentExp: lhs) {
			return rest
		}
		else {
			return lhs
		}
	}
	
	func parse_Mul_Exp_Tail(currentExp: Mul_Exp) -> Mul_Exp? {
		let context = stack.context
		
		guard let op = stack.pop_Mul_Exp_Binary_Op() else { stack.context = context; return .none }
		guard let rhs = parse_Unary_Exp() else { stack.context = context; return .none }
		
		let current = Mul_Exp_Binary(lhs: currentExp, rhs: rhs, op: op)
		
		guard let tailed = parse_Mul_Exp_Tail(currentExp: current) else { return current }
		return tailed
	}
	
	// MARK: Unary
	
	func parse_Unary_Exp() -> Unary_Exp? {
		let context = stack.context
		
		if let primary_exp = parse_Primary_Exp() {
			return primary_exp
		}
		else {
			guard let op = stack.pop_Unary_Exp_Impl_Op() else { stack.context = context; return .none }
			guard let unary_exp = parse_Unary_Exp() else { stack.context = context; return .none }
			return Unary_Exp_Impl(op: op, rhs: unary_exp)
		}
	}
	
	func parse_Primary_Exp() -> Primary_Exp? {
		let context = stack.context
		
		if let _: NIL = stack.pop() {
			return Primary_Exp_Nil()
		}
		if let integerlit: INTEGERLIT = stack.pop() {
			return Primary_Exp_Integer(value: integerlit.value)
		}
		if let characterlit: CHARACTERLIT = stack.pop() {
			return Primary_Exp_Character(value: characterlit.value)
		}
		if let booleanlit: BOOLEANLIT = stack.pop() {
			return Primary_Exp_Boolean(value: booleanlit.value)
		}
		if let stringlit: STRINGLIT = stack.pop() {
			return Primary_Exp_String(value: stringlit.value)
		}
		if let _: NEW = stack.pop() {
			guard let _: LPAREN = stack.pop() else { stack.context = context; return .none }
			guard let new_obj_spec = parse_New_Object_Spec() else { stack.context = context; return .none }
			guard let _: RPAREN = stack.pop() else { stack.context = context; return .none }
			return new_obj_spec
		}
		if let _: SIZEOF = stack.pop() {
			guard let _: LPAREN = stack.pop() else { stack.context = context; return .none }
			guard let exp = parse_Exp() else { stack.context = context; return .none }
			guard let _: RPAREN = stack.pop() else { stack.context = context; return .none }
			return Primary_Exp_Sizeof(exp: exp)
		}
		if let _: LPAREN = stack.pop() {
			guard let exp = parse_Exp() else { stack.context = context; return .none }
			guard let _: RPAREN = stack.pop() else { stack.context = context; return .none }
			return Primary_Exp_Exp(exp: exp)
		}
		if let _var = parse_Var() {
			return _var
		}
		if let ident: IDENT = stack.pop() {
			guard let _: LPAREN = stack.pop() else { stack.context = context; return .none }
			guard let arg_list = parse_Arg_List() else { stack.context = context; return .none }
			guard let _: RPAREN = stack.pop() else { stack.context = context; return .none }
			return Primary_Exp_Call(ident: ident.value, args: arg_list)
		}
		return .none
	}
	
	func parse_New_Object_Spec() -> New_Obj_Spec? {
		let context = stack.context
		
		guard let ident: IDENT = stack.pop() else { stack.context = context; return .none }
		if let _: LBRACK = stack.pop() {
			guard let exp = parse_Exp() else { stack.context = context; return .none }
			guard let _: RBRACK = stack.pop() else { stack.context = context; return .none }
			guard let more_dims = parse_More_Dims() else { stack.context = context; return .none }
			return New_Obj_Spec_Array(ident: ident.value, exp: exp, more_dims: more_dims)
		}
		
		return New_Obj_Spec_Ident(ident: ident.value)
	}
	
	func parse_Var() -> Var? {
		let context = stack.context
		
		if let ident: IDENT = stack.pop() {
			if let _: LBRACK = stack.pop() {
				guard let exp = parse_Exp() else { stack.context = context; return .none }
				guard let _: RBRACK = stack.pop() else { stack.context = context; return .none }
				return Var_Array_Access(primary_exp: Var_Ident(ident: ident.value), brack_exp: exp)
			}
			if let _: DOT = stack.pop() {
				guard let ident2: IDENT = stack.pop() else { stack.context = context; return .none }
				return Var_Field_Access(primary_exp: Var_Ident(ident: ident.value), ident: ident2.value)
			}
			return Var_Ident(ident: ident.value)
		}
		else {
			if !stack.check_Primary_Exp() { stack.context = context; return .none }
			guard let primary_exp = parse_Primary_Exp() else { stack.context = context; return .none }
			if let _: LBRACK = stack.pop() {
				guard let exp = parse_Exp() else { stack.context = context; return .none }
				guard let _: RBRACK = stack.pop() else { stack.context = context; return .none }
				return Var_Array_Access(primary_exp: primary_exp, brack_exp: exp)
			}
			if let _: DOT = stack.pop() {
				guard let ident: IDENT = stack.pop() else { stack.context = context; return .none }
				return Var_Field_Access(primary_exp: primary_exp, ident: ident.value)
			}
		}
		return .none
	}
	
	func parse_Arg_List() -> [Arg]? {
		let context = stack.context
		
		var list = [Arg]()
		if let exp = parse_Exp() {
			list.append(Arg(exp: exp))
			if let _: COMMA = stack.pop() {
				guard let rest_List = parse_Arg_List() else { stack.context = context; return .none }
				list.append(contentsOf: rest_List)
				return list
			}
		}
		return list
	}
}
