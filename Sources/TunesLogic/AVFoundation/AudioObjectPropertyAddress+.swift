//
//  File.swift
//  
//
//  Created by Lukas Tenbrink on 12.07.22.
//

import AVFoundation

public extension AudioObjectPropertyAddress {
	init(selector: AudioObjectPropertySelector, scope: AudioObjectPropertyScope, element: AudioObjectPropertyElement = 0) {
		self.init(mSelector: selector, mScope: scope, mElement: element)
	}
}
