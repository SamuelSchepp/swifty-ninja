//
//  TokenStack.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 08/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

struct TokenStack {
	private var stack: Stack<Token>
	private var transactionStack: Stack<Stack<Token>>
	
	init(with: [Token]) {
		stack = Stack(withList: with.reversed())
		transactionStack = Stack()
	}
	
	mutating func pop<T: Token>() -> T? {
		if let _ = stack.peek() as? T {
			return stack.pop() as? T
		}
		return .none
	}
	
	mutating func pop_Rel_Exp_Binary_Op() -> Rel_Exp_Binary_Op? {
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
	
	mutating func pop_Add_Exp_Binary_Op() -> Add_Exp_Binary_Op? {
		if let _: PLUS = pop() {
			return .PLUS
		}
		if let _: MINUS = pop() {
			return .MINUS
		}
		return .none
	}
	
	mutating func pop_Mul_Exp_Binary_Op() -> Mul_Exp_Binary_Op? {
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
	
	mutating func pop_Unary_Exp_Impl_Op() -> Unary_Exp_Impl_Op? {
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
	
	func check_Primary_Exp() -> Bool {
		if let _ = stack.peek() as? NIL { return true }
		if let _ = stack.peek() as? INTEGERLIT { return true }
		if let _ = stack.peek() as? CHARACTERLIT { return true }
		if let _ = stack.peek() as? BOOLEANLIT { return true }
		if let _ = stack.peek() as? STRINGLIT { return true }
		if let _ = stack.peek() as? NEW { return true }
		if let _ = stack.peek() as? SIZEOF { return true }
		if let _ = stack.peek() as? LPAREN { return true }
		if let _ = stack.peek() as? IDENT { return true }
		
		return false
	}
	
	var context: [Token] {
		get {
			return stack.context
		}
		set {
			stack.context = newValue
		}
	}
	
	func hasElements() -> Bool {
		return stack.hasElements()
	}
}
