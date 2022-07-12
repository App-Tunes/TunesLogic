//
//  File.swift
//  
//
//  Created by Lukas Tenbrink on 12.07.22.
//

import AVFoundation

public class CoreAudioLogic {
	public struct OSError: Error {
		public var code: OSStatus
	}
	
	public static func device(ofUnit unit: AudioUnit) -> UInt32? {
		var deviceID: AudioDeviceID = 0
		var propertySize: UInt32 = UInt32(MemoryLayout.size(ofValue: deviceID))
		
		let error = AudioUnitGetProperty(unit,
							 kAudioOutputUnitProperty_CurrentDevice,
							 kAudioUnitScope_Global, 0,
							 &deviceID,
							 &propertySize)
		
		if error != 0 {
			print("Could not get current device: \(error)")
			return nil
		}
		
		return deviceID
	}
	
	public static func volume(ofDevice device: UInt32, channel: UInt32? = nil) -> Float? {
		do {
			let channels = channel.map { $0...$0 } ?? 1...2
			let volumes = try channels.map { try getObjectProperty(
				object: device,
				address: .init(
					selector: kAudioDevicePropertyVolumeScalar,
					scope: kAudioDevicePropertyScopeOutput,
					element: $0
				),
				type: Float32.self
			)}
			return volumes.max()
		}
		catch let error {
			print("Could not get volume: \(error)")
		}
		
		return nil
	}
		
	public static func setVolume(ofDevice device: UInt32, _ volume: Float) {
		do {
			let channels: ClosedRange<UInt32> = 1...2
			let volumes = channels.map { Self.volume(ofDevice: device, channel: $0) ?? 0 }
			let max = volumes.max() ?? 1
			let ratios = volumes.map { max > 0 ? $0 / max : 1 }
			
			for (ratio, channel) in zip(ratios, channels) {
				try setObjectProperty(
					object: device,
					address: .init(
						selector: kAudioDevicePropertyVolumeScalar,
						scope: kAudioDevicePropertyScopeOutput,
						element: channel
					),
					value: volume * ratio
				)
			}
		}
		catch let error {
			print("Could not set volume: \(error)")
		}
	}
		
	public static var defaultOutputDevice: UInt32? {
		do {
			return try getObjectProperty(
				object: AudioObjectID(kAudioObjectSystemObject),
				address: .init(
					selector: kAudioHardwarePropertyDefaultSystemOutputDevice,
					scope: kAudioObjectPropertyScopeGlobal
				),
				type: AudioDeviceID.self
			)
		}
		catch let error {
			print("Could not get default device: \(error)")
		}
		
		return nil
	}
	
	public static func withObjectProperty<T, R>(object: AudioObjectID, address: AudioObjectPropertyAddress, type: T.Type, count: Int = 1, map: (UnsafeMutablePointer<T>) -> R) throws -> R {
		var propertySize = UInt32(MemoryLayout<T>.size) * UInt32(count)
		
		var address = address

		let obj = malloc(Int(propertySize))!
		defer { free(obj) }
		let error = AudioObjectGetPropertyData(object, &address, 0, nil, &propertySize, obj)

		guard error == 0 else { throw OSError(code: error) }
		
		return map(obj.assumingMemoryBound(to: T.self))
	}
	
	public static func getObjectProperty<T>(object: AudioObjectID, address: AudioObjectPropertyAddress, type: T.Type) throws -> T {
		try withObjectProperty(object: object, address: address, type: type) {
			$0.pointee
		}
	}
		
	public static func getObjectPropertyCount<T>(object: AudioObjectID, address: AudioObjectPropertyAddress, forType type: T.Type) throws -> Int {
		var size: UInt32 = 0
		var address = address

		let error = AudioObjectGetPropertyDataSize(object, &address, 0, nil, &size)

		guard error == 0 else { throw OSError(code: error) }
		
		return Int(size / UInt32(MemoryLayout<T>.size))
	}
	
	public static func getObjectPropertyList<T>(object: AudioObjectID, address: AudioObjectPropertyAddress, type: T.Type) throws -> [T] {
		let count = try getObjectPropertyCount(object: object, address: address, forType: type)
		return try withObjectProperty(object: object, address: address, type: type, count: count) {
			Array(UnsafeBufferPointer(start: $0, count: count))
		}
	}

	public static func setObjectProperty<T>(object: AudioObjectID, address: AudioObjectPropertyAddress, value: T) throws {
		var property = value
		var address = address
		let propertySize = UInt32(MemoryLayout<T>.size)

		let error = AudioObjectSetPropertyData(object, &address, 0, nil, propertySize, &property)

		if error != 0 {
			throw OSError(code: error)
		}
	}
}
