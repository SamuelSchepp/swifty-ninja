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
	
	func evaluateType(typeExpression: TypeExpression) -> REPLResult {
		if let identifierTypeExpression = typeExpression as? IdentifierTypeExpression {
			return evaluateType(identifierTypeExpression: identifierTypeExpression)
		}
		if let arrayTypeExpression = typeExpression as? ArrayTypeExpression {
			return evaluateType(arrayTypeExpression: arrayTypeExpression)
		}
		if let recordTypeExpression = typeExpression as? RecordTypeExpression {
			return evaluateType(recordTypeExpression: recordTypeExpression)
		}
		
		return .NotExhaustive
	}
	
	func evaluateType(identifierTypeExpression: IdentifierTypeExpression) -> REPLResult {
		return evaluateType(typeExpressionIdentifier: identifierTypeExpression.ident)
	}
	
	func evaluateType(arrayTypeExpression: ArrayTypeExpression) -> REPLResult {
		let identEval = evaluateType(typeExpressionIdentifier: arrayTypeExpression.ident)
		switch identEval {
		case .SuccessType(let type):
			return .SuccessType(type: ArrayType(base: type, dims: arrayTypeExpression.dims))
		default:
			return identEval
		}
	}
	
	func evaluateType(typeExpressionIdentifier: String) -> REPLResult {
		if let ty = globalEnvironment.typeDecMap[typeExpressionIdentifier] {
			return .SuccessType(type: ty)
		}
		return .UnresolvableType(ident: typeExpressionIdentifier)
	}
	
	func evaluateType(recordTypeExpression: RecordTypeExpression) -> REPLResult {
		var memb = [String: Type]()
		var error: REPLResult? = .none
		
		recordTypeExpression.memb_decs.forEach({memb_dec in
			let eval = evaluateType(typeExpression: memb_dec.type)
			switch eval {
			case .SuccessType(let t):
				memb[memb_dec.ident] = t
			default:
				error = eval
			}
		})
		
		return error ?? .SuccessType(type: RecordType(fields: memb))
	}
	
	// Mark: Var Type
	
	func evaluateType(_var: Var) -> REPLResult {
		if let var_ident = _var as? Var_Ident {
			return evaluateType(var_ident: var_ident)
		}
		
		return .NotExhaustive
	}
	
	func evaluateType(var_ident: Var_Ident) -> REPLResult {
		if let ty = globalEnvironment.varTypeMap[var_ident.ident] {
			return .SuccessType(type: ty)
		}
		return .UnresolvableType(ident: var_ident.ident)
	}
}
