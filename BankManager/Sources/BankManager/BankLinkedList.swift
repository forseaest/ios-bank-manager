//
//  File.swift
//  
//
//  Created by JIWOONG on 2024/03/18.
//

import Foundation

struct BankLinkedList<T> {
    var head: BankNode<T>?
    var tail: BankNode<T>?
    
    var isEmpty: Bool {
        return head == nil
    }
    
    var count: Int {
        var result = 0
        var node = head
        
        while node?.next != nil {
            result += 1
            node = node?.next
        }
        
        return result
    }
    
    var first: T? {
        return isEmpty ? nil : head?.data
    }
    
    mutating func append(element: T) {
        let node = BankNode(data: element, next: nil)
        
        if isEmpty {
            head = node
            tail = head
        } else {
            tail = node
            tail?.next = node
        }
    }
    
    mutating func removeFirst() -> T? {
        guard let firstNode = head?.data else {
            return nil
        }
        
        if head?.next == nil {
            head = nil
            tail = nil
            return firstNode
        }
        
        head = head?.next
        return firstNode
    }
}