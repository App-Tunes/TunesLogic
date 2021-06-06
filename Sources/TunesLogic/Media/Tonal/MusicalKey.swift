//
//  File.swift
//  
//
//  Created by Lukas Tenbrink on 06.06.21.
//

import Foundation

/// A struct describing a piece by modern western notation.
struct MusicalKey: Equatable {
	let note: MusicalNote
	let mode: MusicalMode
	
	static func parse(_ toParse: String) -> MusicalKey? {
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

	var title: String { "\(note.title) \(mode.title)" }
	var shortTitle: String { "\(note.title)\(mode.shortTitle)" }
}

extension MusicalKey: CaseIterable {
	static var allCases: [MusicalKey] {
		MusicalMode.allCases.flatMap { mode in
			MusicalNote.allCases.map { note in
				MusicalKey(note: note, mode: mode)
			}
		}
	}
}

extension MusicalKey: CustomStringConvertible {
	var description: String { "MusicalKey(\(title))" }
}
