//
//  MulticastDelegate.swift
//  Stopwatch
//
//  Created by vm mac on 11/14/16.
//  Copyright © 2016 David Vaughn. All rights reserved.
//

import Foundation

//A class to assign to a delegate to be able to hold multiple
public class MulticastDelegate <T> {
    
    //An array of Weak Objects
    private var weakDelegates = [WeakWrapper]()
    
    //Adds any object as a delegate to the array
    func addDelegate(delegte: T) {
        weakDelegates.append(WeakWrapper(value: delegte as AnyObject))
    }
    
    //Removes a specific delegate from the array
    func removeDelegate(delegate: T) {
        for(index, delegateInArray) in weakDelegates.enumerated().reversed() {
            if delegateInArray.value == (delegate as AnyObject as! _OptionalNilComparisonType) {
                weakDelegates.remove(at: index)
            }
        }
    }
    
    //Calls all the delegates active in the array 
    //and removes them if nil
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

//Set precedence for use of infix operator
precedencegroup MulticastPrecedence {
    associativity: left
    higherThan: TernaryPrecedence
}

//Set infix operator to make a more elegant call to all the delegates
infix operator |> : MulticastPrecedence
public func |><T>(left: MulticastDelegate<T>, right: (T) -> ()) {
    
    left.invoke(invocation: right)
}

//Private class that has a weak reference to an optional
private class WeakWrapper {
    weak var value: AnyObject?
    
    init(value: AnyObject) {
        self.value = value
    }
}
