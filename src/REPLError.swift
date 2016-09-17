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
	TypeMissmatch(expected: String, context: String),
	WrongOperator(op: String, type: Type),
	ParameterMissmatch,
	LocalVarDeclareInGlobalContext,
    MainNotFound,
	
	NotImplemented(msg: String),
	NotExhaustive(msg: String),
	
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
		case .TypeMissmatch(let expected, let context):
			return "Type missmatch, expected: \"\(expected)\", context: \"\(context)\""
		case .WrongOperator(let op, let val):
			return "Wrong operator: \(op) on \(val)"
		case .ParameterMissmatch:
			return "Parameter missmatch"
		case .LocalVarDeclareInGlobalContext:
			return "Local variable declaration in global context"
        case .MainNotFound:
            return "Main function not found"
			
		case .NotImplemented(let msg):
			return "Not implemented \"\(msg)\""
		case .NotExhaustive(let msg):
			return "Not exhaustive \"\(msg)\""
			
		case .ParseError:
			return "Parse error\n"
		case .TokenError:
			return "Token error"
		}
	}
}
