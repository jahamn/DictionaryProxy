//
//  DictionaryProxy.swift
//  DictionaryProxy
//
//  Created by Jason Hamner on 10/9/17.
//  Copyright © 2017 Jason Hamner. All rights reserved.
//

import Foundation

public struct DictionaryProxy : Sequence {
    let raw: Any
    public init(_ raw: Any){
        self.raw = raw
    }
    
    public subscript(index: String) -> DictionaryProxy {
        guard let dict = raw as? Dictionary<String, Any>,
            let value = dict[index] else {
                return DictionaryProxy(NSNull())
        }
        return DictionaryProxy(value)
    }
    
    public func decode<T: Any>() -> T!{
        guard let value = raw as? T else {
            return nil
        }
        return value
    }
    
    public var number: NSNumber! {
        return decode()
    }
    
    public var string: NSString! {
        return decode()
    }
    
    public var date: NSDate! {
        return decode()
    }
    
    public var dictionary: [String: Any]! {
        return decode()
    }
    
    public var list: DictionaryProxyList {
        return DictionaryProxyList(raw)
    }
    
    public class Iterator : IteratorProtocol {
        var iter: DictionaryIterator<String, Any>?
        init(_ item: DictionaryProxy){
            iter = item.dictionary?.makeIterator()
        }
        public func next()->(String,DictionaryProxy)?{
            if iter != nil {
                if let (key, value) = iter!.next(){
                    return (key, DictionaryProxy(value))
                }
            }
            return nil
        }
    }
    
    public func makeIterator() -> DictionaryProxy.Iterator {
        return Iterator(self)
    }
}

public struct DictionaryProxyList : Sequence {
    let raw: Any
    init(_ raw: Any){
        self.raw = raw
    }
    
    public subscript(index: Int) -> DictionaryProxy {
        guard let array = raw as? [Any], array.count >= index else {
            return DictionaryProxy(NSNull())
        }
        
        let value = array[index]
        return DictionaryProxy(value)
    }
    
    public var count: Int {
        guard let array = raw as? [Any] else {
            return 0
        }
        return array.count
    }
    
    public class Iterator : IteratorProtocol {
        var index = 0
        let list: DictionaryProxyList
        init(list: DictionaryProxyList){
            self.list = list
        }
        public func next() -> DictionaryProxy? {
            defer {
                index += 1
            }
            if index < list.count {
                return list[index]
            } else {
                return nil
            }
        }
    }
    
    public func makeIterator() -> DictionaryProxyList.Iterator {
        return Iterator(list: self)
    }
}
