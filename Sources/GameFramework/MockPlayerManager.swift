//
//  MockPlayerManager.swift
//  QuizzleTV
//
//  Created by Paul Wilkinson on 2/2/19.
//  Copyright © 2019 Paul Wilkinson. All rights reserved.
//

import Combine
import Foundation

final public class MockPlayerManager: PlayerManager {
	
	@Published
	private var mockState: GameStatus = .ready
	
	public var questionPublisher: AnyPublisher<Question, Error> {
		let question = MockQuestion(id: "1",question: "John, Paul, George and Ringo were members of which band?", category: "Music", type: .multipleChoice, difficulty: .easy, answers: ["The Beatles","The Rolling Stones","The Trogs","The Doors"], correctAnswerIndex: 0)
		return Just<Question>(question).setFailureType(to: Error.self).eraseToAnyPublisher()
	}
	
	public var gameStatusPublisher: AnyPublisher<GameState, Error> {
		return $mockState.map { (status) -> GameState in
				GameState(status: status.rawValue, id: "1")
			}.setFailureType(to: Error.self).eraseToAnyPublisher()
		
	}
	
	public var playerStatusPublisher: AnyPublisher<PlayerState, Error> {
		return Just<PlayerState>( PlayerState(id: "1", score: 10, results: ["1":true])).setFailureType(to: Error.self).eraseToAnyPublisher()
	}
	
	public func register(player: Player, for gameID: String) {
		self.mockState = .inProgress
	}
	
	public func send(answer: String, for player: Player, in gameID: String, questionID: String) {
		self.mockState = .over
		
	}
	
    
}
