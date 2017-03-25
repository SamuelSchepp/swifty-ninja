import Foundation

public protocol Parser {
	associatedtype Target
	func parse(string: String) -> (Target?, String)
}

extension Scanner {
	var remainingString: String {
		return self.string.substring(from: self.string.index(self.string.startIndex, offsetBy: self.scanLocation))
	}
}

extension String {
	public var p: StringParser {
		return StringParser(keyword: self)
	}
}


public class StringParser : Parser {
	let keyword: String
	
	public init(keyword: String) {
		self.keyword = keyword
	}
	
	public typealias Target = String
	
	public func parse(string: String) -> (String?, String) {
		var result: NSString?
		let scanner = Scanner(string: string)
		scanner.scanString(keyword, into: &result)
		
		guard let res = result as? String else {
			return (nil, string)
		}
		
		return (res, scanner.remainingString)
	}
}

public class IdentParser : Parser {
	public typealias Target = String
	
	public init() {
		
	}
	
	public func parse(string: String) -> (String?, String) {
		var result: NSString?
		let scanner = Scanner(string: string)
		scanner.scanCharacters(from: CharacterSet.alphanumerics, into: &result)
		
		guard let res = result as? String else {
			return (nil, string)
		}
		
		return (res, scanner.remainingString)
	}
}

