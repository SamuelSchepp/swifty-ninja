//
//  Evaluator.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 09/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation
import SwiftyNinjaLang
import SwiftyNinjaRuntime

public class Evaluator {
	public let globalEnvironment: GlobalEnvironment
	public let cpu: CPU
	
	public init() {
		globalEnvironment = GlobalEnvironment()
		cpu = CPU(globalEnvironment: globalEnvironment)
	}
	
	public func dump() {
		globalEnvironment.dump()
	}
	
	public func evaluate(ast: ASTNode) throws -> REPLResult {
		if let glob_decs = ast as? Glob_Decs {
			try evaluate(glob_decs: glob_decs)
			return .GlobDec
		}
		if let stms = ast as? Stms {
			try evaluateStm(stm: Compound_Stm(stms: stms))
			return .Stm
		}
		if let exp = ast as? Exp {
			let ref = try evaluateRefToValue(exp: exp)
			return .Exp(ref: ref)
		}
		
		throw REPLError.NotExhaustive(msg: "ASTNode")
	}
	
	// MARK: Program
	
	public func evaluate(program: Program) throws {
        for i in 0..<program.glob_decs.glob_decs.count {
			try evaluate(glob_dec: program.glob_decs.glob_decs[i])
		}
        
        try runMain()
	}
    
    public func runMain() throws {
        try evaluateStm(stm: Call_Stm(ident: "main", args: []))
    }
	
	// MARK: Glob Dec
	
	public func evaluate(glob_decs: Glob_Decs) throws {
		for i in 0..<glob_decs.glob_decs.count {
			let glob_dec = glob_decs.glob_decs[i]
			try evaluate(glob_dec: glob_dec)
		}
	}
	
	public func evaluate(glob_dec: Glob_Dec) throws {
		if let type_dec = glob_dec as? Type_Dec {
			try evaluate(type_dec: type_dec)
			return
		}
		if let gvar_dec = glob_dec as? Gvar_Dec {
			try evaluate(gvar_dec: gvar_dec)
			return
		}
		if let func_dec = glob_dec as? Func_Dec {
			try evaluate(func_dec: func_dec)
			return
		}
		
		throw REPLError.NotExhaustive(msg: "Glob_Dec")
	}
	
	// MARK: Gvar Dec
	
	public func evaluate(gvar_dec: Gvar_Dec) throws {
		if globalEnvironment.identifierExists(ident: gvar_dec.ident) {
			throw REPLError.Redeclaration(ident: "global var decl \(gvar_dec.ident)")
		}
		
		let type = try evaluateType(typeExpression: gvar_dec.type)
		globalEnvironment.varTypeMap[gvar_dec.ident] = type
		globalEnvironment.globalVariables[gvar_dec.ident] = ReferenceValue.null()
	}
    
    // MARK: Type Dec
    
    public func evaluate(type_dec: Type_Dec) throws {
        if globalEnvironment.identifierExists(ident: type_dec.ident) {
			throw REPLError.Redeclaration(ident: "type decl \(type_dec.ident)")
        }
		
        let type = try evaluateType(typeExpression: type_dec.type)
        globalEnvironment.typeDecMap[type_dec.ident] = type
    }
	
	// MARK: Func Dec
	
	public func evaluate(func_dec: Func_Dec) throws {
		if globalEnvironment.identifierExists(ident: func_dec.ident) {
			throw REPLError.Redeclaration(ident: "func \(func_dec.ident)")
		}
		
        globalEnvironment.functions[func_dec.ident] = UserFunction(func_dec: func_dec)
	}
}
