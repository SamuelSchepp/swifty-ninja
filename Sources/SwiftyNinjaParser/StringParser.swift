//
//  StringParser.swift
//  SwiftyNinja
//
//  Created by Samuel Schepp on 25/03/2017.
//
//

import Foundation

public class StringParser : Parser<String> {
	let keyword: String
	
	public init(keyword: String) {
		self.keyword = keyword
	}
	
	public typealias Target = String
	
	public override func parse(string: String) -> (String?, String) {
		var result: NSString?
		let scanner = Scanner(string: string)
		scanner.scanString(keyword, into: &result)
		
		guard let res = result as? String else {
			return (nil, string)
		}
		
		return (res, scanner.remainingString)
	}
}
