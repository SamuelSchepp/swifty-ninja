//
//  IdentifierParser.swift
//  SwiftyNinja
//
//  Created by Samuel Schepp on 25/03/2017.
//
//

import Foundation

public class IdentifierParser : Parser<String> {
	public override init() {
		super.init()
	}
	
	public override func parse(string: String) -> (String?, String) {
		var result: NSString?
		let scanner = Scanner(string: string)
		scanner.scanCharacters(from: CharacterSet.alphanumerics, into: &result)
		
		guard let res = result as? String else {
			return (nil, string)
		}
		
		return (res, scanner.remainingString)
	}
}
