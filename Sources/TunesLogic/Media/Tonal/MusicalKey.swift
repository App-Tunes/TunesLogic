//
//  File.swift
//  
//
//  Created by Lukas Tenbrink on 06.06.21.
//

import Foundation

/// A struct describing a piece by modern western notation.
public struct MusicalKey: Hashable {
	public let note: MusicalNote
	public let mode: MusicalMode
	
	public init(note: MusicalNote, mode: MusicalMode) {
		self.note = note
		self.mode = mode
	}
	
	static public func parse(_ toParse: String) -> MusicalKey? {
		if toParse.count == 0 {
			return nil
		}

		// Try different methods
		for parser in [
			CircleOfFifths.camelot.parseKey,
			CircleOfFifths.openKey.parseKey,
			Self.parseMusical
		] {
			if let key = parser(toParse) {
				return key
			}
		}
		
		return nil
	}
	
	public static func parseMusical(_ string: String) -> MusicalKey? {
		// may be upper or lowercase, all are supported
		let string = string.lowercased()
		
		// notes can be one or two characters long
		for splitIndex in 1...min(2, string.count) {
			let strSplitIndex = string.index(string.startIndex, offsetBy: splitIndex)
			if
				let note = MusicalNote.parse(string[..<strSplitIndex]),
				// If we found a note, and there's no string left, assume it's major
				let mode = MusicalMode.parse(string[strSplitIndex...])
			{
				return MusicalKey(note: note, mode: mode)
			}
		}
		
		return nil
	}

	public var title: String { "\(note.title) \(mode.title)" }
	public var shortTitle: String { "\(note.title)\(mode.shortTitle)" }
}

extension MusicalKey: CaseIterable {
	static public var allCases: [MusicalKey] {
		MusicalMode.allCases.flatMap { mode in
			MusicalNote.allCases.map { note in
				MusicalKey(note: note, mode: mode)
			}
		}
	}
}

extension MusicalKey: CustomStringConvertible {
	public var description: String { "MusicalKey(\(title))" }
}
