//
//  File.swift
//  
//
//  Created by Lukas Tenbrink on 11.07.22.
//

import Foundation

public class RandomHistorySuggester<Item>: HistorySuggester {
	public var repeats: Bool

	public var fullPool: [Item]
	public var pool: [Item]

	public init(_ pool: [Item], repeats: Bool) {
		self.repeats = repeats
		self.fullPool = pool
		self.pool = pool
	}
	
	public func suggest(maxCount: Int) -> [Item] {
		return (0 ..< maxCount).compactMap { _ in
			suggestOne()
		}
	}
	
	public func suggestOne() -> Item? {
		guard !pool.isEmpty else {
			return nil
		}
		
		let index = Int.random(in: 0 ..< pool.count)
		let item = pool.remove(at: index)
		
		if pool.isEmpty && repeats {
			pool = fullPool
		}
		
		return item
	}
}
