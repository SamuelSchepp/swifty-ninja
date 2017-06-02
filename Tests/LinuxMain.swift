import XCTest
@testable import SwiftyNinjaLibTests

XCTMain([
	 testCase(ExpressionTests.allTests),
	 testCase(ASTTests.allTests),
	 testCase(GlobalVarTests.allTests),
	 // testCase(ProgramTests.allTests),
	 testCase(StackTests.allTests),
	 testCase(StmTests.allTests),
	 testCase(TokenizerTests.allTests),
])
