//
//  MockPlayerCoordintor.swift
//  
//
//  Created by Paul Wilkinson on 18/9/19.
//

import Combine
import Foundation

public final class MockPlayerCoordinator: PlayerCoordinator {
	
	struct MockAnswer {
		let player: Player
		let answer: String
		let question: Question
	}
	
	struct MockJoin {
		let player: Player
	}
	
	private var mockPlayers: [Player] = {
		var players = [Player]()
		players.append(Player(id: "1", name: "Bob"))
		players.append(Player(id: "2", name: "Mary"))
		players.append(Player(id: "3", name: "Alice"))
		return players
	}()
	
	private var gathering = false
	private var gameStatus: GameStatus = .initialised
	private var gameID: String?

	@Published
	private var mockJoin: MockJoin? = nil
	
	@Published
	private var mockAnswer: MockAnswer? = nil
	
	public func gatherPlayers(for game: Game) throws {
		self.gathering = true
		if self.gameStatus == .ready {
			for player in mockPlayers {
				self.mockJoin = MockJoin(player: player)
			}
		}
	}
	
	public func stopGatheringPlayers(for game: Game) {
		self.gathering = false
	}
	
	public func welcome(player: Player, to game: Game) {
		
	}
	
	public func set(status: GameStatus, for game: Game) {
		self.gameID = game.gameCode
		self.gameStatus = status
	}
	
	public func requestAnswer(for question: Question, with id: String, in game: Game) {
		
	}

	
	public var playerPublisher: AnyPublisher<Player, Error> {
		return $mockJoin.tryMap { (mockJoin) -> Player in
			if let mj = self.mockJoin {
				return mj.player
			} else {
				throw GameFrameworkError.unknown
			}
		}.eraseToAnyPublisher()
	}
	
	public var answerPublisher: AnyPublisher<PlayerAnswer, Error> {
		return $mockAnswer.tryMap { (mockAnswer) -> PlayerAnswer in
			if let ma = mockAnswer, let gameid = self.gameID {
				return PlayerAnswer(gameID: gameid, playerID: ma.player.id, questionId: ma.question.id, answer: ma.question.answers.first!)
			} else {
				throw GameFrameworkError.unknown
			}
		}.eraseToAnyPublisher()
	}
	
	public var players: [Player] {
		return self.mockPlayers
	}
	
	
}
