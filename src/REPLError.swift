//
//  REPLResult.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 11/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

enum REPLError: Error, CustomStringConvertible { case
	UnresolvableValue(ident: String),
	UnresolvableReference(ident: String),
	UnresolvableType(ident: String),
	
	BreakInstr,
	ReturnRefToValue(ref: ReferenceValue, type: Type),
	ReturnVoid,
	
	NullPointer,
	HeapBoundsFault(heapSize: Int, ref: Int),
	FatalError,
	
	Redeclaration(ident: String),
	TypeMissmatch,
	WrongOperator(op: String, type: Type),
	ParameterMissmatch,
	LocalVarDeclareInGlobalContext,
    MainNotFound,
	
	NotImplemented,
	NotExhaustive,
	
	ParseError,
	TokenError

	var description : String {
		switch self {
		case .UnresolvableValue(let ident):
			return "Unresolvable value of identifier \"\(ident)\""
		case .UnresolvableReference(let ident):
			return "Unresolvable reference of identifier \"\(ident)\""
		case .UnresolvableType(let ident):
			return "Unresolvable type of identifier \"\(ident)\""
			
		case .BreakInstr:
			return "Break instruction"
		case .ReturnRefToValue(let ref, let ty):
			return "\(ref) (\(ty))"
		case .ReturnVoid:
			return "<Void>"
			
		case .NullPointer:
			return "Null Reference"
		case .HeapBoundsFault(let size, let ref):
			return "Heap Bounds Fault: Heap size: \(size), reference: \(ref)"
		case .FatalError:
			return "Fatal error"
			
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
        case .MainNotFound:
            return "Main function not found"
			
		case .NotImplemented:
			return "Not implemented"
		case .NotExhaustive:
			return "Not exhaustive"
			
		case .ParseError:
			return "Parse error\n"
		case .TokenError:
			return "Token error"
		}
	}
}
