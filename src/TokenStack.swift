//
//  TokenStack.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 07/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

class TokenStack {
    let stack: Stack<Token>
    
    init(tokens: [Token]) {
        stack = Stack<Token>(withList: tokens.reversed())
	}
	
	func hasTokens() -> Bool {
		return stack.hasElements()
	}
	
	// MARK: Keywords
	
    func pop_BREAK() -> Bool {
		if let peek = stack.peek(), case .BREAK = peek {
			_ = stack.pop()
			return true
		}
		return false
    }
	
	func pop_DO() -> Bool {
		if let peek = stack.peek(), case .DO = peek {
			_ = stack.pop()
			return true
		}
		return false
	}
}
