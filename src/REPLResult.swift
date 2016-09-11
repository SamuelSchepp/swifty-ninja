//
//  REPLResult.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 11/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

enum REPLResult: CustomStringConvertible { case
	SuccessValue(value: Value, type: Type),
	SuccessType(type: Type),
	SuccessVoid,
	SuccessDeclaration,
	
	UnresolvableValue(ident: String),
	UnresolvableReference(ident: String),
	UnresolvableType(ident: String),
	
	BreakInstr,
	ReturnValue(value: Value, type: Type),
	ReturnVoid,
	
	NullPointer,
	HeapBoundsFault,
	
	Redeclaration(ident: String),
	TypeMissmatch,
	WrongOperator(op: String, type: Type),
	ParameterMissmatch,
	LocalVarDeclareInGlobalContext,
	
	NotImplemented,
	NotExhaustive,
	
	ParseError(tokens: [Token]),
	TokenError

	var description : String {
		switch self {
		case .SuccessValue(let val, let ty):
			return "\(val) (\(ty))"
		case .SuccessType(let ty):
			return "\(ty)"
		case .SuccessVoid:
			return "<Void>"
		case .SuccessDeclaration:
			return "<Declaration>"
			
		case .UnresolvableValue(let ident):
			return "Unresolvable value of identifier \"\(ident)\""
		case .UnresolvableReference(let ident):
			return "Unresolvable reference of identifier \"\(ident)\""
		case .UnresolvableType(let ident):
			return "Unresolvable type of identifier \"\(ident)\""
			
		case .BreakInstr:
			return "Break instruction"
		case .ReturnValue(let val, let ty):
			return "\(val) (\(ty))"
		case .ReturnVoid:
			return "<Void>"
			
		case .NullPointer:
			return "Null Reference"
		case .HeapBoundsFault:
			return "Heap Bounds Fault"
			
		case .Redeclaration(let ident):
			return "Redeclaration of \"\(ident)\""
		case .TypeMissmatch:
			return "Type missmatch"
		case .WrongOperator(let op, let val):
			return "Wrong operator: \(op) on \(val)"
		case .ParameterMissmatch:
			return "Parameter missmatch"
		case .LocalVarDeclareInGlobalContext:
			return "Local variable declaration in global context"
			
		case .NotImplemented:
			return "Not implemented"
		case .NotExhaustive:
			return "Not exhaustive"
			
		case .ParseError(let tokens):
			return "Parse error\n\(tokens)"
		case .TokenError:
			return "Token error"
		}
	}
}
