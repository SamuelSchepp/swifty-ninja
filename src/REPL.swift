//
//  REPL.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 10/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

enum REPLResult: CustomStringConvertible { case
    SuccessObject(object: Object),
	
    UnresolvableIdentifier(ident: String),
	TypeMissmatch,
    WrongOperator(op: String, object: Object),
    
	NotImplemented,
	NotExhaustive,
    
    ParseError(tokens: [Token]),
	TokenError
	
	var description : String {
		switch self {
		case .SuccessObject(let obj):
			return "\(obj)"
            
		case .UnresolvableIdentifier(let id):
			return "Unresolvable identifier \"\(id)\""
		case .TypeMissmatch:
			return "Type missmatch"
        case .WrongOperator(let op, let obj):
            return "Wrong operator: \(op) on \(obj)"
            
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

class REPL {
	private let evaluator = Evaluator()
	
	func handle(input: String) -> REPLResult {
		let tokenizer = Tokenizer(with: input)
		
		guard let tokens = tokenizer.tokenize() else { return REPLResult.TokenError }
		
		guard let node = parse(tokens: tokens) else { return REPLResult.ParseError(tokens: tokens) }
		
		return evaluator.evaluate(node: node)
		
	}
	
	private func parse(tokens: [Token]) -> ASTNode? {
		// Type_Dec
		if let ast = parseWithFunction(tokens: tokens, function: { return $0.parse_Type_Dec() }) {
			return ast
		}
		
		// Exp
		if let ast = parseWithFunction(tokens: tokens, function: { return $0.parse_Exp() }) {
			return ast
		}
		
		// Type
		if let ast = parseWithFunction(tokens: tokens, function: { return $0.parse_Type() }) {
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
}
