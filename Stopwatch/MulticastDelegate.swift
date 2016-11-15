//
//  MulticastDelegate.swift
//  Stopwatch
//
//  Created by vm mac on 11/14/16.
//  Copyright © 2016 David Vaughn. All rights reserved.
//

import Foundation

public class MulticastDelegate <T> {
    private var weakDelegates = [WeakWrapper]()
    
    func addDelegate(delegte: T) {
        weakDelegates.append(WeakWrapper(value: delegte as AnyObject))
    }
    
    func removeDelegate(delegate: T) {
        for(index, delegateInArray) in weakDelegates.enumerated().reversed() {
            if delegateInArray.value == (delegate as AnyObject as! _OptionalNilComparisonType) {
                weakDelegates.remove(at: index)
            }
        }
    }
    
    func invoke(invocation: (T) -> ()) {
        for (index, delegate) in weakDelegates.enumerated().reversed() {
            if let delegate = delegate.value {
                invocation(delegate as! T)
            }
            else {
                weakDelegates.remove(at: index)
            }
        }
    }
}

precedencegroup MulticastPrecedence {
    associativity: left
    higherThan: TernaryPrecedence
}

infix operator |> : MulticastPrecedence
public func |><T>(left: MulticastDelegate<T>, right: (T) -> ()) {
    
    left.invoke(invocation: right)
}

private class WeakWrapper {
    weak var value: AnyObject?
    
    init(value: AnyObject) {
        self.value = value
    }
}
