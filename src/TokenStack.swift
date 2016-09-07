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
    
    func pop(token: Token.Type) -> Bool {
        if let peek = stack.peek() {
            switch peek.Type {
            case token:
                _ = stack.pop()
                return true
            default:
                return false
            }
        }
        return false
    }
    
    func hasTokens() -> Bool {
        return stack.hasElements()
    }
}
