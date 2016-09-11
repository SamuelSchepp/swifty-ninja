//
//  Evaluator$Reference.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 11/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

extension Evaluator {
	func evaluateReference(_var: Var) -> REPLResult {
		if let var_ident = _var as? Var_Ident {
			return evaluateReference(var_ident: var_ident)
		}
		
		return .NotExhaustive
	}
	
	func evaluateReference(var_ident: Var_Ident) -> REPLResult {
		return evaluateReference(identifier: var_ident.ident)
	}
	
	func evaluateReference(identifier: String) -> REPLResult {
		if let ref = globalEnvironment.variables[identifier] {
			return .SuccessValue(value: ref, type: ReferenceType())
		}
		return .UnresolvableReference(ident: identifier)
	}
}
