//
//  Evaluator$Value.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 11/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation
import SwiftyNinjaLang
import SwiftyNinjaRuntime

extension Evaluator {
	
	// MARK: Exp
	
	func evaluateRefToValue(exp: Exp) throws -> ReferenceValue {
		if let or_exp = exp as? Or_Exp {
			return try evaluateRefToValue(or_exp: or_exp)
		}
		
		throw REPLError.NotExhaustive(msg: "Exp")
	}
	
	// MARK: Or
	
	func evaluateRefToValue(or_exp: Or_Exp) throws -> ReferenceValue {
		if let or_exp_binary = or_exp as? Or_Exp_Binary {
			return try evaluateRefToValue(or_exp_binary: or_exp_binary)
		}
		if let and_exp = or_exp as? And_Exp {
			return try evaluateRefToValue(and_exp: and_exp)
		}
		
		throw REPLError.NotExhaustive(msg: "Or_Exp")
	}
	
	func evaluateRefToValue(or_exp_binary: Or_Exp_Binary) throws -> ReferenceValue {
        let leftRef = try evaluateRefToValue(or_exp: or_exp_binary.lhs)
		guard let left = try globalEnvironment.heap.get(addr: leftRef) as? BooleanValue else {
			throw REPLError.TypeMissmatch(expected: "BooleanValue", context: "booleanOr")
		}
		
		if(left.value) {
			let ref = try globalEnvironment.heap.malloc(size: 1)
			let value = BooleanValue(value: true)
			try globalEnvironment.heap.set(value: value, addr: ref)
			return ref
		}
		
        let rightRef = try evaluateRefToValue(and_exp: or_exp_binary.rhs)
		guard let right = try globalEnvironment.heap.get(addr: rightRef) as? BooleanValue else {
			throw REPLError.TypeMissmatch(expected: "BooleanValue", context: "booleanOr")
		}
		
		let ref = try globalEnvironment.heap.malloc(size: 1)
		let value = BooleanValue(value: left.value || right.value)
		try globalEnvironment.heap.set(value: value, addr: ref)
		return ref
	}
	
	// MARK: And
	
	func evaluateRefToValue(and_exp: And_Exp) throws -> ReferenceValue {
		if let and_exp_binary = and_exp as? And_Exp_Binary {
			return try evaluateRefToValue(and_exp_binary: and_exp_binary)
		}
		if let rel_exp = and_exp as? Rel_Exp {
			return try evaluateRefToValue(rel_exp: rel_exp)
		}
		
		throw REPLError.NotExhaustive(msg: "And_Exp")
	}
	
	func evaluateRefToValue(and_exp_binary: And_Exp_Binary) throws -> ReferenceValue {
        let leftRef = try evaluateRefToValue(and_exp: and_exp_binary.lhs)
		guard let left = try globalEnvironment.heap.get(addr: leftRef) as? BooleanValue else {
			throw REPLError.TypeMissmatch(expected: "BooleanValue", context: "booleanAnd")
		}
		
		if(!left.value) {
			let ref = try globalEnvironment.heap.malloc(size: 1)
			let value = BooleanValue(value: false)
			try globalEnvironment.heap.set(value: value, addr: ref)
			return ref
		}
		
        let rightRef = try evaluateRefToValue(rel_exp: and_exp_binary.rhs)
		guard let right = try globalEnvironment.heap.get(addr: rightRef) as? BooleanValue else {
			throw REPLError.TypeMissmatch(expected: "BooleanValue", context: "booleanAnd")
		}
		
		let ref = try globalEnvironment.heap.malloc(size: 1)
		let value = BooleanValue(value: left.value && right.value)
		try globalEnvironment.heap.set(value: value, addr: ref)
		return ref
	}
	
	// MARK: Rel
	
	func evaluateRefToValue(rel_exp: Rel_Exp) throws -> ReferenceValue {
		if let rel_exp_binary = rel_exp as? Rel_Exp_Binary {
			return try evaluateRefToValue(rel_exp_binary: rel_exp_binary)
		}
		if let add_exp = rel_exp as? Add_Exp {
			return try evaluateRefToValue(add_exp: add_exp)
		}
		
		throw REPLError.NotExhaustive(msg: "Rel_Exp")
	}
	
	func evaluateRefToValue(rel_exp_binary: Rel_Exp_Binary) throws -> ReferenceValue {
        let leftRef = try evaluateRefToValue(add_exp: rel_exp_binary.lhs)
		let rightRef = try evaluateRefToValue(add_exp: rel_exp_binary.rhs)
		
		switch rel_exp_binary.op {
		case .EQ:
			return try cpu.relEQ(leftRef: leftRef, rightRef: rightRef)
		case .NE:
			return try cpu.relNE(leftRef: leftRef, rightRef: rightRef)
		case .LT:
			return try cpu.relLT(leftRef: leftRef, rightRef: rightRef)
		case .LE:
			return try cpu.relLE(leftRef: leftRef, rightRef: rightRef)
		case .GT:
			return try cpu.relGT(leftRef: leftRef, rightRef: rightRef)
		case .GE:
			return try cpu.relGE(leftRef: leftRef, rightRef: rightRef)
		}
	}
	
