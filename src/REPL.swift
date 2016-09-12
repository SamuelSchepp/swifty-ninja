//
//  REPL.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 10/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

class REPL {
	let evaluator = Evaluator()
	
	func handle(input: String) -> REPLResult {
		let tokenizer = Tokenizer(with: input)
		
		guard let tokens = tokenizer.tokenize() else { return REPLResult.TokenError }
		
		guard let ast = parse(tokens: tokens) else { return REPLResult.ParseError(tokens: tokens) }
		
		return evaluator.evaluate(ast: ast)
		
	}
	
	private func parse(tokens: [Token]) -> ASTNode? {
		// Gvar Dec
        if let ast = parseWithFunction(tokens: tokens, function: { return $0.parse_Gvar_Dec() }) {
            return ast
        }
        
        // Func Dec
        if let ast = parseWithFunction(tokens: tokens, function: { return $0.parse_Func_Dec() }) {
            return ast
        }
        
        // Type Dec
        if let ast = parseWithFunction(tokens: tokens, function: { return $0.parse_Type_Dec() }) {
            return ast
        }
		
		// Stm
		if let stms = parseWithFunction(tokens: tokens, function: { return $0.parse_Stms() }) {
			return stms
		}
		
		// Exp
		if let ast = parseWithFunction(tokens: tokens, function: { return $0.parse_Exp() }) {
			return ast
		}
        
        // Type
        if let ast = parseWithFunction(tokens: tokens, function: { return $0.parse_Type() }) {
            return ast
        }
        
        // Program
        if let ast = parseWithFunction(tokens: tokens, function: { return $0.parse_Program() }) {
            return ast
        }
		
		return .none
	}
	
	private func parseWithFunction(tokens: [Token], function: (Parser) -> ASTNode?) -> ASTNode? {
		let parser = Parser(with: tokens)
		
		guard let ast = function(parser) else { return .none }
		if !parser.isDone() { return .none }
		
		return ast
	}
	
	func dump() {
		evaluator.dump()
	}
}
