//
//  Evaluator&Stm.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 11/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

extension Evaluator {
	
	// MARK: Stm
	
	func evaluateStm(stm: Stm) -> REPLResult {
		if let assign_stm = stm as? Assign_Stm {
			return evaluateStm(assign_stm: assign_stm)
		}
		
		return .NotExhaustive
	}
	
	func evaluateStm(assign_stm: Assign_Stm) -> REPLResult {
		let typeEval = evaluateType(_var: assign_stm._var)
		let valueEval = evaluateValue(exp: assign_stm.exp)
		
		/* type check */
		if case .SuccessValue(let valRHS, let tyRHS) = valueEval {
			if case .SuccessType(let tyLHS) = typeEval {
				if tyRHS.description != tyLHS.description {
					return .TypeMissmatch
				}
				
				if let var_ident = assign_stm._var as? Var_Ident {
					return evaluateVarIdentAssignStm(var_ident: var_ident, valRHS: valRHS)
				}
				
				return .NotImplemented
			}
			else {
				return typeEval
			}
		}
		else {
			return valueEval
		}
	}
	
	func evaluateVarIdentAssignStm(var_ident: Var_Ident, valRHS: Value) -> REPLResult {
		let newAddr = globalEnvironment.malloc(size: 1)
		let success = globalEnvironment.heapSet(value: valRHS, addr: newAddr)
		if !success {
			return .HeapBoundsFault
		}
		globalEnvironment.variables[var_ident.ident] = newAddr
		
		return .SuccessVoid
	}
}
