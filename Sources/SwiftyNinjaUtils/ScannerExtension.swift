import Foundation


extension Scanner {
	
	#if !os(Linux)
    public func scanInt() -> Int32? {
        var value: Int32 = 0
        return withUnsafeMutablePointer(to: &value) { (ptr: UnsafeMutablePointer<Int32>) -> Int32? in
            if scanInt32(ptr) {
                return ptr.pointee
            } else {
                return nil
            }
        }
    }
    
    public func scanInteger() -> Int? {
        var value: Int = 0
        return withUnsafeMutablePointer(to: &value) { (ptr: UnsafeMutablePointer<Int>) -> Int? in
            if scanInt(ptr) {
                return ptr.pointee
            } else {
                return nil
            }
        }
    }
    
    public func scanLongLong() -> Int64? {
        var value: Int64 = 0
        return withUnsafeMutablePointer(to: &value) { (ptr: UnsafeMutablePointer<Int64>) -> Int64? in
            if scanInt64(ptr) {
                return ptr.pointee
            } else {
                return nil
            }
        }
    }
    
    public func scanUnsignedLongLong() -> UInt64? {
        var value: UInt64 = 0
        return withUnsafeMutablePointer(to: &value) { (ptr: UnsafeMutablePointer<UInt64>) -> UInt64? in
            if scanUnsignedLongLong(ptr) {
                return ptr.pointee
            } else {
                return nil
            }
        }
    }
    
    public func scanFloat() -> Float? {
        var value: Float = 0.0
        return withUnsafeMutablePointer(to: &value) { (ptr: UnsafeMutablePointer<Float>) -> Float? in
            if scanFloat(ptr) {
                return ptr.pointee
            } else {
                return nil
            }
        }
    }
    
    public func scanDouble() -> Double? {
        var value: Double = 0.0
        return withUnsafeMutablePointer(to: &value) { (ptr: UnsafeMutablePointer<Double>) -> Double? in
            if scanDouble(ptr) {
                return ptr.pointee
            } else {
                return nil
            }
        }
    }
    
    public func scanHexInt() -> UInt32? {
        var value: UInt32 = 0
        return withUnsafeMutablePointer(to: &value) { (ptr: UnsafeMutablePointer<UInt32>) -> UInt32? in
            if scanHexInt32(ptr) {
                return ptr.pointee
            } else {
                return nil
            }
        }
    }
    
    public func scanHexLongLong() -> UInt64? {
        var value: UInt64 = 0
        return withUnsafeMutablePointer(to: &value) { (ptr: UnsafeMutablePointer<UInt64>) -> UInt64? in
            if scanHexInt64(ptr) {
                return ptr.pointee
            } else {
                return nil
            }
        }
    }
    
    public func scanHexFloat() -> Float? {
        var value: Float = 0.0
        return withUnsafeMutablePointer(to: &value) { (ptr: UnsafeMutablePointer<Float>) -> Float? in
            if scanHexFloat(ptr) {
                return ptr.pointee
            } else {
                return nil
            }
        }
    }
    
    public func scanHexDouble() -> Double? {
        var value: Double = 0.0
        return withUnsafeMutablePointer(to: &value) { (ptr: UnsafeMutablePointer<Double>) -> Double? in
            if scanHexDouble(ptr) {
                return ptr.pointee
            } else {
                return nil
            }
        }
    }
    
    // These methods avoid calling the private API for _invertedSkipSet and manually re-construct them so that it is only usage of public API usage
    // Future implementations on Darwin of these methods will likely be more optimized to take advantage of the cached values.
    public func scanString(string searchString: String) -> String? {
        let str = self.string._bridgeToObjectiveC()
        var stringLoc = scanLocation
        let stringLen = str.length
        let options: NSString.CompareOptions = [caseSensitive ? [] : NSString.CompareOptions.caseInsensitive, NSString.CompareOptions.anchored]
        
        if let invSkipSet = charactersToBeSkipped?.inverted {
            let range = str.rangeOfCharacter(from: invSkipSet, options: [], range: NSMakeRange(stringLoc, stringLen - stringLoc))
            stringLoc = range.length > 0 ? range.location : stringLen
        }
        
        let range = str.range(of: searchString, options: options, range: NSMakeRange(stringLoc, stringLen - stringLoc))
        if range.length > 0 {
            /* ??? Is the range below simply range? 99.9% of the time, and perhaps even 100% of the time... Hmm... */
            let res = str.substring(with: NSMakeRange(stringLoc, range.location + range.length - stringLoc))
            scanLocation = range.location + range.length
            return res
        }
        return nil
    }
    
    public func scanCharactersFromSet(_ set: CharacterSet) -> String? {
        let str = self.string._bridgeToObjectiveC()
        var stringLoc = scanLocation
        let stringLen = str.length
        let options: NSString.CompareOptions = caseSensitive ? [] : NSString.CompareOptions.caseInsensitive
        if let invSkipSet = charactersToBeSkipped?.inverted {
            let range = str.rangeOfCharacter(from: invSkipSet, options: [], range: NSMakeRange(stringLoc, stringLen - stringLoc))
            stringLoc = range.length > 0 ? range.location : stringLen
        }
        var range = str.rangeOfCharacter(from: set.inverted, options: options, range: NSMakeRange(stringLoc, stringLen - stringLoc))
        if range.length == 0 {
            range.location = stringLen
        }
        if stringLoc != range.location {
            let res = str.substring(with: NSMakeRange(stringLoc, range.location - stringLoc))
            scanLocation = range.location
            return res
        }
        return nil
    }
    
    public func scanUpToString(_ string: String) -> String? {
        let str = self.string._bridgeToObjectiveC()
        var stringLoc = scanLocation
        let stringLen = str.length
        let options: NSString.CompareOptions = caseSensitive ? [] : NSString.CompareOptions.caseInsensitive
        if let invSkipSet = charactersToBeSkipped?.inverted {
            let range = str.rangeOfCharacter(from: invSkipSet, options: [], range: NSMakeRange(stringLoc, stringLen - stringLoc))
            stringLoc = range.length > 0 ? range.location : stringLen
        }
        var range = str.range(of: string, options: options, range: NSMakeRange(stringLoc, stringLen - stringLoc))
        if range.length == 0 {
            range.location = stringLen
        }
        if stringLoc != range.location {
            let res = str.substring(with: NSMakeRange(stringLoc, range.location - stringLoc))
            scanLocation = range.location
            return res
        }
        return nil
    }
    
    public func scanUpToCharactersFromSet(_ set: CharacterSet) -> String? {
        let str = self.string._bridgeToObjectiveC()
        var stringLoc = scanLocation
        let stringLen = str.length
        let options: NSString.CompareOptions = caseSensitive ? [] : NSString.CompareOptions.caseInsensitive
        if let invSkipSet = charactersToBeSkipped?.inverted {
            let range = str.rangeOfCharacter(from: invSkipSet, options: [], range: NSMakeRange(stringLoc, stringLen - stringLoc))
            stringLoc = range.length > 0 ? range.location : stringLen
        }
        var range = str.rangeOfCharacter(from: set, options: options, range: NSMakeRange(stringLoc, stringLen - stringLoc))
        if range.length == 0 {
            range.location = stringLen
        }
        if stringLoc != range.location {
            let res = str.substring(with: NSMakeRange(stringLoc, range.location - stringLoc))
            scanLocation = range.location
            return res
        }
        return nil
	}
	#endif
}
