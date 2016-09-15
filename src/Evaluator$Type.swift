//
//  Evaluator$Type.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 11/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

extension Evaluator {
	// MARK: Type
	
	func evaluateType(typeExpression: TypeExpression) throws -> Type {
		if let identifierTypeExpression = typeExpression as? IdentifierTypeExpression {
			return try evaluateType(identifierTypeExpression: identifierTypeExpression)
		}
		if let arrayTypeExpression = typeExpression as? ArrayTypeExpression {
			return try evaluateType(arrayTypeExpression: arrayTypeExpression)
		}
		if let recordTypeExpression = typeExpression as? RecordTypeExpression {
			return try evaluateType(recordTypeExpression: recordTypeExpression)
		}
		
		throw REPLError.NotExhaustive
	}
	
	func evaluateType(identifierTypeExpression: IdentifierTypeExpression) throws -> Type {
		return try evaluateType(typeExpressionIdentifier: identifierTypeExpression.ident)
	}
	
	func evaluateType(arrayTypeExpression: ArrayTypeExpression) throws -> Type {
		let baseType = try evaluateType(typeExpressionIdentifier: arrayTypeExpression.ident)
		return ArrayType(base: baseType, dims: arrayTypeExpression.dims)
	}
	
	func evaluateType(typeExpressionIdentifier: String) throws -> Type {
		if let ty = globalEnvironment.typeDecMap[typeExpressionIdentifier] {
			return ty
		}
		throw REPLError.UnresolvableType(ident: typeExpressionIdentifier)
	}
	
	func evaluateType(recordTypeExpression: RecordTypeExpression) throws -> Type {
		var idents = [String]()
		var types = [Type]()
		
		try recordTypeExpression.memb_decs.forEach({memb_dec in
			idents.append(memb_dec.ident)
			types.append(try evaluateType(typeExpression: memb_dec.type))
		})
		
		return RecordType(fieldIdents: idents, fieldTypes: types)
	}
	
	func evaluateType(primary_exp: Primary_Exp) throws -> Type {
		if let _ = primary_exp as? Primary_Exp_Nil {
			return VoidType()
		}
		if let _ = primary_exp as? Primary_Exp_Exp {
			throw REPLError.NotImplemented
		}
		if let _ = primary_exp as? Primary_Exp_Integer {
			return IntegerType()
		}
		if let _ = primary_exp as? Primary_Exp_Character {
			return CharacterType()
		}
		if let _ = primary_exp as? Primary_Exp_Boolean {
			return BooleanType()
		}
		if let _ = primary_exp as? Primary_Exp_String {
			return ArrayType(base: CharacterType(), dims: 1)
		}
		if let _ = primary_exp as? Primary_Exp_Sizeof {
			return IntegerType()
		}
		if let primary_exp_var = primary_exp as? Var {
			return try evaluateType(_var: primary_exp_var)
		}
		if let primary_exp_call = primary_exp as? Primary_Exp_Call {
			return try evaluateType(primary_exp_call: primary_exp_call)
		}
		if let _ = primary_exp as? New_Obj_Spec {
			throw REPLError.NotImplemented
		}
		
		throw REPLError.NotExhaustive
	}
	
	// Mark: Var Type
	
	func evaluateType(_var: Var) throws -> Type {
		if let var_ident = _var as? Var_Ident {
			return try evaluateType(var_ident: var_ident)
		}
		
		throw REPLError.NotExhaustive
	}
	
	func evaluateType(var_ident: Var_Ident) throws -> Type {
		return try globalEnvironment.findTypeOfVariable(ident: var_ident.ident)
	}
	
	/* Call */
	
	func evaluateType(primary_exp_call: Primary_Exp_Call) throws -> Type {
		guard let function = globalEnvironment.functions[primary_exp_call.ident] else {
			throw REPLError.UnresolvableReference(ident: primary_exp_call.ident)
		}
		if let type = function.type {
			return try evaluateType(typeExpression: type)
		}
		else {
			throw REPLError.TypeMissmatch
		}
	}
}
