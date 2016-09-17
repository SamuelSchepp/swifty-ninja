//
//  Types.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 10/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

protocol Type: CustomStringConvertible { }

struct VoidType: Type {
	var description: String {
		get {
			return "<Void>"
		}
	}
}

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

struct CharacterType: Type {
    var description: String {
        get {
            return "Character"
        }
    }
}

struct UnresolvedType: Type {
	let ident: String
	
	var description: String {
		get {
			return "\(ident)"
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
	let fieldIdents: [String]
    let fieldTypes: [Type]
    
    var size: Int {
        return fieldIdents.count
    }
    
    var description: String {
        get {
            let f = zip(fieldIdents, fieldTypes).reduce("") { last, current in
                return "\(last) \(current.1.description) \(current.0); "
            }
            return "Record (\(f))"
        }
    }
}
