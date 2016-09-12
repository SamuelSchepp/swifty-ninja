//
//  Evaluator$Value.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 11/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

extension Evaluator {
	
	// MARK: Exp
	
	func evaluateValue(exp: Exp) -> REPLResult {
		if let or_exp = exp as? Or_Exp {
			return evaluateValue(or_exp: or_exp)
		}
		
		return .NotExhaustive
	}
	
	// MARK: Or
	
	func evaluateValue(or_exp: Or_Exp) -> REPLResult {
		if let or_exp_binary = or_exp as? Or_Exp_Binary {
			return evaluateValue(or_exp_binary: or_exp_binary)
		}
		if let and_exp = or_exp as? And_Exp {
			return evaluateValue(and_exp: and_exp)
		}
		
		return .NotExhaustive
	}
	
	func evaluateValue(or_exp_binary: Or_Exp_Binary) -> REPLResult {
		var lhs: BooleanValue
		var rhs: BooleanValue
		
		switch evaluateValue(or_exp: or_exp_binary.lhs) {
		case let .SuccessValue(node as BooleanValue, _ as BooleanType):
			lhs = node
		case .SuccessValue(_):
			return .TypeMissmatch
		case let any:
			return any
		}
		
		switch evaluateValue(and_exp: or_exp_binary.rhs) {
		case let .SuccessValue(node as BooleanValue, _ as BooleanType):
			rhs = node
		case .SuccessValue(_):
			return .TypeMissmatch
		case let any:
			return any
		}
		
		return .SuccessValue(value: (BooleanValue(value: (lhs.value || rhs.value))), type: BooleanType())
	}
	
	// MARK: And
	
	func evaluateValue(and_exp: And_Exp) -> REPLResult {
		if let and_exp_binary = and_exp as? And_Exp_Binary {
			return evaluateValue(and_exp_binary: and_exp_binary)
		}
		if let rel_exp = and_exp as? Rel_Exp {
			return evaluateValue(rel_exp: rel_exp)
		}
		
		return .NotExhaustive
	}
	
	func evaluateValue(and_exp_binary: And_Exp_Binary) -> REPLResult {
		var lhs: BooleanValue
		var rhs: BooleanValue
		
		switch evaluateValue(and_exp: and_exp_binary.lhs) {
		case let .SuccessValue(boolVal as BooleanValue, _ as BooleanType):
			lhs = boolVal
		case .SuccessValue(_, _):
			return .TypeMissmatch
		case let any:
			return any
		}
		
		switch evaluateValue(rel_exp: and_exp_binary.rhs) {
		case let .SuccessValue(boolVal as BooleanValue, _ as BooleanType):
			rhs = boolVal
		case .SuccessValue(_, _):
			return .TypeMissmatch
		case let any:
			return any
		}
		
		return .SuccessValue(value: BooleanValue(value: (lhs.value && rhs.value)), type: BooleanType())
	}
	
	// MARK: Rel
	
	func evaluateValue(rel_exp: Rel_Exp) -> REPLResult {
		if let rel_exp_binary = rel_exp as? Rel_Exp_Binary {
			return evaluateValue(rel_exp_binary: rel_exp_binary)
		}
		if let add_exp = rel_exp as? Add_Exp {
			return evaluateValue(add_exp: add_exp)
		}
		
		return .NotExhaustive
	}
	
