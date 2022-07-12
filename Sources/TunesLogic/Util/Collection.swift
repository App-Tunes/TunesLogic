//
//  File.swift
//  
//
//  Created by Lukas Tenbrink on 06.06.21.
//

import Foundation

extension Collection {
	var one: Element? {
		count == 1 ? first! : nil
	}
	
	func noneSatisfy(_ predicate: (Self.Element) throws -> Bool) rethrows -> Bool {
		try allSatisfy { try !predicate($0) }
	}
	
	func anySatisfy(_ predicate: (Self.Element) throws -> Bool) rethrows -> Bool {
		try contains(where: predicate)
	}
}

extension Array {
	mutating func prepend(_ element: Element) {
		insert(element, at: 0)
	}

	mutating func popFirst() -> Element? {
		isEmpty ? nil : removeFirst()
	}
}
