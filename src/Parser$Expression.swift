//
//  Parser$Expression.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 11/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

extension Parser {
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
			if let _: LPAREN = stack.pop() { // Call Exp
				let arg_list = parse_Arg_List()
				guard let _: RPAREN = stack.pop() else { stack.context = context; return .none }
				return Primary_Exp_Call(ident: ident.value, args: arg_list)
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
	
	func parse_Arg_List() -> [Arg] {
		var list = [Arg]()
		if let exp = parse_Exp() {
			list.append(Arg(exp: exp))
			if let _: COMMA = stack.pop() {
				list += parse_Arg_List()
				return list
			}
		}
		return list
	}
}
