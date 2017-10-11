//
//  DictionaryProxyTests.swift
//  DictionaryProxyTests
//
//  Created by Jason Hamner on 10/9/17.
//  Copyright © 2017 Jason Hamner. All rights reserved.
//

import XCTest
@testable import DictionaryProxy

class DictionaryProxyTests: XCTestCase {
    func testString(){
        let dict = DictionaryProxy(["foo" : "bar"])
        XCTAssert(dict["foo"].string == "bar")
    }
    
    func testNumber(){
        let dict = DictionaryProxy(["foo" : 5])
        XCTAssert(dict["foo"].number == 5)
    }
    
    func testDate(){
        let time = NSDate()
        let dict = DictionaryProxy(["time" : time])
        XCTAssert(dict["time"].date == time)
    }
}
