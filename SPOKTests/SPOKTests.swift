//
//  SPOKTests.swift
//  SPOKTests
//
//  Created by Cell on 10.12.2021.
//

import XCTest
@testable import SPOK

class SPOKTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testConvert32() throws {
        
        let inp:[UInt8] = [0, 22, 144, 4]
        
        let val2 = Int(
            bigEndian: Data(bytes:inp)
                .withUnsafeBytes {$0.pointee}
        )
        
        let val = ByteUtils
            .int(ArraySlice(inp))
        
        XCTAssert(
            val == val2,
            "\(val) \(val2)"
        )
        
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
