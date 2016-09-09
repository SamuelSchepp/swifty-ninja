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
		if let _ = stack.peek() as? T {
			return stack.pop() as? T
		}
		return .none
	}
	
	func pop_Rel_Exp_Binary_Op() -> Rel_Exp_Binary_Op? {
		if let _: EQ = pop() {
			return .EQ
		}
		if let _: NE = pop() {
			return .NE
		}
		if let _: LT = pop() {
			return .LT
		}
		if let _: LE = pop() {
			return .LE
		}
		if let _: GT = pop() {
			return .GT
		}
		if let _: GE = pop() {
			return .GE
		}
		return .none
	}
	
	func pop_Add_Exp_Binary_Op() -> Add_Exp_Binary_Op? {
		if let _: PLUS = pop() {
			return .PLUS
		}
		if let _: MINUS = pop() {
			return .MINUS
		}
		return .none
	}
	
	func pop_Mul_Exp_Binary_Op() -> Mul_Exp_Binary_Op? {
		if let _: STAR = pop() {
			return .STAR
		}
		if let _: SLASH = pop() {
			return .SLASH
		}
		if let _: PERCENT = pop() {
			return .PERCENT
		}
		return .none
	}
	
	func pop_Unary_Exp_Impl_Op() -> Unary_Exp_Impl_Op? {
		if let _: PLUS = pop() {
			return .PLUS
		}
		if let _: MINUS = pop() {
			return .MINUS
		}
		if let _: LOGNOT = pop() {
			return .LOGNOT
		}
		return .none
	}
	
	func hasElements() -> Bool {
		return stack.hasElements()
	}
}
