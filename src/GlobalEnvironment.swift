//
//  GlobalEnvironment.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 10/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

class GlobalEnvironment {
    var typeDecMap: [String: Type]
    var varTypeMap: [String: Type]
    var variables: [String: Object]
    var functions: [String: Func_Dec]
    
    init() {
        typeDecMap = [
            "Integer": IntegerType(),
            "Boolean": BooleanType(),
            "String": StringType(),
            "Character": CharacterType()
        ]
        
        varTypeMap = [:]
        variables = [:]
        functions = [:]
    }
    
    func identifierExists(ident: String) -> Bool {
        return typeDecMap.keys.contains(ident) ||
            varTypeMap.keys.contains(ident) ||
            variables.keys.contains(ident) ||
            functions.keys.contains(ident)
    }
}
