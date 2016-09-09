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
	
	func isDone() -> Bool {
		return !stack.hasElements()
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
				guard let more_dims = parse_More_Dims() else { return .none }
				return ArrayType(ident: ident.value, dims: more_dims + 1)
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
	
	func parse_More_Dims() -> Int? {
		var dims = 0
		while(true) {
			guard let _: LBRACK = stack.pop() else { break }
			guard let _: RBRACK = stack.pop() else { return .none }
			dims += 1
		}
		return dims
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
	
	// MARK: Expression
	
	func parse_Exp() -> Exp? {
		guard let or_exp = parse_Or_Exp() else { return .none }
		
		return or_exp
	}
	
	func parse_Or_Exp() -> Or_Exp? {
		if let and_exp = parse_And_Exp() {
			if let _: LOGOR = stack.pop() {
				guard let and_exp2 = parse_And_Exp() else { return .none }
				return Or_Exp_Binary(lhs: and_exp, rhs: and_exp2)
			}
			return and_exp
		}
		else {
			guard let or_exp = parse_Or_Exp() else { return .none }
			guard let _: LOGOR = stack.pop() else { return .none }
			guard let and_exp = parse_And_Exp() else { return .none }
			return Or_Exp_Binary(lhs: or_exp, rhs: and_exp)
		}
	}
	
	func parse_And_Exp() -> And_Exp? {
		if let rel_exp = parse_Rel_Exp() {
			if let _: LOGAND = stack.pop() {
				guard let rel_exp2 = parse_Rel_Exp() else { return .none }
				return And_Exp_Binary(lhs: rel_exp, rhs: rel_exp2)
			}
			return rel_exp
		}
		else {
			guard let and_exp = parse_And_Exp() else { return .none }
			guard let _: LOGAND = stack.pop() else { return .none }
			guard let rel_exp = parse_Rel_Exp() else { return .none }
			return And_Exp_Binary(lhs: and_exp, rhs: rel_exp)
		}
	}
	
	func parse_Rel_Exp() -> Rel_Exp? {
		guard let add_exp = parse_Add_Exp() else { return .none }
		if let op = stack.pop_Rel_Exp_Binary_Op() {
			guard let add_exp2 = parse_Add_Exp() else { return .none }
			return Rel_Exp_Binary(lhs: add_exp, rhs: add_exp2, op: op)
		}
		else {
			return add_exp
		}
	}
	
	func parse_Add_Exp() -> Add_Exp? {
		if let mul_exp = parse_Mul_Exp() {
			if let op = stack.pop_Add_Exp_Binary_Op() {
				guard let mul_exp2 = parse_Mul_Exp() else { return .none }
				return Add_Exp_Binary(lhs: mul_exp, rhs: mul_exp2, op: op)
			}
			return mul_exp
		}
		else {
			guard let add_exp = parse_Add_Exp() else { return .none }
			guard let op = stack.pop_Add_Exp_Binary_Op() else { return .none }
			guard let mul_exp = parse_Mul_Exp() else { return .none }
			return Add_Exp_Binary(lhs: add_exp, rhs: mul_exp, op: op)
		}
	}
	
	func parse_Mul_Exp() -> Mul_Exp? {
		if let unary_exp = parse_Unary_Exp() {
			if let op = stack.pop_Mul_Exp_Binary_Op() {
				guard let unary_exp2 = parse_Unary_Exp() else { return .none }
				return Mul_Exp_Binary(lhs: unary_exp, rhs: unary_exp2, op: op)
			}
			return unary_exp
		}
		else {
			guard let mul_exp = parse_Mul_Exp() else { return .none }
			guard let op = stack.pop_Mul_Exp_Binary_Op() else { return .none }
			guard let unary_exp = parse_Unary_Exp() else { return .none }
			return Mul_Exp_Binary(lhs: mul_exp, rhs: unary_exp, op: op)
		}
	}
	
	func parse_Unary_Exp() -> Unary_Exp? {
		if let primary_exp = parse_Primary_Exp() {
			return primary_exp
		}
		else {
			guard let op = stack.pop_Unary_Exp_Impl_Op() else { return .none }
			guard let unary_exp = parse_Unary_Exp() else { return .none }
			return Unary_Exp_Impl(op: op, rhs: unary_exp)
		}
	}
	
	func parse_Primary_Exp() -> Primary_Exp? {
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
			guard let _: LPAREN = stack.pop() else { return .none }
			guard let new_obj_spec = parse_New_Object_Spec() else { return .none }
			guard let _: RPAREN = stack.pop() else { return .none }
			return new_obj_spec
		}
		if let _: SIZEOF = stack.pop() {
			guard let _: LPAREN = stack.pop() else { return .none }
			guard let exp = parse_Exp() else { return .none }
			guard let _: RPAREN = stack.pop() else { return .none }
			return Primary_Exp_Sizeof(exp: exp)
		}
		if let _: LPAREN = stack.pop() {
			guard let exp = parse_Exp() else { return .none }
			guard let _: RPAREN = stack.pop() else { return .none }
			return Primary_Exp_Exp(exp: exp)
		}
		if let _var = parse_Var() {
			return _var
		}
		if let ident: IDENT = stack.pop() {
			guard let _: LPAREN = stack.pop() else { return .none }
			guard let arg_list = parse_Arg_List() else { return .none }
			guard let _: RPAREN = stack.pop() else { return .none }
			return Primary_Exp_Call(ident: ident.value, args: arg_list)
		}
		return .none
	}
	
	func parse_New_Object_Spec() -> New_Obj_Spec? {
		guard let ident: IDENT = stack.pop() else { return .none }
		if let _: LBRACK = stack.pop() {
			guard let exp = parse_Exp() else { return .none }
			guard let _: RBRACK = stack.pop() else { return .none }
			guard let more_dims = parse_More_Dims() else { return .none }
			return New_Obj_Spec_Array(ident: ident.value, exp: exp, more_dims: more_dims)
		}
		
		return New_Obj_Spec_Ident(ident: ident.value)
	}
	
	func parse_Var() -> Var? {
		if let ident: IDENT = stack.pop() {
			return Var_Ident(ident: ident.value)
		}
		else {
			guard let primary_exp = parse_Primary_Exp() else { return .none }
			if let _: LBRACK = stack.pop() {
				guard let exp = parse_Exp() else { return .none }
				guard let _: RBRACK = stack.pop() else { return .none }
				return Var_Array_Access(primary_exp: primary_exp, brack_exp: exp)
			}
			if let _: DOT = stack.pop() {
				guard let ident: IDENT = stack.pop() else { return .none }
				return Var_Field_Access(primary_exp: primary_exp, ident: ident.value)
			}
		}
		return .none
	}
	
	func parse_Arg_List() -> [Arg]? {
		var list = [Arg]()
		if let exp = parse_Exp() {
			list.append(Arg(exp: exp))
			if let _: COMMA = stack.pop() {
				guard let rest_List = parse_Arg_List() else { return .none }
				list.append(contentsOf: rest_List)
				return list
			}
		}
		return list
	}
}
