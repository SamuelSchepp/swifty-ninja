//
//  Function.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 12/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

protocol Function: CustomStringConvertible {
    var type: TypeExpression? { get }
    var ident: String { get }
    var par_decs: [Par_Dec] { get }
}

extension Function {
    func signature() -> String {
        return "\(type) \(ident)(\(par_decs)) { ... }"
    }
}

struct UserFunction: Function {
    let func_dec: Func_Dec
    
    var type: TypeExpression? { get { return func_dec.type } }
    var ident: String { get { return func_dec.ident } }
    var par_decs: [Par_Dec] { get { return func_dec.par_decs } }
    
    var description: String {
        get {
            return "UserFunction(\(func_dec.description))"
        }
    }
}

struct SystemFunction: Function {
    let type: TypeExpression?
    let ident: String
    let par_decs: [Par_Dec]
    let callee: (GlobalEnvironment) throws -> Void
    
    var description: String {
        get {
            return "SystemFunction(\(ident))"
        }
    }
}
