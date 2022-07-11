//
//  File.swift
//  
//
//  Created by Lukas Tenbrink on 29.08.21.
//

import Foundation

public protocol HistorySuggester: AnyObject {
	associatedtype Item
	
	func suggest(maxCount: Int) -> [Item]
}
