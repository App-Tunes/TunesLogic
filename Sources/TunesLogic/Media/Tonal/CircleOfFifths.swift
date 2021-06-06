//
//  File.swift
//  
//
//  Created by Lukas Tenbrink on 06.06.21.
//

import Foundation

struct CircleOfFifths {
	static let openKey = CircleOfFifths(name: "openKey", offset: 1, baseNoteMajor: .C, modeShorthands: [
		"m": .minor, "d": .major
	])
	
	static let camelot = CircleOfFifths(name: "camelot", offset: 1, baseNoteMajor: .B, modeShorthands: [
		"A": .minor, "B": .major
	])
	
	var name: String
	var offset: Int
	var baseNoteMajor: MusicalNote

	var modeShorthands: [String: MusicalMode] = [:]
	
	func parseKey(_ string: String) -> MusicalKey? {
		guard let last = string.last else {
			return nil
		}
		
		guard let mode = modeShorthands[String(last)] else {
			return nil
		}
		
		guard
			let index = Int(string.dropLast()).map({ $0 - offset }),
			(0 ..< 12).contains(index)
		else {
			return nil
		}
		
		let pitchClass = (index * 7 - mode.shiftToMajor + baseNoteMajor.pitchClass + 12) % 12
		
		return MusicalKey(note: MusicalNote(pitchClass: pitchClass)!, mode: mode)
	}
	
	/// Like the represented number, but without the offset so that the base note always starts at 0
	func index(of key: MusicalKey) -> Int {
		((key.note.pitchClass - baseNoteMajor.pitchClass + key.mode.shiftToMajor + 12) * 7) % 12
	}
		
	func stringRepresentation(of key: MusicalKey) -> String {
		let modeShorthand = modeShorthands.first { $1 == key.mode }!.key
		let index = index(of: key) + offset
		
		return "\(index)\(modeShorthand)"
	}
}

extension CircleOfFifths: CustomStringConvertible {
	var description: String { "CircleOfFifths.\(name)" }
}