	// MARK: Add
	
	func evaluateRefToValue(add_exp: Add_Exp) throws -> ReferenceValue {
		if let add_exp_binary = add_exp as? Add_Exp_Binary {
			return try evaluateRefToValue(add_exp_binary: add_exp_binary)
		}
		if let mul_exp = add_exp as? Mul_Exp {
			return try evaluateRefToValue(mul_exp: mul_exp)
		}
		
		throw REPLError.NotExhaustive(msg: "Add_Exp")
	}
	
	func evaluateRefToValue(add_exp_binary: Add_Exp_Binary) throws -> ReferenceValue {
        let leftRef = try evaluateRefToValue(add_exp: add_exp_binary.lhs)
		let rightRef = try evaluateRefToValue(mul_exp: add_exp_binary.rhs)
		
		switch add_exp_binary.op {
		case .PLUS:
			return try cpu.binaryPlus(leftRef: leftRef, rightRef: rightRef);
		case .MINUS:
			return try cpu.binaryMinus(leftRef: leftRef, rightRef: rightRef);
		}
	}
	
	// MARK: Mul
	
	func evaluateRefToValue(mul_exp: Mul_Exp) throws -> ReferenceValue {
		if let mul_exp_binary = mul_exp as? Mul_Exp_Binary {
			return try evaluateRefToValue(mul_exp_binary: mul_exp_binary)
		}
		if let unary_exp = mul_exp as? Unary_Exp {
			return try evaluateRefToValue(unary_exp: unary_exp)
		}
		
		throw REPLError.NotExhaustive(msg: "Mul_Exp")
	}
	
	func evaluateRefToValue(mul_exp_binary: Mul_Exp_Binary) throws -> ReferenceValue {
        let leftRef = try evaluateRefToValue(mul_exp: mul_exp_binary.lhs)
        let rightRef = try evaluateRefToValue(unary_exp: mul_exp_binary.rhs)
		
		switch mul_exp_binary.op {
		case .STAR:
			return try cpu.binaryMul(leftRef: leftRef, rightRef: rightRef);
		case .SLASH:
			return try cpu.binaryDiv(leftRef: leftRef, rightRef: rightRef);
		case .PERCENT:
			return try cpu.binaryMod(leftRef: leftRef, rightRef: rightRef);
		}
	}
	
	// MARK: Unary
	
	func evaluateRefToValue(unary_exp: Unary_Exp) throws -> ReferenceValue {
		if let unary_exp_impl = unary_exp as? Unary_Exp_Impl {
			return try evaluateRefToValue(unary_exp_impl: unary_exp_impl)
		}
		if let primary_exp = unary_exp as? Primary_Exp {
			return try evaluateRefToValue(primary_exp: primary_exp)
		}
		
		throw REPLError.NotExhaustive(msg: "Unary_Exp")
	}
	
	func evaluateRefToValue(unary_exp_impl: Unary_Exp_Impl) throws -> ReferenceValue {
		let ref = try evaluateRefToValue(unary_exp: unary_exp_impl.rhs)
		
		switch unary_exp_impl.op {
		case .PLUS:
			return try cpu.unaryPlus(unaryRef: ref)
		case .MINUS:
			return try cpu.unaryMinus(unaryRef: ref)
		case .LOGNOT:
			return try cpu.unaryLogNot(unaryRef: ref)
		}
	}
	
	// MARK: Primary
	
	func evaluateRefToValue(primary_exp: Primary_Exp) throws -> ReferenceValue {
		if let primary_exp_nil = primary_exp as? Primary_Exp_Nil {
			return try evaluateRefToValue(primary_exp_nil: primary_exp_nil)
		}
		if let primary_exp_exp = primary_exp as? Primary_Exp_Exp {
			return try evaluateRefToValue(primary_exp_exp: primary_exp_exp)
		}
		if let primary_exp_integer = primary_exp as? Primary_Exp_Integer {
			return try evaluateRefToValue(primary_exp_integer: primary_exp_integer)
		}
		if let primary_exp_character = primary_exp as? Primary_Exp_Character {
			return try evaluateRefToValue(primary_exp_character: primary_exp_character)
		}
		if let primary_exp_boolean = primary_exp as? Primary_Exp_Boolean {
			return try evaluateRefToValue(primary_exp_boolean: primary_exp_boolean)
		}
		if let primary_exp_string = primary_exp as? Primary_Exp_String {
			return try evaluateRefToValue(primary_exp_string: primary_exp_string)
		}
		if let primary_exp_sizeof = primary_exp as? Primary_Exp_Sizeof {
			return try evaluateRefToValue(primary_exp_sizeof: primary_exp_sizeof)
		}
		if let primary_exp_var = primary_exp as? Var {
			return try evaluateRefToValue(_var: primary_exp_var)
		}
		if let primary_exp_call = primary_exp as? Primary_Exp_Call {
			return try evaluateRefToValue(primary_exp_call: primary_exp_call)
		}
		if let new_obj_spec = primary_exp as? New_Obj_Spec {
			return try evaluateRefToValue(new_obj_spec: new_obj_spec)
		}
		
		throw REPLError.NotExhaustive(msg: "Primary_Exp")
	}
	
