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
    
    func testIterator(){
        let dict = ["foo" : NSString(string: "bar"), "biz" : NSString(string: "baz")]
        let dictProxy = DictionaryProxy(dict)
        for (myKey,myValue) in dictProxy {
            XCTAssert(dict.contains{(arg) -> Bool in
                let (key, value) = arg
                return key == myKey && myValue.string == value
            })
        }
    }
}

class DictionaryProxyListTests: XCTestCase {
    var list: Array<NSNumber>!
    var listProxy: DictionaryProxyList!
    
    override func setUp() {
        super.setUp()
        list = [1,2,3,4]
        listProxy = DictionaryProxyList(list)
    }
    
    func testListCount(){
        XCTAssert(listProxy.count == list.count)
    }
    
    func testListItem(){
        XCTAssert(listProxy[0].number == list.first!)
    }
    
    func testIterator(){
        var idx = 0
        for item in listProxy {
            XCTAssert(item.number == list[idx])
            idx += 1
        }
    }
}
