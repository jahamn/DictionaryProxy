//
//  DictionaryProxy.swift
//  DictionaryProxy
//
//  Created by Jason Hamner on 10/9/17.
//  Copyright © 2017 Jason Hamner. All rights reserved.
//

import Foundation

class DictionaryProxy : Sequence {
    let raw: Any
    init(body: Any){
        raw = body
    }
    
    subscript(index: String) -> DictionaryProxy {
        guard let dict = raw as? Dictionary<String, Any>,
            let value = dict[index] else {
                return DictionaryProxy(body: NSNull())
        }
        return DictionaryProxy(body: value)
    }
    
    func decode<T: Any>() -> T!{
        guard let value = raw as? T else {
            return nil
        }
        return value
    }
    
    var number: NSNumber! {
        return decode()
    }
    
    var string: NSString! {
        return decode()
    }
    
    var date: NSDate! {
        return decode()
    }
    
    var dictionary: [String: Any]! {
        return decode()
    }
    
    var list: DictProxyList {
        return DictProxyList(body: raw)
    }
    
    class Iterator : IteratorProtocol {
        var iter: DictionaryIterator<String, Any>?
        init(_ item: DictionaryProxy){
            iter = item.dictionary?.makeIterator()
        }
        func next()->(String,DictionaryProxy)?{
            if iter != nil {
                if let (key, value) = iter!.next(){
                    return (key, DictionaryProxy(body: value))
                }
            }
            return nil
        }
    }
    
    func makeIterator() -> DictionaryProxy.Iterator {
        return Iterator(self)
    }
}

class DictProxyList : Sequence {
    let raw: Any
    init(body: Any){
        raw = body
    }
    
    subscript(index: Int) -> DictionaryProxy {
        guard let array = raw as? [Any], array.count >= index else {
            return DictionaryProxy(body: NSNull())
        }
        
        let value = array[index]
        return DictionaryProxy(body: value)
    }
    
    var count: Int {
        guard let array = raw as? [Any] else {
            return 0
        }
        return array.count
    }
    
    class Iterator : IteratorProtocol {
        var index = 0
        let list: DictProxyList
        init(list: DictProxyList){
            self.list = list
        }
        func next() -> DictionaryProxy? {
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
    
    func makeIterator() -> DictProxyList.Iterator {
        return Iterator(list: self)
    }
}
