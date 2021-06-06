//
//  File.swift
//  
//
//  Created by Lukas Tenbrink on 06.06.21.
//

import Foundation

public extension Collection {
	var one: Element? {
		count == 1 ? first! : nil
	}
}