	func evaluateRefToValue(primary_exp_nil: Primary_Exp_Nil) throws -> ReferenceValue {
		return ReferenceValue.null()
	}
	
	func evaluateRefToValue(primary_exp_exp: Primary_Exp_Exp) throws -> ReferenceValue {
		return try evaluateRefToValue(exp: primary_exp_exp.exp)
	}
	
	func evaluateRefToValue(primary_exp_integer: Primary_Exp_Integer) throws -> ReferenceValue {
		let ref = try globalEnvironment.heap.malloc(size: 1)
		try globalEnvironment.heap.set(value: IntegerValue(value: primary_exp_integer.value), addr: ref)
		return ref
	}
	
	func evaluateRefToValue(primary_exp_character: Primary_Exp_Character) throws -> ReferenceValue {
		let ref = try globalEnvironment.heap.malloc(size: 1)
		try globalEnvironment.heap.set(value: CharacterValue(value: primary_exp_character.value), addr: ref)
		return ref
	}
	
	func evaluateRefToValue(primary_exp_boolean: Primary_Exp_Boolean) throws -> ReferenceValue {
        let ref = try globalEnvironment.heap.malloc(size: 1)
        try globalEnvironment.heap.set(value: BooleanValue(value: primary_exp_boolean.value), addr: ref)
		return ref
	}
	
	func evaluateRefToValue(primary_exp_string: Primary_Exp_String) throws -> ReferenceValue {
		let string = primary_exp_string.value
		let refToArray = try globalEnvironment.heap.malloc(size: string.characters.count + 1)
		try globalEnvironment.heap.set(value: SizeValue(value: string.characters.count), addr: refToArray)
		for i: Int in 0..<string.characters.count {
			let reToChar = try globalEnvironment.heap.malloc(size: 1)
			try globalEnvironment.heap.set(value: CharacterValue(value: string[string.index(string.startIndex, offsetBy: i)]), addr: reToChar)
			try globalEnvironment.heap.set(value: reToChar, addr: ReferenceValue(value: refToArray.value + i + 1))
		}
		return refToArray
	}
	
	func evaluateRefToValue(primary_exp_sizeof: Primary_Exp_Sizeof) throws -> ReferenceValue {
		let ref = try evaluateRefToValue(exp: primary_exp_sizeof.exp)
		guard let size = try globalEnvironment.heap.get(addr: ref) as? SizeValue else {
			throw REPLError.TypeMissmatch(expected: "SizeValue", context: "Primary_Exp_Sizeof")
		}
		
		let refToInt = try globalEnvironment.heap.malloc(size: 1)
		try globalEnvironment.heap.set(value: IntegerValue(value: size.value), addr: refToInt)
		
		return refToInt
	}
	
	func evaluateRefToValue(primary_exp_call: Primary_Exp_Call) throws -> ReferenceValue {
		do {
			return try evaluateStm(call_stm: Call_Stm(ident: primary_exp_call.ident, args: primary_exp_call.args))
		}
		catch let err {
			if case REPLControlFlow.ReturnValue(let ref) = err {
				return ref
			}
			if case REPLControlFlow.ReturnVoid = err{
				return ReferenceValue.null()
			}
			throw err
		}
	}
	
	func evaluateRefToValue(new_obj_spec: New_Obj_Spec) throws -> ReferenceValue {
		if let new_obj_spec_ident = new_obj_spec as? New_Obj_Spec_Ident {
			return try evaluateRefToValue(new_obj_spec_ident: new_obj_spec_ident)
		}
		if let new_obj_spec_array = new_obj_spec as? New_Obj_Spec_Array {
			return try evaluateRefToValue(new_obj_spec_array: new_obj_spec_array)
		}
		throw REPLError.NotExhaustive(msg: "New_Obj_Spec")
	}
	
