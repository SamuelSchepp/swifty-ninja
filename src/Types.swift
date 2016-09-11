//
//  Types.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 10/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

protocol Type: CustomStringConvertible { }


struct IntegerType: Type {
    var description: String {
        get {
            return "Integer"
        }
    }
}

struct ReferenceType: Type {
	var description: String {
		get {
			return "Reference"
		}
	}
}

struct BooleanType: Type {
    var description: String {
        get {
            return "Boolean"
        }
	}
}

struct StringType: Type {
    var description: String {
        get {
            return "String"
        }
    }
}

struct CharacterType: Type {
    var description: String {
        get {
            return "Character"
        }
    }
}

struct ArrayType: Type {
    let base: Type
    let dims: Int
    
    var description: String {
        get {
            return "Array of \(base) (\(dims) dimensions)"
        }
    }
}

struct RecordType: Type {
    let fields: [String: Type]
    
    var description: String {
        get {
            let f = fields.reduce("") { last, current in
                return last + current.key + " -> " + current.value.description + ";"
            }
            return "Record (\(f))"
        }
    }
}
