//
//  Helper.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 09/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation
import XCTest

class Helper {
	class func check(_ parserFunction: (Parser) -> ASTNode?, map: [String: ASTNode]) {
		map.forEach { source, target in
			print("==== Source ====")
			print(source)
			
			let tokenizer = Tokenizer(with: source)
			guard let tokens = tokenizer.tokenize() else { XCTFail(); return }
			
			print("==== Tokens ====")
			tokens.forEach({ print($0) })
			
			let parser = Parser(with: tokens)
			
			if let type_dec = parserFunction(parser) {
				if !parser.isDone() { XCTFail() }
				print("==== AST ====")
				print(type_dec)
				print()
				XCTAssertEqual(String(reflecting: target), String(reflecting: type_dec))
			}
			else {
				XCTFail()
			}
		}
	}
}
