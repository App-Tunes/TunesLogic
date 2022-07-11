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
	public var history: [Item] = []
	
	public let changePublisher = PassthroughSubject<History, Never>()
	
	public init(history: [Item] = [], queue: [Item] = []) {
		self.queue = queue
		self.history = history
	}
	
	@discardableResult
	public func forwards() -> Item? {
		guard let next = queue.popFirst() else {
			return nil
		}
		
		history.append(next)
		changePublisher.send(self)
		
		return next
	}
	
	@discardableResult
	public func backwards() -> Item? {
		guard let current = history.popLast() else {
			return nil
		}

		queue.prepend(current)
		changePublisher.send(self)

		return previous
	}
}

@available(macOS 10.15, *)
public extension History {
	var previous: Item? {
		history.dropLast().last
	}
	
	var current: Item? {
		history.last
	}
	
	var next: Item? {
		queue.first
	}
}
