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
	
	func evaluateStm(stm: Stm) throws {
		if let stms = stm as? Stms {
			try evaluateStm(stms: stms)
			return
		}
		if let empty_stm = stm as? Empty_Stm {
			try evaluateStm(empty_stm: empty_stm)
			return
		}
		if let compound_stm = stm as? Compound_Stm {
			try evaluateStm(compound_stm: compound_stm)
			return
		}
		if let assign_stm = stm as? Assign_Stm {
			try evaluateStm(assign_stm: assign_stm)
			return
		}
		if let if_stm = stm as? If_Stm {
			try evaluateStm(if_stm: if_stm)
			return
		}
		if let while_stm = stm as? While_Stm {
			try evaluateStm(while_stm: while_stm)
			return
		}
		if let do_stm = stm as? Do_Stm {
			try evaluateStm(do_stm: do_stm)
			return
		}
		if let break_stm = stm as? Break_Stm {
			try evaluateStm(break_stm: break_stm)
			return
		}
		if let call_stm = stm as? Call_Stm {
			_ = try evaluateStm(call_stm: call_stm)
			return
		}
		if let return_stm = stm as? Return_Stm {
			try evaluateStm(return_stm: return_stm)
			return
		}
		
		throw REPLError.NotExhaustive
	}
	
	func evaluateStm(empty_stm: Empty_Stm) throws {
		
	}
	
	func evaluateStm(compound_stm: Compound_Stm) throws {
		for i in 0..<compound_stm.stms.stms.count {
			let stm = compound_stm.stms.stms[i]
			try evaluateStm(stm: stm)
		}
	}
	
	func evaluateStm(stms: Stms) throws {
		try evaluateStm(compound_stm: Compound_Stm(stms: stms))
	}
	
	func evaluateStm(assign_stm: Assign_Stm) throws {
		let ref = try evaluateRefToValue(exp: assign_stm.exp)
	
		if let var_ident = assign_stm._var as? Var_Ident {
			return try evaluateVarIdentAssignStm(var_ident: var_ident, refRHS: ref)
		}
		
		throw REPLError.NotImplemented
	}
	
	func evaluateVarIdentAssignStm(var_ident: Var_Ident, refRHS: ReferenceValue) throws {
		globalEnvironment.resetVarRef(ident: var_ident.ident, value: refRHS)
	}
	
	func evaluateStm(if_stm: If_Stm) throws {
		let ref = try evaluateRefToValue(exp: if_stm.exp)
		if try cpu.isTrue(addr: ref) {
			try evaluateStm(stm: if_stm.stm)
		}
		else {
			if let else_ = if_stm.elseStm {
				try evaluateStm(stm: else_)
			}
		}
	}
	
	func evaluateStm(while_stm: While_Stm) throws {
		while(true) {
			let condiRef = try evaluateRefToValue(exp: while_stm.exp)
			if try cpu.isTrue(addr: condiRef) {
				do {
					try evaluateStm(stm: while_stm.stm)
				}
				catch let err {
					if case REPLControlFlow.Break = err {
						break;
					}
					else {
						throw err
					}
				}
			}
			else {
				break
			}
		}
	}
	
	func evaluateStm(do_stm: Do_Stm) throws {
		while(true) {
			do {
				try evaluateStm(stm: do_stm.stm)
			}
			catch let err {
				if case REPLControlFlow.Break = err {
					break;
				}
				else {
					throw err
				}
			}
			
			let condiRef = try evaluateRefToValue(exp: do_stm.exp)
			if !(try cpu.isTrue(addr: condiRef)) {
				break
			}
		}
	}
	
	func evaluateStm(break_stm: Break_Stm) throws {
		throw REPLControlFlow.Break
	}
	
	func evaluateStm(return_stm: Return_Stm) throws {
		if let exp = return_stm.exp {
			let ref = try evaluateRefToValue(exp: exp)
			throw REPLControlFlow.ReturnValue(ref: ref)
		}
		throw REPLControlFlow.ReturnVoid
	}
	
	func evaluateStm(call_stm: Call_Stm) throws -> ReferenceValue {
		guard let function = globalEnvironment.functions[call_stm.ident] else {
			throw REPLError.UnresolvableReference(ident: call_stm.ident)
		}
		
		if call_stm.args.count != function.par_decs.count {
			throw REPLError.ParameterMissmatch
		}
		
		let localEnvironment = LocalEnvironment()
		
		/* check parameter */
		for i in 0..<call_stm.args.count {
			
			/* evaluate value and type of parameter */
			let argRef = try evaluateRefToValue(exp: call_stm.args[i].exp)
			let type = try evaluateType(typeExpression: function.par_decs[i].type)
				
			/* put ref in local environment */
			localEnvironment.variables[function.par_decs[i].ident] = argRef
			
			/* put type in local environment */
			localEnvironment.varTypeMap[function.par_decs[i].ident] = type
		}
		
		globalEnvironment.localStack.push(value: localEnvironment)
		
		do {
			try runFunction(function: function)
		}
		catch let err {
			if case REPLControlFlow.ReturnValue(let val) = err {
				_ = globalEnvironment.localStack.pop()
				return val
			}
			if case REPLControlFlow.ReturnVoid = err {
				_ = globalEnvironment.localStack.pop()
				return ReferenceValue.null()
			}
			throw err
		}
		return ReferenceValue.null()
	}
	
	func runFunction(function: Function) throws {
        if let user_func = function as? UserFunction {
            try user_func.func_dec.lvar_decs.forEach { lvar_dec in
                _ = try evaluate(lvar_dec: lvar_dec)
            }
		
            try evaluateStm(stms: user_func.func_dec.stms)
			return
        }
		if let system_func = function as? SystemFunction {
			try system_func.callee(globalEnvironment)
			return
		}
        
        throw REPLError.NotExhaustive
	}
	
	func evaluate(lvar_dec: Lvar_Dec) throws {
		let type = try evaluateType(typeExpression: lvar_dec.type)
		if globalEnvironment.localStack.hasElements() {
			globalEnvironment.localStack.peek()!.varTypeMap[lvar_dec.ident] = type
			globalEnvironment.localStack.peek()!.variables[lvar_dec.ident] = ReferenceValue.null()
		}
		else {
			throw REPLError.LocalVarDeclareInGlobalContext
		}
	}
}
