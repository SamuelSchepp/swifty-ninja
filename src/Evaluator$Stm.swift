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
		if let stms = stm as? Stms {
			return evaluateStm(compound_stm: Compound_Stm(stms: stms))
		}
		if let empty_stm = stm as? Empty_Stm {
			return evaluateStm(empty_stm: empty_stm)
		}
		if let compound_stm = stm as? Compound_Stm {
			return evaluateStm(compound_stm: compound_stm)
		}
		if let assign_stm = stm as? Assign_Stm {
			return evaluateStm(assign_stm: assign_stm)
		}
		if let if_stm = stm as? If_Stm {
			return evaluateStm(if_stm: if_stm)
		}
		if let while_stm = stm as? While_Stm {
			return evaluateStm(while_stm: while_stm)
		}
		
		return .NotExhaustive
	}
	
	func evaluateStm(empty_stm: Empty_Stm) -> REPLResult {
		return .SuccessVoid
	}
	
	func evaluateStm(compound_stm: Compound_Stm) -> REPLResult {
		var lastEval: REPLResult = .SuccessVoid
		compound_stm.stms.stms.forEach { stm in
			let eval = evaluateStm(stm: stm)
			lastEval = eval
			if case .SuccessVoid = eval {
				/* OK */
			}
			else {
				return
			}
		}
		return lastEval
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
	
	func evaluateStm(if_stm: If_Stm) -> REPLResult {
		let expEval = evaluateValue(exp: if_stm.exp)
		if case .SuccessValue(let val as BooleanValue, _ as BooleanType) = expEval {
			if(val.value) {
				return evaluateStm(stm: if_stm.stm)
			}
			else {
				if let el_st = if_stm.elseStm {
					return evaluateStm(stm: el_st)
				}
			}
			return .SuccessVoid
		}
		if case .SuccessValue(_, _) = expEval {
			return .TypeMissmatch
		}
		
		return expEval
	}
	
	func evaluateStm(while_stm: While_Stm) -> REPLResult {
		var lastEval = REPLResult.SuccessVoid
		while(true) {
			lastEval = evaluateValue(exp: while_stm.exp)
			if case .SuccessValue(let val as BooleanValue, _ as BooleanType) = lastEval {
				lastEval = .SuccessVoid
				if(val.value) {
					lastEval = evaluateStm(stm: while_stm.stm)
				}
				else {
					return lastEval
				}
			}
			else {
				return lastEval
			}
		}
	}
}
