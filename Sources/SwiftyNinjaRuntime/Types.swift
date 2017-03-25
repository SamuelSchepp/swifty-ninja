//
//  Types.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 10/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

public protocol Type: CustomStringConvertible { }

public struct VoidType: Type {
	public init() {
		
	}
	
	public var description: String {
		get {
			return "<Void>"
		}
	}
}

public struct IntegerType: Type {
	public init() {
		
	}
	
    public var description: String {
        get {
            return "Integer"
        }
    }
}

public struct ReferenceType: Type {
	public init() {
		
	}
	
	public var description: String {
		get {
			return "Reference"
		}
	}
}

public struct BooleanType: Type {
	public init() {
		
	}
	
    public var description: String {
        get {
            return "Boolean"
        }
	}
}

public struct CharacterType: Type {
	public init() {
		
	}
	
    public var description: String {
        get {
            return "Character"
        }
    }
}

public struct UnresolvedType: Type {
	public let ident: String
	
	public init(ident: String) {
		self.ident = ident
	}
	
	public var description: String {
		get {
			return "Unresolved(\(ident))"
		}
	}
}

public struct ArrayType: Type {
    public let base: Type
	
	public init(base: Type) {
		self.base = base
	}
    
    public var description: String {
        get {
            return "Array of \(base))"
        }
    }
}

public struct RecordType: Type {
	public let fieldIdents: [String]
    public let fieldTypes: [Type]
    
	public init(fieldIdents: [String], fieldTypes: [Type]) {
		self.fieldIdents = fieldIdents
		self.fieldTypes = fieldTypes
	}
	
    public var size: Int {
        return fieldIdents.count
    }
    
    public var description: String {
        get {
            let f = zip(fieldIdents, fieldTypes).reduce("") { last, current in
                return "\(last) \(current.1.description) \(current.0); "
            }
            return "Record (\(f))"
        }
    }
}
