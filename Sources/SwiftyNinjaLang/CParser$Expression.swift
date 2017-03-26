//
//  CParser$Expression.swift
//  SwiftyNinja
//
//  Created by Samuel Schepp on 26/03/2017.
//
//

import Foundation
import ParserCombinators


extension CParser {
	func exp() -> Parser<Exp> {
		return or_exp()
	}
	
	func or_exp() -> Parser<Or_Exp> {
		return and_exp() ~|~ (or_exp() ~<~ "|".p ~~ and_exp()) ^^ {
			result in
			if let andexp = result.0 {
				return andexp
			}
			if let orexpbin = result.1 {
				return Or_Exp_Binary(lhs: orexpbin.0, rhs: orexpbin.1)
			}
		}
	}
	
	func and_exp() -> Parser<And_Exp> {
		
	}
	
	func rel_exp() -> Parser<Rel_Exp> {
		
	}
	
	func add_exp() -> Parser<Add_Exp> {
		
	}
	
	func mul_exp() -> Parser<Mul_Exp> {
		
	}
	
	func unary_exp() -> Parser<Unary_Exp> {
		
	}
	
	func primary_exp() -> Parser<Primary_Exp> {
		
	}
}
