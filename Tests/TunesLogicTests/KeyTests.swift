    import XCTest
    @testable import TunesLogic

    final class TunesLogicTests: XCTestCase {
		func assertPairsParsedCorrectly(_ pairs: [String: MusicalKey]) {
			for (string, key) in pairs {
				XCTAssertEqual(
					MusicalKey.parse(string),
					key
				)
			}
		}
		
		func testMusicalNotation() {
			assertPairsParsedCorrectly([
				"Abm": MusicalKey(note: .Ab, mode: .minor),
				"Ab": MusicalKey(note: .Ab, mode: .major),
				"C": MusicalKey(note: .C, mode: .major),
				"Gm": MusicalKey(note: .G, mode: .minor),
				"Abmaj": MusicalKey(note: .Ab, mode: .major),
				"Abmajor": MusicalKey(note: .Ab, mode: .major),
			])
		}
		
		func testOpenKey() {
			assertPairsParsedCorrectly([
				"6m": MusicalKey(note: .Ab, mode: .minor),
				"1d": MusicalKey(note: .C, mode: .major),
				"11m": MusicalKey(note: .G, mode: .minor),
			])
		}
		
		func testCamelot() {
			assertPairsParsedCorrectly([
				"1A": MusicalKey(note: .Ab, mode: .minor),
				"8B": MusicalKey(note: .C, mode: .major),
				"6A": MusicalKey(note: .G, mode: .minor),
			])
		}
		
		func testLossless() {
			for notation in [CircleOfFifths.camelot, CircleOfFifths.openKey] {
				for key in MusicalKey.allCases {
					let asString = notation.stringRepresentation(of: key)
					let parsed = notation.parseKey(asString)
					
					XCTAssertEqual(
						key, parsed,
						"\(notation) converted \(key) -> \(asString) to \(String(describing: parsed))"
					)
				}
			}
		}
    }
