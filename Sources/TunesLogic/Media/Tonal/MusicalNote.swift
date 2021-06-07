//
//  File.swift
//  
//
//  Created by Lukas Tenbrink on 06.06.21.
//

import Foundation

/// An enum describing pitch classes in western notation.
public enum MusicalNote: Int, CaseIterable, Hashable {
	case C = 0, Db, D, Eb, E, F, Gb, G, Ab, A, Bb, B
		
	static public let byPitchClass = allCases
	
	public init?(pitchClass: Int) {
		self.init(rawValue: pitchClass)
	}
	
	static public func parse<S: StringProtocol>(_ string: S) -> MusicalNote? {
		switch string.lowercased() {
		case "a":
			return .A
		case "a#", "bb":
			return .Bb
		case "b":
			return .B
		case "c":
			return .C
		case "c#", "db":
			return .Db
		case "d":
			return .D
		case "d#", "eb":
			return .Eb
		case "e":
			return .E
		case "f":
			return .F
		case "f#", "gb":
			return .Gb
		case "g":
			return .G
		case "g#", "ab":
			return .Ab
		default:
			break
		}
		
		return nil
	}

	public var pitchClass: Int { rawValue }
}

extension MusicalNote: CustomStringConvertible {
	public var description: String { "MusicalNote(\(stringRepresentation(using: .flat(stylized: false)))" }
}
