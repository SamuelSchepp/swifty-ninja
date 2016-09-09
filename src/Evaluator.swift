//
//  Evaluator.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 09/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

enum EvalResult{ case
	Success(Object),
	UnresolvableIdentifier(String),
	TypeMissmatch,
	NotImplemented,
	NotExhaustive
}

class Evaluator {
	
	// MARK: Global
	
	static func evaluate(node: ASTNode) -> EvalResult {
		if let exp = node as? Exp {
			return evaluate(node: exp)
		}
		
		return .NotExhaustive
	}
	
	// MARK: Exp
	
	static func evaluate(node: Exp) -> EvalResult {
		if let or_exp = node as? Or_Exp {
			return evaluate(node: or_exp)
		}
		
		return .NotExhaustive
	}
	
	// MARK: Or
	
	static func evaluate(node: Or_Exp) -> EvalResult {
		if let or_exp_binary = node as? Or_Exp_Binary {
			return evaluate(node: or_exp_binary)
		}
		if let and_exp = node as? And_Exp {
			return evaluate(node: and_exp)
		}
		
		return .NotExhaustive
	}
	
	static func evaluate(node: Or_Exp_Binary) -> EvalResult {
		var lhs: BooleanObject
		var rhs: BooleanObject
		
		switch evaluate(node: node.lhs) {
		case let .Success(node as BooleanObject):
			lhs = node
		default:
			return .TypeMissmatch
		}
		
		switch evaluate(node: node.rhs) {
		case let .Success(node as BooleanObject):
			rhs = node
		default:
			return .TypeMissmatch
		}
		
		return .Success(BooleanObject(value: (lhs.value || rhs.value)))
	}
	
	// MARK: And
	
	static func evaluate(node: And_Exp) -> EvalResult {
		if let and_exp_binary = node as? And_Exp_Binary {
			return evaluate(node: and_exp_binary)
		}
		if let rel_exp = node as? Rel_Exp {
			return evaluate(node: rel_exp)
		}
		
		return .NotExhaustive
	}
	
	static func evaluate(node: And_Exp_Binary) -> EvalResult {
		var lhs: BooleanObject
		var rhs: BooleanObject
		
		switch evaluate(node: node.lhs) {
		case let .Success(node as BooleanObject):
			lhs = node
		default:
			return .TypeMissmatch
		}
		
		switch evaluate(node: node.rhs) {
		case let .Success(node as BooleanObject):
			rhs = node
		default:
			return .TypeMissmatch
		}
		
		return .Success(BooleanObject(value: (lhs.value && rhs.value)))
	}
	
	// MARK: Rel
	
	static func evaluate(node: Rel_Exp) -> EvalResult {
		if let rel_exp_binary = node as? Rel_Exp_Binary {
			return evaluate(node: rel_exp_binary)
		}
		if let add_exp = node as? Add_Exp {
			return evaluate(node: add_exp)
		}
		
		return .NotExhaustive
	}
	
	static func evaluate(node: Rel_Exp_Binary) -> EvalResult {
		var lhs: IntegerObject
		var rhs: IntegerObject
		
		switch evaluate(node: node.lhs) {
		case let .Success(node as IntegerObject):
			lhs = node
		default:
			return .TypeMissmatch
		}
		
		switch evaluate(node: node.rhs) {
		case let .Success(node as IntegerObject):
			rhs = node
		default:
			return .TypeMissmatch
		}
		
		var value: Bool
		switch node.op {
		case .EQ:
			value = lhs.value == rhs.value
		case .NE:
			value = lhs.value != rhs.value
		case .LT:
			value = lhs.value < rhs.value
		case .LE:
			value = lhs.value <= rhs.value
		case .GT:
			value = lhs.value > rhs.value
		case .GE:
			value = lhs.value >= rhs.value
		}
		
		return .Success(BooleanObject(value: value))
	}
	
	// MARK: Add
	
	static func evaluate(node: Add_Exp) -> EvalResult {
		if let add_exp_binary = node as? Add_Exp_Binary {
			return evaluate(node: add_exp_binary)
		}
		if let mul_exp = node as? Mul_Exp {
			return evaluate(node: mul_exp)
		}
		
		return .none
	}
	
	static func evaluate(node: Add_Exp_Binary) -> EvalResult {
		guard let lhs = evaluate(node: node.lhs) as? IntegerObject else { return .none }
		guard let rhs = evaluate(node: node.rhs) as? IntegerObject else { return .none }
		
		var value: Int
		switch node.op {
		case .PLUS:
			value = lhs.value + rhs.value
		case .MINUS:
			value = lhs.value - rhs.value
		}
		
		return IntegerObject(value: value)
	}
	
	// MARK: Mul
	
