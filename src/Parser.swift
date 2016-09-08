//
//  Parser.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 08/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

class Parser {
	let stack: Stack<Token>
	
	init(tokens: [Token]) {
		stack = Stack<Token>(withList: tokens.reversed())
	}
}
