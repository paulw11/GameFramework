//
//  GameStructs.swift
//  
//
//  Created by Paul Wilkinson on 18/9/19.
//

import Foundation


public struct GameState: Codable, Hashable {
	let status: String
	let id: String
}

public struct PlayerAnswer: Codable, Hashable {
	var gameID: String
	var playerID: String
	var questionId: String
	var answer: String
}

public struct Player:Codable, Hashable {
	public let id: String
	public let name: String
}

public struct PlayerState: Codable, Hashable {
	public let id: String
	public let score: Int
	public let results: [String:Bool]
}

public struct GameError: LocalizedError
{
	public var errorDescription: String? { return mMsg }
	public var failureReason: String? { return mMsg }
	public var recoverySuggestion: String? { return "" }
	public var helpAnchor: String? { return "" }
	
	private var mMsg : String
	
	public init(_ description: String)
	{
		mMsg = description
	}
}
