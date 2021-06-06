//
//  File.swift
//  
//
//  Created by Lukas Tenbrink on 06.06.21.
//

import Foundation

extension Double {
	func format(precision: Int) -> String {
		String(format: "%.\(precision)f", self)
	}
}