	func evaluateValue(rel_exp_binary: Rel_Exp_Binary) -> REPLResult {
		var lhs: IntegerValue
		var rhs: IntegerValue
		
		switch evaluateValue(add_exp: rel_exp_binary.lhs) {
		case let .SuccessValue(integerVal as IntegerValue, _ as IntegerType):
			lhs = integerVal
		case .SuccessValue(_, _):
			return .TypeMissmatch
		case let any:
			return any
		}
		
		switch evaluateValue(add_exp: rel_exp_binary.rhs) {
		case let .SuccessValue(integerVal as IntegerValue, _ as IntegerType):
			rhs = integerVal
		case .SuccessValue(_, _):
			return .TypeMissmatch
		case let any:
			return any
		}
		
		var value: Bool
		switch rel_exp_binary.op {
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
		
		return .SuccessValue(value: BooleanValue(value: value), type: BooleanType())
	}
	
	// MARK: Add
	
	func evaluateValue(add_exp: Add_Exp) -> REPLResult {
		if let add_exp_binary = add_exp as? Add_Exp_Binary {
			return evaluateValue(add_exp_binary: add_exp_binary)
		}
		if let mul_exp = add_exp as? Mul_Exp {
			return evaluateValue(mul_exp: mul_exp)
		}
		
		return .NotExhaustive
	}
	
	func evaluateValue(add_exp_binary: Add_Exp_Binary) -> REPLResult {
		var lhs: IntegerValue
		var rhs: IntegerValue
		
		switch evaluateValue(add_exp: add_exp_binary.lhs) {
		case let .SuccessValue(integerVal as IntegerValue, _ as IntegerType):
			lhs = integerVal
		case .SuccessValue(_, _):
			return .TypeMissmatch
		case let any:
			return any
		}
		
		switch evaluateValue(mul_exp: add_exp_binary.rhs) {
		case let .SuccessValue(integerVal as IntegerValue, _ as IntegerType):
			rhs = integerVal
		case .SuccessValue(_, _):
			return .TypeMissmatch
		case let any:
			return any
		}
		
		var value: Int
		switch add_exp_binary.op {
		case .PLUS:
			value = lhs.value + rhs.value
		case .MINUS:
			value = lhs.value - rhs.value
		}
		
		return .SuccessValue(value: IntegerValue(value: value), type: IntegerType())
	}
	
	// MARK: Mul
	
	func evaluateValue(mul_exp: Mul_Exp) -> REPLResult {
		if let mul_exp_binary = mul_exp as? Mul_Exp_Binary {
			return evaluateValue(mul_exp_binary: mul_exp_binary)
		}
		if let unary_exp = mul_exp as? Unary_Exp {
			return evaluateValue(unary_exp: unary_exp)
		}
		
		return .NotExhaustive
	}
	
	func evaluateValue(mul_exp_binary: Mul_Exp_Binary) -> REPLResult {
		var lhs: IntegerValue
		var rhs: IntegerValue
		
		switch evaluateValue(mul_exp: mul_exp_binary.lhs) {
		case let .SuccessValue(integerVal as IntegerValue, _ as IntegerType):
			lhs = integerVal
		case .SuccessValue(_, _):
			return .TypeMissmatch
		case let any:
			return any
		}
		
		switch evaluateValue(unary_exp: mul_exp_binary.rhs) {
		case let .SuccessValue(integerVal as IntegerValue, _ as IntegerType):
			rhs = integerVal
		case .SuccessValue(_, _):
			return .TypeMissmatch
		case let any:
			return any
		}
		
		var value: Int
		switch mul_exp_binary.op {
		case .STAR:
			value = lhs.value * rhs.value
		case .SLASH:
			value = lhs.value / rhs.value
		case .PERCENT:
			value = lhs.value % rhs.value
		}
		
		return .SuccessValue(value: IntegerValue(value: value), type: IntegerType())
	}
	
	// MARK: Unary
	
	func evaluateValue(unary_exp: Unary_Exp) -> REPLResult {
		if let unary_exp_impl = unary_exp as? Unary_Exp_Impl {
			return evaluateRefToValue(unary_exp_impl: unary_exp_impl)
		}
		if let primary_exp = unary_exp as? Primary_Exp {
			return evaluateRefToValue(primary_exp: primary_exp)
		}
		
		return .NotExhaustive
	}
	
	func evaluateRefToValue(unary_exp_impl: Unary_Exp_Impl) -> REPLResult {
		let eval = evaluateRefToValue(unary_exp: unary_exp_impl.rhs)
		
		if case .SuccessReference(let ref, let ty as IntegerType) = eval {
			cpu.rhsRegister = ref
			switch unary_exp_impl.op {
			case .PLUS:
				cpu.unaryPlus()
			case .MINUS:
				cpu.unaryMinus()
			default:
				return .WrongOperator(op: unary_exp_impl.op.rawValue, type: IntegerType())
			}
			return .SuccessReference(ref: cpu.resultRegister, type: IntegerType())
		if case .SuccessReference(let ref, let ty as IntegerType) = eval {
			cpu.rhsRegister = ref
			switch unary_exp_impl.op {
			case .LOGNOT:
				cpu.unaryLogNot()
			default:
				return .WrongOperator(op: unary_exp_impl.op.rawValue, type: BooleanType())
			}
			return .SuccessReference(ref: cpu.resultRegister, type: BooleanType())
		}
		
		return .TypeMissmatch
	}
	
	// MARK: Primary
	
	func evaluateRefToValue(primary_exp: Primary_Exp) -> REPLResult {
		if let primary_exp_nil = primary_exp as? Primary_Exp_Nil {
			return evaluateRefToValue(primary_exp_nil: primary_exp_nil)
		}
		if let primary_exp_exp = primary_exp as? Primary_Exp_Exp {
			return evaluateRefToValue(primary_exp_exp: primary_exp_exp)
		}
		if let primary_exp_integer = primary_exp as? Primary_Exp_Integer {
			return evaluateRefToValue(primary_exp_integer: primary_exp_integer)
		}
		if let primary_exp_character = primary_exp as? Primary_Exp_Character {
			return evaluateRefToValue(primary_exp_character: primary_exp_character)
		}
		if let primary_exp_boolean = primary_exp as? Primary_Exp_Boolean {
			return evaluateRefToValue(primary_exp_boolean: primary_exp_boolean)
		}
		if let primary_exp_string = primary_exp as? Primary_Exp_String {
			return evaluateRefToValue(primary_exp_string: primary_exp_string)
		}
		if let primary_exp_sizeof = primary_exp as? Primary_Exp_Sizeof {
			return evaluateRefToValue(primary_exp_sizeof: primary_exp_sizeof)
		}
		if let primary_exp_var = primary_exp as? Var {
			return evaluateRefToValue(_var: primary_exp_var)
		}
		if let primary_exp_call = primary_exp as? Primary_Exp_Call {
			return evaluateRefToValue(primary_exp_call: primary_exp_call)
		}
		if let new_obj_spec = primary_exp as? New_Obj_Spec {
			return evaluateRefToValue(new_obj_spec: new_obj_spec)
		}
		
		return .NotExhaustive
	}
	
	func evaluateRefToValue(primary_exp_nil: Primary_Exp_Nil) -> REPLResult {
		return .SuccessReference(ref: ReferenceValue.null(), type: ReferenceType())
	}
	
	func evaluateRefToValue(primary_exp_exp: Primary_Exp_Exp) -> REPLResult {
		return evaluateRefToValue(exp: primary_exp_exp.exp)
	}
	func evaluateRefToValue(primary_exp_integer: Primary_Exp_Integer) -> REPLResult {
		let ref = globalEnvironment.malloc(size: 1)
		globalEnvironment.heapSet(value: IntegerValue(value: primary_exp_integer.value), addr: ref)
		
		return .SuccessReference(ref: ref, type: IntegerType())
	}
	
	func evaluateRefToValue(primary_exp_character: Primary_Exp_Character) -> REPLResult {
		let ref = globalEnvironment.malloc(size: 1)
		globalEnvironment.heapSet(value: CharacterValue(value: primary_exp_character.value), addr: ref)
		
		return .SuccessReference(ref: ref, type: CharacterType())
	}
	
	func evaluateRefToValue(primary_exp_boolean: Primary_Exp_Boolean) -> REPLResult {
		let ref = globalEnvironment.malloc(size: 1)
		globalEnvironment.heapSet(value: BooleanValue(value: primary_exp_boolean.value), addr: ref)
		
		return .SuccessReference(ref: ref, type: BooleanType())
	}
	
	func evaluateRefToValue(primary_exp_string: Primary_Exp_String) -> REPLResult {
		return .NotImplemented
	}
	
	func evaluateRefToValue(primary_exp_sizeof: Primary_Exp_Sizeof) -> REPLResult {
		return .NotImplemented
	}
	
	func evaluateRefToValue(primary_exp_call: Primary_Exp_Call) -> REPLResult {
		return evaluateStm(call_stm: Call_Stm(ident: primary_exp_call.ident, args: primary_exp_call.args))
	}
	
	func evaluateRefToValue(new_obj_spec: New_Obj_Spec) -> REPLResult {
		return .NotImplemented
	}
	
	// MARK: Var Value
	
	func evaluateRefToValue(_var: Var) -> REPLResult {
		if let var_ident = _var as? Var_Ident {
			return evaluateRefToValue(var_ident: var_ident)
		}
		
		return .NotExhaustive
	}
	
	func evaluateRefToValue(var_ident: Var_Ident) -> REPLResult {
		return evaluateRefToValue(identifier: var_ident.ident)
	}
	
	func evaluateRefToValue(identifier: String) -> REPLResult {
		if let ref = globalEnvironment.findReferenceOfVariable(ident: identifier) {
			if let ty = globalEnvironment.findTypeOfVariable(ident: identifier) {
				return .SuccessReference(ref: ref, type: ty)
			}
			return .UnresolvableType(ident: identifier)
		}
		return .UnresolvableReference(ident: identifier)
	}
}
