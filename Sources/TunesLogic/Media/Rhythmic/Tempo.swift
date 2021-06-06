//
//  File.swift
//  
//
//  Created by Lukas Tenbrink on 06.06.21.
//

import Foundation

public struct Tempo: Hashable {
	public let beatsPerMinute: Double
	
	public init(beatsPerMinute: Double) {
		self.beatsPerMinute = beatsPerMinute
	}
		
	/// Value in (0, 1] depicting the logarithm:
	/// twice or half values are represented as the same
	public var rotation: Double {
		log2(beatsPerMinute).truncatingRemainder(dividingBy: 1)
	}
		
	public var beatsPerSecond: Double { beatsPerMinute / 60 }
	
	public var phraseSeconds: TimeInterval {
		TimeInterval(1 / beatsPerSecond) * 16
	}
}
