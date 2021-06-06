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
	
	static public func parse(_ toParse: String) -> MusicalKey? {
		if toParse.count == 0 {
			return nil
		}

		// Circle of fifths notation?
		for notation in [CircleOfFifths.camelot, .openKey] {
			if let key = notation.parseKey(toParse) {
				return key
			}
		}
		
		let string = toParse.lowercased()
		
		// Musical?
		for splitIndex in 1...min(2, string.count) {
			let strSplitIndex = string.index(string.startIndex, offsetBy: splitIndex)
			if
				let note = MusicalNote.parse(string[..<strSplitIndex]),
				let mode = (splitIndex == string.count) ? MusicalMode.major : MusicalMode.byString[String(string[strSplitIndex...])]
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
