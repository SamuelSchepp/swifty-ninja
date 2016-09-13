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
	
	func evaluateRefToValue(exp: Exp) -> REPLResult {
		if let or_exp = exp as? Or_Exp {
			return evaluateRefToValue(or_exp: or_exp)
		}
		
		return .NotExhaustive
	}
	
	// MARK: Or
	
	func evaluateRefToValue(or_exp: Or_Exp) -> REPLResult {
		if let or_exp_binary = or_exp as? Or_Exp_Binary {
			return evaluateRefToValue(or_exp_binary: or_exp_binary)
		}
		if let and_exp = or_exp as? And_Exp {
			return evaluateRefToValue(and_exp: and_exp)
		}
		
		return .NotExhaustive
	}
	
	func evaluateRefToValue(or_exp_binary: Or_Exp_Binary) -> REPLResult {
        var leftRef = ReferenceValue.null()
        var rightRef = ReferenceValue.null()
        
        switch evaluateRefToValue(or_exp: or_exp_binary.lhs) {
		case let .SuccessReference(ref, _ as BooleanType):
			leftRef = ref
		case .SuccessReference(_, _):
			return .TypeMissmatch
		case let any:
			return any
		}
		
		switch evaluateRefToValue(and_exp: or_exp_binary.rhs) {
		case let .SuccessReference(ref, _ as BooleanType):
			rightRef = ref
		case .SuccessReference(_, _):
			return .TypeMissmatch
		case let any:
			return any
		}
		
		return cpu.booleanOr(leftRef: leftRef, rightRef: rightRef)
	}
	
	// MARK: And
	
	func evaluateRefToValue(and_exp: And_Exp) -> REPLResult {
		if let and_exp_binary = and_exp as? And_Exp_Binary {
			return evaluateRefToValue(and_exp_binary: and_exp_binary)
		}
		if let rel_exp = and_exp as? Rel_Exp {
			return evaluateRefToValue(rel_exp: rel_exp)
		}
		
		return .NotExhaustive
	}
	
	func evaluateRefToValue(and_exp_binary: And_Exp_Binary) -> REPLResult {
        var leftRef = ReferenceValue.null()
        var rightRef = ReferenceValue.null()
        
        switch evaluateRefToValue(and_exp: and_exp_binary.lhs) {
		case let .SuccessReference(ref, _ as BooleanType):
			leftRef = ref
		case .SuccessReference(_, _):
			return .TypeMissmatch
		case let any:
			return any
		}
		
		switch evaluateRefToValue(rel_exp: and_exp_binary.rhs) {
		case let .SuccessReference(ref, _ as BooleanType):
			rightRef = ref
		case .SuccessReference(_, _):
			return .TypeMissmatch
		case let any:
			return any
		}
		
		return cpu.booleanAnd(leftRef: leftRef, rightRef: rightRef)
	}
	
	// MARK: Rel
	
	func evaluateRefToValue(rel_exp: Rel_Exp) -> REPLResult {
		if let rel_exp_binary = rel_exp as? Rel_Exp_Binary {
			return evaluateRefToValue(rel_exp_binary: rel_exp_binary)
		}
		if let add_exp = rel_exp as? Add_Exp {
			return evaluateRefToValue(add_exp: add_exp)
		}
		
		return .NotExhaustive
	}
	
	func evaluateRefToValue(rel_exp_binary: Rel_Exp_Binary) -> REPLResult {
        var leftRef = ReferenceValue.null()
        var rightRef = ReferenceValue.null()
        
        switch evaluateRefToValue(add_exp: rel_exp_binary.lhs) {
		case let .SuccessReference(ref, _ as IntegerType):
			leftRef = ref;
		case .SuccessReference(_, _):
			return .TypeMissmatch
		case let any:
			return any
		}
		
		switch evaluateRefToValue(add_exp: rel_exp_binary.rhs) {
		case let .SuccessReference(ref, _ as IntegerType):
			rightRef = ref
		case .SuccessReference(_, _):
			return .TypeMissmatch
		case let any:
			return any
		}
		
		switch rel_exp_binary.op {
		case .EQ:
			return cpu.relEQ(leftRef: leftRef, rightRef: rightRef)
		case .NE:
			return cpu.relNE(leftRef: leftRef, rightRef: rightRef)
		case .LT:
			return cpu.relLT(leftRef: leftRef, rightRef: rightRef)
		case .LE:
			return cpu.relLE(leftRef: leftRef, rightRef: rightRef)
		case .GT:
			return cpu.relGT(leftRef: leftRef, rightRef: rightRef)
		case .GE:
			return cpu.relGE(leftRef: leftRef, rightRef: rightRef)
		}
	}
	
	// MARK: Add
	
	func evaluateRefToValue(add_exp: Add_Exp) -> REPLResult {
		if let add_exp_binary = add_exp as? Add_Exp_Binary {
			return evaluateRefToValue(add_exp_binary: add_exp_binary)
		}
		if let mul_exp = add_exp as? Mul_Exp {
			return evaluateRefToValue(mul_exp: mul_exp)
		}
		
		return .NotExhaustive
	}
	
	func evaluateRefToValue(add_exp_binary: Add_Exp_Binary) -> REPLResult {
        var leftRef = ReferenceValue.null()
        var rightRef = ReferenceValue.null()
        
        switch evaluateRefToValue(add_exp: add_exp_binary.lhs) {
		case let .SuccessReference(ref, _ as IntegerType):
			leftRef = ref
		case .SuccessReference(_, _):
			return .TypeMissmatch
		case let any:
			return any
		}
		
		switch evaluateRefToValue(mul_exp: add_exp_binary.rhs) {
		case let .SuccessReference(ref, _ as IntegerType):
			rightRef = ref
		case .SuccessReference(_, _):
			return .TypeMissmatch
		case let any:
			return any
		}
		
		switch add_exp_binary.op {
		case .PLUS:
			return cpu.binaryPlus(leftRef: leftRef, rightRef: rightRef);
		case .MINUS:
			return cpu.binaryMinus(leftRef: leftRef, rightRef: rightRef);
		}
	}
	
	// MARK: Mul
	
	func evaluateRefToValue(mul_exp: Mul_Exp) -> REPLResult {
		if let mul_exp_binary = mul_exp as? Mul_Exp_Binary {
			return evaluateRefToValue(mul_exp_binary: mul_exp_binary)
		}
		if let unary_exp = mul_exp as? Unary_Exp {
			return evaluateRefToValue(unary_exp: unary_exp)
		}
		
		return .NotExhaustive
	}
	
	func evaluateRefToValue(mul_exp_binary: Mul_Exp_Binary) -> REPLResult {
        var leftRef = ReferenceValue.null()
        var rightRef = ReferenceValue.null()
        
        let leftEval = evaluateRefToValue(mul_exp: mul_exp_binary.lhs)
		switch leftEval {
		case let .SuccessReference(ref, _ as IntegerType):
			leftRef = ref
		case .SuccessReference(_, _):
			return .TypeMissmatch
		case let any:
			return any
		}
		
        let rightEval = evaluateRefToValue(unary_exp: mul_exp_binary.rhs)
		switch rightEval {
		case let .SuccessReference(ref, _ as IntegerType):
			rightRef = ref
		case .SuccessReference(_, _):
			return .TypeMissmatch
		case let any:
			return any
		}
		
		switch mul_exp_binary.op {
		case .STAR:
			return cpu.binaryMul(leftRef: leftRef, rightRef: rightRef);
		case .SLASH:
			return cpu.binaryDiv(leftRef: leftRef, rightRef: rightRef);
		case .PERCENT:
			return cpu.binaryMod(leftRef: leftRef, rightRef: rightRef);
		}
	}
	
	// MARK: Unary
	
	func evaluateRefToValue(unary_exp: Unary_Exp) -> REPLResult {
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
		
		if case .SuccessReference(let ref, _ as IntegerType) = eval {
			switch unary_exp_impl.op {
			case .PLUS:
				return cpu.unaryPlus(unaryRef: ref)
			case .MINUS:
				return cpu.unaryMinus(unaryRef: ref)
			default:
				return .WrongOperator(op: unary_exp_impl.op.rawValue, type: IntegerType())
			}
		}
		if case .SuccessReference(let ref, _ as BooleanType) = eval {
			switch unary_exp_impl.op {
			case .LOGNOT:
				return cpu.unaryLogNot(unaryRef: ref)
			default:
				return .WrongOperator(op: unary_exp_impl.op.rawValue, type: BooleanType())
			}
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
        var newRef = ReferenceValue.null()
		let heapMallocRes = globalEnvironment.heap.malloc(size: 1)
        switch heapMallocRes {
        case .SuccessValue(let ref as ReferenceValue):
            newRef = ref
        default:
            return heapMallocRes
        }
        
        
		let heapSetRes = globalEnvironment.heap.set(value: IntegerValue(value: primary_exp_integer.value), addr: newRef)
        switch heapSetRes {
        case .SuccessVoid:
            return .SuccessReference(ref: newRef, type: IntegerType())
        default:
            return heapSetRes
        }
	}
	
	func evaluateRefToValue(primary_exp_character: Primary_Exp_Character) -> REPLResult {
        var newRef = ReferenceValue.null()
        let heapMallocRes = globalEnvironment.heap.malloc(size: 1)
        switch heapMallocRes {
        case .SuccessValue(let ref as ReferenceValue):
            newRef = ref
        default:
            return heapMallocRes
        }
        
        
        let heapSetRes = globalEnvironment.heap.set(value: CharacterValue(value: primary_exp_character.value), addr: newRef)
        switch heapSetRes {
        case .SuccessVoid:
            return .SuccessReference(ref: newRef, type: CharacterType())
        default:
            return heapSetRes
        }
	}
	
	func evaluateRefToValue(primary_exp_boolean: Primary_Exp_Boolean) -> REPLResult {
        var newRef = ReferenceValue.null()
        let heapMallocRes = globalEnvironment.heap.malloc(size: 1)
        switch heapMallocRes {
        case .SuccessValue(let ref as ReferenceValue):
            newRef = ref
        default:
            return heapMallocRes
        }
        
        
        let heapSetRes = globalEnvironment.heap.set(value: BooleanValue(value: primary_exp_boolean.value), addr: newRef)
        switch heapSetRes {
        case .SuccessVoid:
            return .SuccessReference(ref: newRef, type: BooleanType())
        default:
            return heapSetRes
        }
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
