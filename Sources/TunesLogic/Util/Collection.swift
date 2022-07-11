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
}

extension Array {
	mutating func prepend(_ element: Element) {
		insert(element, at: 0)
	}

	mutating func popFirst() -> Element? {
		isEmpty ? nil : removeFirst()
	}
}
