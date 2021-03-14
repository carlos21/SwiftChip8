//
//  Stack.swift
//  Chip8
//
//  Created by Carlos Duclos on 8/22/20.
//  Copyright © 2020 Carlos. All rights reserved.
//

import Foundation

let maxSize = 16

struct Stack<Element> where Element: Equatable {
    
    private var storage = [Element]()
    
    var pointer: Int {
        return storage.count - 1
    }
    
    func peek() -> Element? {
        storage.first
    }
    
    func last() -> Element? {
        storage.last
    }
    
    mutating func push(_ element: Element) {
        precondition(storage.count < maxSize)
        storage.append(element)
    }
    
    mutating func pop() -> Element {
        precondition(storage.count < maxSize && storage.count > 0)
        return storage.popLast()!
    }
}

extension Stack: Equatable {
    
    static func == (lhs: Stack<Element>, rhs: Stack<Element>) -> Bool {
        lhs.storage == rhs.storage
    }
}

extension Stack: CustomStringConvertible {
    
var description: String {
        return "\(storage)"
    }
}

extension Stack: ExpressibleByArrayLiteral {
    
    init(arrayLiteral elements: Element...) {
        storage = elements
    }
}
