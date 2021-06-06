//
//  File.swift
//  
//
//  Created by Lukas Tenbrink on 06.06.21.
//

import Foundation

struct Tempo: Hashable {
	let beatsPerMinute: Double
	
	init(beatsPerMinute: Double) {
		self.beatsPerMinute = beatsPerMinute
	}
		
	/// Value in (0, 1] depicting the logarithm:
	/// twice or half values are represented as the same
	var rotation: Double {
		log2(beatsPerMinute).truncatingRemainder(dividingBy: 1)
	}
		
	var beatsPerSecond: Double { beatsPerMinute / 60 }
	
	var phraseSeconds: TimeInterval {
		TimeInterval(1 / beatsPerSecond) * 16
	}
}
