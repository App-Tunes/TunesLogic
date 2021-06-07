//
//  File.swift
//  
//
//  Created by Lukas Tenbrink on 06.06.21.
//

import Foundation

/// An enum describing western musical modes.
/// Arguably, other modes should be supported. This may be the case going forwards.
public enum MusicalMode: CaseIterable, Hashable {
	case major, minor
	
	static public let byString: [String: MusicalMode] = [
		"major": .major,
		"maj": .major,
		"d": .major,
		"dur": .major,

		"minor": .minor,
		"min": .minor,
		"m": .minor,
		"moll": .minor,
	]
	
	/// Parses a string to a musical mode. For exact matches, use byString instead. This method returns major on empty strings
	/// and supports whitespace.
	static public func parse<S: StringProtocol>(_ string: S) -> MusicalMode? {
		let string = string.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
		return string.isEmpty
			? MusicalMode.major
			: Self.byString[string]
	}
	
	public var title: String {
		[
			.major: "major",
			.minor: "minor"
		][self]!
	}

	public var shortTitle: String {
		[
			.major: "d",
			.minor: "m"
		][self]!
	}

	/// number of half notes to move for the relative major key
	public var shiftToMajor: Int {
		switch self {
		case .major:
			return 0
		case .minor:
			return 3
		}
	}
}