	static func evaluate(node: Mul_Exp) -> EvalResult {
		if let mul_exp_binary = node as? Mul_Exp_Binary {
			return evaluate(node: mul_exp_binary)
		}
		if let unary_exp = node as? Unary_Exp {
			return evaluate(node: unary_exp)
		}
		
		return .none
	}
	
	static func evaluate(node: Mul_Exp_Binary) -> EvalResult {
		guard let lhs = evaluate(node: node.lhs) as? IntegerObject else { return .none }
		guard let rhs = evaluate(node: node.rhs) as? IntegerObject else { return .none }
		
		var value: Int
		switch node.op {
		case .STAR:
			value = lhs.value * rhs.value
		case .SLASH:
			value = lhs.value / rhs.value
		case .PERCENT:
			value = lhs.value % rhs.value
		}
		
		return IntegerObject(value: value)
	}
	
	// MARK: Unary
	
	static func evaluate(node: Unary_Exp) -> EvalResult {
		if let unary_exp_impl = node as? Unary_Exp_Impl {
			return evaluate(node: unary_exp_impl)
		}
		if let primary_exp = node as? Primary_Exp {
			return evaluate(node: primary_exp)
		}
		
		return .none
	}
	
	static func evaluate(node: Unary_Exp_Impl) -> EvalResult{
		guard let rhs = evaluate(node: node.rhs) as? IntegerObject else { return .none }
		
		var value: Int
		switch node.op {
		case .PLUS:
			value = rhs.value
		case .MINUS:
			value = -rhs.value
		case .LOGNOT:
			value = ~rhs.value
		}
		
		return IntegerObject(value: value)
	}
	
	// MARK: Primary
	
	static func evaluate(node: Primary_Exp) -> EvalResult {
		if let primary_exp_nil = node as? Primary_Exp_Nil {
			return evaluate(node: primary_exp_nil)
		}
		if let primary_exp_exp = node as? Primary_Exp_Exp {
			return evaluate(node: primary_exp_exp)
		}
		if let primary_exp_integer = node as? Primary_Exp_Integer {
			return evaluate(node: primary_exp_integer)
		}
		if let primary_exp_character = node as? Primary_Exp_Character {
			return evaluate(node: primary_exp_character)
		}
		if let primary_exp_boolean = node as? Primary_Exp_Boolean {
			return evaluate(node: primary_exp_boolean)
		}
		if let primary_exp_string = node as? Primary_Exp_String {
			return evaluate(node: primary_exp_string)
		}
		if let primary_exp_sizeof = node as? Primary_Exp_Sizeof {
			return evaluate(node: primary_exp_sizeof)
		}
		if let primary_exp_var = node as? Var {
			return evaluate(node: primary_exp_var)
		}
		if let primary_exp_call = node as? Primary_Exp_Call {
			return evaluate(node: primary_exp_call)
		}
		if let new_obj_spec = node as? New_Obj_Spec {
			return evaluate(node: new_obj_spec)
		}
		
		return .none
	}
	
	static func evaluate(node: Primary_Exp_Nil) -> EvalResult {
		return ReferenceObject(value: .none)
	}
	
	static func evaluate(node: Primary_Exp_Exp) -> EvalResult {
		return evaluate(node: node.exp)
	}
	static func evaluate(node: Primary_Exp_Integer) -> EvalResult {
		return IntegerObject(value: node.value)
	}
	
	static func evaluate(node: Primary_Exp_Character) -> EvalResult {
		return CharacterObject(value: node.value)
	}
	
	static func evaluate(node: Primary_Exp_Boolean) -> EvalResult {
		return BooleanObject(value: node.value)
	}
	
	static func evaluate(node: Primary_Exp_String) -> EvalResult {
		return StringObject(value: node.value)
	}
	
	static func evaluate(node: Primary_Exp_Sizeof) -> EvalResult {
		return .none
	}
	
	static func evaluate(node: Var) -> EvalResult {
		if let var_array_access = node as? Var_Array_Access {
			return evaluate(node: var_array_access)
		}
		if let var_ident = node as? Var_Ident {
			return evaluate(node: var_ident)
		}
		if let var_field_access = node as? Var_Field_Access {
			return evaluate(node: var_field_access)
		}
		return .none
	}
	
	static func evaluate(node: Primary_Exp_Call) -> EvalResult {
		return .none
	}
	
	static func evaluate(node: New_Obj_Spec) -> EvalResult {
		return .none
	}
	
	// MARK: Var
	
	static func evaluate(node: Var_Array_Access) -> EvalResult {
		_ = evaluate(node: node.primary_exp)
		_ = evaluate(node: node.brack_exp)
		return .none
	}
	
	static func evaluate(node: Var_Ident) -> EvalResult {
		print("Unresolvable identifier: \(node.ident)")
		return .none
	}
	
	static func evaluate(node: Var_Field_Access) -> EvalResult {
		_ = evaluate(node: node.primary_exp)
		print("Unresolvable identifier: \(node.ident)")
		return .none
	}
}
