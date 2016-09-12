//
//  Evaluator.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 09/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation


class Evaluator {
	let globalEnvironment: GlobalEnvironment
	let cpu: CPU
	
	init() {
		globalEnvironment = GlobalEnvironment()
		cpu = CPU(globalEnvironment: globalEnvironment)
	}
	
	func dump() {
		globalEnvironment.dump()
	}
    
	// MARK: Global
	
	func evaluate(ast: ASTNode) -> REPLResult {
        if let program = ast as? Program {
            return evaluate(program: program)
        }
        if let func_dec = ast as? Func_Dec {
            return evaluate(func_dec: func_dec)
        }
        if let gvar_dec = ast as? Gvar_Dec {
            return evaluate(gvar_dec: gvar_dec)
        }
        if let type_dec = ast as? Type_Dec {
            return evaluate(type_dec: type_dec)
        }
		if let stms = ast as? Stms {
			return evaluateStm(stm: Compound_Stm(stms: stms))
		}
		if let stm = ast as? Stm {
			return evaluateStm(stm: stm)
		}
        if let typeExp = ast as? TypeExpression {
            return evaluateType(typeExpression: typeExp)
        }
		if let exp = ast as? Exp {
			return evaluateValue(exp: exp)
		}
		
		return .NotExhaustive
	}
	
	// MARK: Program
	
	func evaluate(program: Program) -> REPLResult {
        for i in 0..<program.glob_decs.count {
			let res = evaluate(glob_dec: program.glob_decs[i])
            if case .SuccessDeclaration = res {
                /* ok */
            }
            else {
                return res;
            }
		}
        
        return runMain()
	}
    
    func runMain() -> REPLResult {
        let mainEval = evaluateStm(stm: Call_Stm(ident: "main", args: []))
        
        if case .UnresolvableReference(ident: "main") = mainEval {
            return .MainNotFound
        }
        return mainEval
    }
	
	// MARK: Glob Dec
	
	func evaluate(glob_dec: Glob_Dec) -> REPLResult {
		if let type_dec = glob_dec as? Type_Dec {
			return evaluate(type_dec: type_dec)
		}
		if let gvar_dec = glob_dec as? Gvar_Dec {
			return evaluate(gvar_dec: gvar_dec)
		}
		if let func_dec = glob_dec as? Func_Dec {
			return evaluate(func_dec: func_dec)
		}
		// func_dec
		
		return .NotExhaustive
	}
	
	// MARK: Gvar Dec
	
	func evaluate(gvar_dec: Gvar_Dec) -> REPLResult {
		if globalEnvironment.identifierExists(ident: gvar_dec.ident) {
			return .Redeclaration(ident: gvar_dec.ident)
		}
		
		let tyEval = evaluateType(typeExpression: gvar_dec.type)
		if case .SuccessType(let ty) = tyEval {
			globalEnvironment.varTypeMap[gvar_dec.ident] = ty
			globalEnvironment.variables[gvar_dec.ident] = ReferenceValue.null()
			return .SuccessDeclaration
		}
		
		return tyEval
	}
    
    // MARK: Type Dec
    
    func evaluate(type_dec: Type_Dec) -> REPLResult {
        if globalEnvironment.identifierExists(ident: type_dec.ident) {
            return .Redeclaration(ident: type_dec.ident)
        }
        
        let typeEval = evaluateType(typeExpression: type_dec.type)
        switch typeEval {
        case .SuccessType(let type):
            globalEnvironment.typeDecMap[type_dec.ident] = type
            return .SuccessDeclaration
        default:
            return typeEval
        }
    }
	
	// MARK: Func Dec
	
	func evaluate(func_dec: Func_Dec) -> REPLResult {
		if globalEnvironment.identifierExists(ident: func_dec.ident) {
			return .Redeclaration(ident: func_dec.ident)
		}
		
        globalEnvironment.functions[func_dec.ident] = UserFunction(func_dec: func_dec)
		
		return .SuccessDeclaration
	}
}
