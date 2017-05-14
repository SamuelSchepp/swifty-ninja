//
//  Function.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 12/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation
import SwiftyNinjaLang

public protocol Function: CustomStringConvertible {
    var type: TypeExpression? { get }
    var ident: String { get }
    var par_decs: [Par_Dec] { get }
}

extension Function {
    func signature() -> String {
        return "\(String(describing: type)) \(ident)(\(par_decs)) { ... }"
    }
}

public struct UserFunction: Function {
    public let func_dec: Func_Dec
    
    public var type: TypeExpression? { get { return func_dec.type } }
    public var ident: String { get { return func_dec.ident } }
    public var par_decs: [Par_Dec] { get { return func_dec.par_decs } }
    
	public init(func_dec: Func_Dec) {
		self.func_dec = func_dec;
	}
	
    public var description: String {
        get {
            return "UserFunction(\(func_dec.description))"
        }
    }
}

public struct SystemFunction: Function {
    public let type: TypeExpression?
    public let ident: String
    public let par_decs: [Par_Dec]
    public let callee: (GlobalEnvironment) throws -> Void
    
    public var description: String {
        get {
            return "SystemFunction(\(ident))"
        }
    }
}
