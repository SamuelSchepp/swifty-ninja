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
	
	func handle(input: String) throws -> REPLResult {
		let tokenizer = Tokenizer(with: input)
		
		guard let tokens = tokenizer.tokenize() else { throw REPLError.TokenError }
		
		guard let ast = parse(tokens: tokens) else { throw REPLError.ParseError }
		
		let eval = try evaluator.evaluate(ast: ast)
		return eval
	}
	
	func handleAsProgram(input: String) throws -> REPLResult {
		let tokenizer = Tokenizer(with: input)
		
		guard let tokens = tokenizer.tokenize() else { throw REPLError.TokenError }
		
		guard let ast = parseWithFunction(tokens: tokens, function: { return $0.parse_Program() }) else { throw REPLError.ParseError}
		
		let eval = try evaluator.evaluate(ast: ast)
		return eval
	}
	
	private func parse(tokens: [Token]) -> ASTNode? {
		// Global Decs
        if let ast = parseWithFunction(tokens: tokens, function: { return $0.parse_Glob_Decs() }) {
            return ast
		}
		
		// Exp
		if let ast = parseWithFunction(tokens: tokens, function: { return $0.parse_Exp() }) {
			return ast
		}
		
		// Stm
		if let stms = parseWithFunction(tokens: tokens, function: { return $0.parse_Stms() }) {
			return stms
		}
		
		return .none
	}
	
	private func parseWithFunction(tokens: [Token], function: (Parser) -> ASTNode?) -> ASTNode? {
		let parser = Parser(with: tokens)
		
		guard let ast = function(parser) else { return .none }
		if !parser.isDone() {
			return .none
		}
		
		return ast
	}
	
	func dump() {
		evaluator.dump()
	}
}
