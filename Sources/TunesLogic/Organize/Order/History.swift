//
//  File.swift
//  
//
//  Created by Lukas Tenbrink on 11.07.22.
//

import Foundation
import Combine

@available(macOS 10.15, *)
public class History<Item> {
	public var queue: [Item]
	public var current: Item?
	public var history: [Item]
	
	public let changePublisher = PassthroughSubject<History, Never>()
	
	public init(history: [Item] = [], current: Item? = nil, queue: [Item] = []) {
		self.queue = queue
		self.current = current
		self.history = history
	}
	
	@discardableResult
	public func forwards() -> Item? {
		if let current = current {
			history.append(current)
		}
		
		guard let next = queue.popFirst() else {
			changePublisher.send(self)
			return nil
		}
		
		current = next
		changePublisher.send(self)
		
		return next
	}
	
	@discardableResult
	public func backwards() -> Item? {
		if let current = current {
			queue.prepend(current)
		}

		guard let previous = history.popLast() else {
			changePublisher.send(self)
			return nil
		}

		current = previous
		changePublisher.send(self)

		return previous
	}
}

@available(macOS 10.15, *)
public extension History {
	var previous: Item? {
		history.last
	}
		
	var next: Item? {
		queue.first
	}
}
