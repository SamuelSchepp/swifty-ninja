//
//  REPLResult.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 13/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

enum REPLResult: CustomStringConvertible { case
	ProgramDec,
	FuncDec,
	GvarDec,
	TypeDec,
	Stm,
	TypeExp(type: Type),
	Exp(ref: ReferenceValue)
	
	var description: String {
		get {
			switch self {
			case .ProgramDec:
				return "<Program declaration>"
			case .FuncDec:
				return "<Function declaration>"
			case .GvarDec:
				return "<Global variable declaration>"
			case .TypeDec:
				return "<Type declaraton>"
			case .Stm:
				return "<Statement>"
			case .TypeExp(let ty):
				return "<Type expression (Base type: \(ty))"
			case .Exp(let ref):
				return "<Expression (Result: \(ref)"
			}
		}
	}
}