	func evaluateRefToValue(new_obj_spec_ident: New_Obj_Spec_Ident) throws -> ReferenceValue {
		guard let type = try globalEnvironment.findTypeOfTypeIdentifier(ident: new_obj_spec_ident.ident) as? RecordType else { 
			throw REPLError.TypeMissmatch(expected: "RecordType", context: "New_Obj_Spec_Ident")
		}
		let ref = try globalEnvironment.heap.malloc(size: type.size + 1)
		try globalEnvironment.heap.set(value: SizeValue(value: type.size), addr: ref)
		/* init obj with null references */
		for i in 1...type.size {
			try globalEnvironment.heap.set(value: ReferenceValue.null(), addr: ReferenceValue(value: ref.value + i))
		}
		return ref;
	}
	
	func evaluateRefToValue(new_obj_spec_array: New_Obj_Spec_Array) throws -> ReferenceValue {
		let refToSize = try evaluateRefToValue(exp: new_obj_spec_array.exp)
		guard let size = try globalEnvironment.heap.get(addr: refToSize) as? IntegerValue else {
			throw REPLError.TypeMissmatch(expected: "IntegerValue", context: "new_obj_spec_array.exp")
		}
		
		let refToArray = try globalEnvironment.heap.malloc(size: size.value + 1)
		try globalEnvironment.heap.set(value: SizeValue(value: size.value), addr: refToArray)
		for i in 1...size.value {
			try globalEnvironment.heap.set(value: ReferenceValue.null(), addr: ReferenceValue(value: refToArray.value + i))
		}
		return refToArray
	}
	
	// MARK: Var Value
	
	func evaluateRefToValue(_var: Var) throws -> ReferenceValue {
		if let var_ident = _var as? Var_Ident {
			return try evaluateRefToValue(var_ident: var_ident)
		}
		if let var_field_access = _var as? Var_Field_Access {
			return try evaluateRefToValue(var_field_access: var_field_access)
		}
		if let var_array_access = _var as? Var_Array_Access {
			return try evaluateRefToValue(var_array_access: var_array_access)
		}
		
		throw REPLError.NotExhaustive(msg: "Var")
	}
	
	func evaluateRefToField(var_field_access: Var_Field_Access) throws -> ReferenceValue {
		guard let base = try evaluateType(primary_exp: var_field_access.primary_exp) as? RecordType else {
			throw REPLError.TypeMissmatch(expected: "RecordType", context: "Var_Field_Access")
		}
		let ref = try evaluateRefToValue(primary_exp: var_field_access.primary_exp)
		
		if ref.value == 0 {
			throw REPLError.NullPointer
		}
		
		/* find index based on string */
		guard let index = base.fieldIdents.index(of: var_field_access.ident) else {
			throw REPLError.UnresolvableReference(ident: var_field_access.ident)
		}
		
		return ReferenceValue(value: ref.value + index + 1)
	}
	
	func evaluateRefToField(var_array_access: Var_Array_Access) throws -> ReferenceValue {
		guard let _ = try evaluateType(primary_exp: var_array_access.primary_exp) as? ArrayType else {
			throw REPLError.TypeMissmatch(expected: "ArrayType", context: "Var_Array_Access")
		}
		let ref = try evaluateRefToValue(primary_exp: var_array_access.primary_exp)
		
		let refToIndex = try evaluateRefToValue(exp: var_array_access.brack_exp)
		guard let index = try globalEnvironment.heap.get(addr: refToIndex) as? IntegerValue else {
			throw REPLError.TypeMissmatch(expected: "IntegerValue", context: "Var_Array_Access.brack_exp")
		}
		
		return ReferenceValue(value: ref.value + index.value + 1)
	}
	
	func evaluateRefToValue(var_field_access: Var_Field_Access) throws -> ReferenceValue {
		let ref = try evaluateRefToField(var_field_access: var_field_access)
		if ref.value == ReferenceValue.null().value {
			return ref
		}
		
		guard let valRef = try globalEnvironment.heap.get(addr: ref) as? ReferenceValue else {
			throw REPLError.TypeMissmatch(expected: "ReferenceValue", context: "Var_Field_Access")
		}
		
		return valRef
	}
	
	func evaluateRefToValue(var_array_access: Var_Array_Access) throws -> ReferenceValue {
		guard let valRef = try globalEnvironment.heap.get(addr: evaluateRefToField(var_array_access: var_array_access)) as? ReferenceValue else {
			throw REPLError.TypeMissmatch(expected: "ReferenceValue", context: "Var_Array_Access")
		}
		
		return valRef
	}
	
	func evaluateRefToValue(var_ident: Var_Ident) throws -> ReferenceValue {
		return try evaluateRefToValue(identifier: var_ident.ident)
	}
	
	func evaluateRefToValue(identifier: String) throws -> ReferenceValue {
		let ref = try globalEnvironment.findReferenceOfVariable(ident: identifier)
		return ref
	}
}
