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
			return evaluateStm(stms: stms)
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
		if let do_stm = stm as? Do_Stm {
			return evaluateStm(do_stm: do_stm)
		}
		if let break_stm = stm as? Break_Stm {
			return evaluateStm(break_stm: break_stm)
		}
		if let call_stm = stm as? Call_Stm {
			return evaluateStm(call_stm: call_stm)
		}
		if let return_stm = stm as? Return_Stm {
			return evaluateStm(return_stm: return_stm)
		}
		return .NotExhaustive
	}
	
	func evaluateStm(empty_stm: Empty_Stm) -> REPLResult {
		return .SuccessVoid
	}
	
	func evaluateStm(compound_stm: Compound_Stm) -> REPLResult {
		for i in 0..<compound_stm.stms.stms.count {
			let stm = compound_stm.stms.stms[i]
			let eval = evaluateStm(stm: stm)
			if case .SuccessVoid = eval {
				/* OK */
			}
			else {
				return eval
			}
		}
		return .SuccessVoid
	}
	
	func evaluateStm(stms: Stms) -> REPLResult {
		return evaluateStm(compound_stm: Compound_Stm(stms: stms))
	}
	
	func evaluateStm(assign_stm: Assign_Stm) -> REPLResult {
		let typeEval = evaluateType(_var: assign_stm._var)
		let refEval = evaluateRefToValue(exp: assign_stm.exp)
		
		/* type check */
		if case .SuccessReference(let refRHS, let tyRHS) = refEval {
			if case .SuccessType(let tyLHS) = typeEval {
				if tyRHS.description != tyLHS.description {
					return .TypeMissmatch
				}
				
				if let var_ident = assign_stm._var as? Var_Ident {
					return evaluateVarIdentAssignStm(var_ident: var_ident, refRHS: refRHS)
				}
				
				return .NotImplemented
			}
			else {
				return typeEval
			}
		}
		else {
			return refEval
		}
	}
	
	func evaluateVarIdentAssignStm(var_ident: Var_Ident, refRHS: ReferenceValue) -> REPLResult {
		globalEnvironment.setVarRef(ident: var_ident.ident, value: refRHS)
		
		return .SuccessVoid
	}
	
	func evaluateStm(if_stm: If_Stm) -> REPLResult {
		let refEval = evaluateRefToValue(exp: if_stm.exp)
		if case .SuccessReference(let ref, _ as BooleanType) = refEval {
			cpu.unaryRegister = ref
			if(cpu.isTrue()) {
				return evaluateStm(stm: if_stm.stm)
			}
			else {
				if let el_st = if_stm.elseStm {
					return evaluateStm(stm: el_st)
				}
			}
			return .SuccessVoid
		}
		if case .SuccessReference(_, _) = refEval {
			return .TypeMissmatch
		}
		
		return refEval
	}
	
	func evaluateStm(while_stm: While_Stm) -> REPLResult {
		while(true) {
			let condiRef = evaluateRefToValue(exp: while_stm.exp)
			if case .SuccessReference(let ref, _ as BooleanType) = condiRef {
				cpu.unaryRegister = ref
				if(!cpu.isTrue()) {
					return .SuccessVoid
				}
			}
			else {
				return condiRef
			}
			
			let eval = evaluateStm(stm: while_stm.stm)
			if case .BreakInstr = eval {
				return .SuccessVoid
			}
			if case .ReturnRefToValue(_, _) = eval {
				return eval
			}
			if case .ReturnVoid = eval {
				return eval
			}
		}
	}
	
	func evaluateStm(do_stm: Do_Stm) -> REPLResult {
		while(true) {
			let eval = evaluateStm(stm: do_stm.stm)
			if case .BreakInstr = eval {
				return .SuccessVoid
			}
			if case .ReturnRefToValue(_, _) = eval {
				return eval
			}
			if case .ReturnVoid = eval {
				return eval
			}
			
			let condiRefEval = evaluateRefToValue(exp: do_stm.exp)
			if case .SuccessReference(let ref, _ as BooleanType) = condiRefEval {
				cpu.unaryRegister = ref
				if(!cpu.isTrue()) {
					return .SuccessVoid
				}
			}
			else {
				return condiRefEval
			}
		}
	}
	
	func evaluateStm(break_stm: Break_Stm) -> REPLResult {
		return .BreakInstr
	}
	
	func evaluateStm(return_stm: Return_Stm) -> REPLResult {
		if let exp = return_stm.exp {
			return evaluateRefToValue(exp: exp)
		}
		return .ReturnVoid
	}
	
	func evaluateStm(call_stm: Call_Stm) -> REPLResult {
		guard let function = globalEnvironment.functions[call_stm.ident] else { return .UnresolvableReference(ident: call_stm.ident) }
		if call_stm.args.count != function.par_decs.count { return .ParameterMissmatch }
		
		let localEnvironment = LocalEnvironment()
		
		/* check parameter */
		for i in 0..<call_stm.args.count {
			
			/* evaluate value and type of parameter */
			let callExpEval = evaluateRefToValue(exp: call_stm.args[i].exp)
			if case .SuccessReference(let ref, let ty) = callExpEval {
				
				/* evaluate type of parameter declaration */
				let decTypeEval = evaluateType(typeExpression: function.par_decs[i].type)
				if case .SuccessType(let ty2) = decTypeEval {
					
					/* check types */
					if ty.description == ty2.description {
						/* put ref in local environment */
						localEnvironment.variables[function.par_decs[i].ident] = ref
						
						/* put type in local environment */
						localEnvironment.varTypeMap[function.par_decs[i].ident] = ty
					}
					else {
						return .TypeMissmatch
					}
				}
				else {
					return decTypeEval
				}
			}
			else {
				return callExpEval
			}
		}
		
		globalEnvironment.localStack.push(value: localEnvironment)
		
		let result = runFunction(function: function)
		
		_ = globalEnvironment.localStack.pop()
		
		if case .ReturnRefToValue(let ref, let ty) = result {
			return .SuccessReference(ref: ref, type: ty)
		}
		if case .ReturnVoid = result {
			return .SuccessVoid
		}
		
		return result
	}
	
	func runFunction(function: Function) -> REPLResult {
        if let user_func = function as? UserFunction {
            user_func.func_dec.lvar_decs.forEach { lvar_dec in
                _ = evaluate(lvar_dec: lvar_dec)
            }
		
            return evaluateStm(stms: user_func.func_dec.stms)
        }
		if let system_func = function as? SystemFunction {
			return system_func.callee(globalEnvironment)
		}
        
        return .NotExhaustive
	}
	
	func evaluate(lvar_dec: Lvar_Dec) -> REPLResult {
		let typeEval = evaluateType(typeExpression: lvar_dec.type)
		if case .SuccessType(let ty) = typeEval {
			if globalEnvironment.localStack.hasElements() {
				globalEnvironment.localStack.peek()!.varTypeMap[lvar_dec.ident] = ty
				globalEnvironment.localStack.peek()!.variables[lvar_dec.ident] = ReferenceValue.null()
				return .SuccessDeclaration
			}
			else {
				return .LocalVarDeclareInGlobalContext
			}
		}
		return typeEval
	}
}
