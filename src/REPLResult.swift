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
	
	UnresolvableValue(ident: String),
	UnresolvableReference(ident: String),
	UnresolvableType(ident: String),
	
	NullPointer,
	HeapBoundsFault,
	
	Redeclaration(ident: String),
	TypeMissmatch,
	WrongOperator(op: String, type: Type),
	
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
			
		case .UnresolvableValue(let ident):
			return "Unresolvable value of identifier \"\(ident)\""
		case .UnresolvableReference(let ident):
			return "Unresolvable reference of identifier \"\(ident)\""
		case .UnresolvableType(let ident):
			return "Unresolvable type of identifier \"\(ident)\""
			
		case .NullPointer:
			return "Null Reference"
		case .HeapBoundsFault:
			return "Heap Bounds Fault"
			
		case .Redeclaration(let ident):
			return "Redeclaration of identifier \"\(ident)\""
		case .TypeMissmatch:
			return "Type missmatch"
		case .WrongOperator(let op, let val):
			return "Wrong operator: \(op) on \(val)"
			
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
