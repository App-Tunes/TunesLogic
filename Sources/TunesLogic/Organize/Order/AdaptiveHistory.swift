//
//  File.swift
//  
//
//  Created by Lukas Tenbrink on 29.08.21.
//

import Foundation

@available(macOS 11.0, *)
public class AdaptiveHistory<Suggester: HistorySuggester>: History<Suggester.Item> {
	public typealias Item = Suggester.Item
	public var suggester: Suggester
	
	public init(history: [Item] = [], queue: [Item] = [], suggester: Suggester) {
		self.suggester = suggester
		super.init(history: history, queue: queue)
	}
	
	public override func forwards() -> Suggester.Item? {
		if queue.isEmpty {
			queue.append(contentsOf: suggester.suggest(maxCount: 1))
		}
		
		return super.forwards()
	}
}
