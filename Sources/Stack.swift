//
//  Stack.swift
//  Chip8
//
//  Created by Carlos Duclos on 8/22/20.
//  Copyright © 2020 Carlos. All rights reserved.
//

import Foundation

let maxSize = 16

public protocol Stackable {
    
    associatedtype Element
    
    func peek() -> Element?
    mutating func push(_ element: Element)
    @discardableResult mutating func pop() -> Element?
}

public struct Stack<Element>: Stackable where Element: Equatable {
    
    private var storage = [Element]()
    
    public func peek() -> Element? {
        storage.first
    }
    
    public mutating func push(_ element: Element) {
        precondition(storage.count < maxSize)
        storage.append(element)
    }
    
    public mutating func pop() -> Element? {
        precondition(storage.count < maxSize)
        return storage.popLast()
    }
}

extension Stack: Equatable {
    
    public static func == (lhs: Stack<Element>, rhs: Stack<Element>) -> Bool {
        lhs.storage == rhs.storage
    }
}

extension Stack: CustomStringConvertible {
    
    public var description: String {
        return "\(storage)"
    }
}

extension Stack: ExpressibleByArrayLiteral {
    
    public init(arrayLiteral elements: Self.Element...) {
        storage = elements
    }
}

//class Stack<T>: ExpressibleByArrayLiteral {
//
//    typealias ArrayLiteralElement = T
//
//    private let buffer: UnsafeMutableBufferPointer<T>
//
//    public var count: Int {
//        return buffer.count
//    }
//
//    init(_ count: Int) {
//        buffer = UnsafeMutableBufferPointer.allocate(capacity: count)
//    }
//
//    convenience init(count: Int, repeating value: T) {
//        self.init(count)
//        buffer.initialize(repeating: value)
//    }
//
//    required convenience init(arrayLiteral elements: T...) {
//        self.init(elements.count)
//        let _ = buffer.initialize(from: elements)
//    }
//
//    deinit {
//        buffer.deallocate()
//    }
//
//    subscript(index: Int) -> T {
//        set(newValue) {
//            precondition((0...endIndex).contains(index))
//            buffer[index] = newValue
//        }
//        get {
//            precondition((0...endIndex).contains(index))
//            return buffer[index]
//        }
//    }
//}
//
//extension Stack: MutableCollection {
//
//    public var startIndex: Int {
//        return 0
//    }
//
//    public var endIndex: Int {
//        return count - 1
//    }
//
//    func index(after i: Int) -> Int {
//        return i + 1;
//    }
//}
