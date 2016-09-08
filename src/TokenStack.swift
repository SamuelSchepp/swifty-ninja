//
//  TokenStack.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 08/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

class TokenStack {
	private let stack: Stack<Token>
	
	init(with: [Token]) {
		stack = Stack(withList: with.reversed())
	}
	
	func pop<T: Token>() -> T? {
		if let peek = stack.peek() {
			if peek is T {
				return stack.pop() as? T
			}
		}
		return .none
	}
	
	func hasElements() -> Bool {
		return stack.hasElements()
	}
}
