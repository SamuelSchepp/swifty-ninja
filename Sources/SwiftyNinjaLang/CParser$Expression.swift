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
	public func exp() -> Parser<Exp> {
		return or_exp() ^^ {
			orexp in
			return orexp as Exp
		}
	}
	
	public func or_exp() -> Parser<Or_Exp> {
		return and_exp() ~|~ (or_exp() ~<~ "|".p ~~ and_exp()) ^^ {
			result in
			if let andexp = result.0 {
				return andexp
			}
			if let orexpbin = result.1 {
				return Or_Exp_Binary(lhs: orexpbin.0, rhs: orexpbin.1)
			}
			return Optional.none
		}
	}
	
	public func and_exp() -> Parser<And_Exp> {
		return rel_exp() ~|~ (and_exp() ~<~ "&".p ~~ rel_exp()) ^^ {
			result in
			if let relexp = result.0 {
				return relexp
			}
			if let andexpbin = result.1 {
				return And_Exp_Binary(lhs: andexpbin.0, rhs: andexpbin.1)
			}
			return Optional.none
		}
	}
	
	public func rel_exp() -> Parser<Rel_Exp> {
		return add_exp() ~|~ (add_exp() ~~ rel_exp_binary_op() ~~ add_exp()) ^^ {
			result in
			if let addexp = result.0 {
				return addexp
			}
			if let relbin = result.1 {
				return Rel_Exp_Binary(lhs: relbin.0.0, rhs: relbin.1, op: relbin.0.1)
			}
			return Optional.none
		}
	}
	
	public func rel_exp_binary_op() -> Parser<Rel_Exp_Binary_Op> {
		return rel_exp_binary_op_eq()
			~|~ rel_exp_binary_op_ne()
			~|~ rel_exp_binary_op_lt()
			~|~ rel_exp_binary_op_le()
			~|~ rel_exp_binary_op_gt()
			~|~ rel_exp_binary_op_ge() ^^ {
			result in
				if result.0?.0?.0?.0.
		}
	}
	
	public func rel_exp_binary_op_eq() -> Parser<Rel_Exp_Binary_Op> {
		return "==".p ^^ { _ in
			return Rel_Exp_Binary_Op.EQ
		}
	}
	
	public func rel_exp_binary_op_ne() -> Parser<Rel_Exp_Binary_Op> {
		return "!=".p ^^ { _ in
			return Rel_Exp_Binary_Op.NE
		}
	}
	
	public func rel_exp_binary_op_lt() -> Parser<Rel_Exp_Binary_Op> {
		return "<".p ^^ { _ in
			return Rel_Exp_Binary_Op.LT
		}
	}
	
	public func rel_exp_binary_op_le() -> Parser<Rel_Exp_Binary_Op> {
		return "<=".p ^^ { _ in
			return Rel_Exp_Binary_Op.LE
		}
	}
	
	public func rel_exp_binary_op_gt() -> Parser<Rel_Exp_Binary_Op> {
		return ">".p ^^ { _ in
			return Rel_Exp_Binary_Op.GT
		}
	}
	
	public func rel_exp_binary_op_ge() -> Parser<Rel_Exp_Binary_Op> {
		return ">=".p ^^ { _ in
			return Rel_Exp_Binary_Op.GE
		}
	}
	
	public func add_exp() -> Parser<Add_Exp> {
		
	}
	
	public func mul_exp() -> Parser<Mul_Exp> {
		
	}
	
	public func unary_exp() -> Parser<Unary_Exp> {
		
	}
	
	public func primary_exp() -> Parser<Primary_Exp> {
		
	}
}
