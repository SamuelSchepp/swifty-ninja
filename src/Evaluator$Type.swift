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
		var memb = [String: Type]()
		
		try recordTypeExpression.memb_decs.forEach({memb_dec in
			memb[memb_dec.ident] = try evaluateType(typeExpression: memb_dec.type)
		})
		
		return RecordType(fields: memb)
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
}
