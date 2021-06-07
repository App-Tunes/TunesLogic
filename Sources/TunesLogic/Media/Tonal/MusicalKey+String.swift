//
//  File.swift
//  
//
//  Created by Lukas Tenbrink on 07.06.21.
//

import Foundation

public extension MusicalNote {
	enum StringRepresentation: Hashable {
		case sharp(stylized: Bool)
		case flat(stylized: Bool)
		
		var isFlat: Bool {
			switch self {
			case .flat(stylized: _):
				return true
			case .sharp(stylized: _):
				return false
			}
		}
		var symbol: String {
			[
				StringRepresentation.sharp(stylized: false): "#",
				StringRepresentation.sharp(stylized: true): "♯",
				StringRepresentation.flat(stylized: false): "b",
				StringRepresentation.sharp(stylized: true): "♭",
			][self]!
		}
	}
	
	func stringRepresentation(using representation: StringRepresentation) -> String{
		let baseTitles: [String?] = [
			"C", nil, "D", nil, "E",
			"F", nil, "G", nil, "A", nil, "B"
		]

		let baseTitle = baseTitles[(pitchClass + (representation.isFlat ? -1 : 1) + 12) % 12]!
		return baseTitle + representation.symbol
	}
}

public extension MusicalMode {
	enum StringRepresentation {
		case long, medium, german, shortGerman
	}
	
	func stringRepresentation(using representation: StringRepresentation) -> String {
		let isMajor = self == .major
		
		switch representation {
		case .long:
			return isMajor ? "major" : "minor"
		case .medium:
			return isMajor ? "maj" : "min"
		case .german:
			return isMajor ? "dur" : "moll"
		case .shortGerman:
			return isMajor ? "d" : "m"
		}
	}
}


public protocol MusicalKeyWriter {
	func write(_ key: MusicalKey) -> String
}

public extension MusicalKey {
	struct Writer: MusicalKeyWriter {
		public static let `default` = Writer()
		
		public var sharps: MusicalNote.StringRepresentation = .flat(stylized: false)
		public var mode: MusicalMode.StringRepresentation = .long
		public var withSpace: Bool = true

		public func write(_ key: MusicalKey) -> String {
			let noteTitle = key.note.stringRepresentation(using: sharps)
			let modeTitle = key.mode.stringRepresentation(using: mode)
			let space = withSpace ? " " : ""
			
			return noteTitle + space + modeTitle
		}
		
		struct GermanWriter: MusicalKeyWriter {
			public var sharps: MusicalNote.StringRepresentation = .flat(stylized: false)

			public func write(_ key: MusicalKey) -> String {
				let noteTitle = key.note.stringRepresentation(using: sharps)
				return key.mode == .major ? noteTitle : noteTitle.lowercased()
			}
		}
	}
}
