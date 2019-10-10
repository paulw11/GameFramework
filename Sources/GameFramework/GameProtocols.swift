//
//  GameProtocols.swift
//  GameFramework
//
//  Created by Paul Wilkinson on 5/1/19.
//  Copyright © 2019 Paul Wilkinson. All rights reserved.
//

import Foundation
import Combine

public protocol GameProvider {
	
	var categoryPublisher: AnyPublisher<[GameCategory],GameFrameworkError> { get }
	var questionPublisher: AnyPublisher<[Question],GameFrameworkError> { get }
	
	//  func getCategories(completion: @escaping CategoriesResponse)
	//  func getQuestions(for game: Game, completion: @escaping QuestionsResponse)
	var difficulties:[Difficulty] { get }
	var difficulty: Difficulty? { get set }
	var durations: [Int] { get }
	var duration: Int? { get set }
	var category: GameCategory? { get set }
}

public protocol PlayerCoordinator {
	func gatherPlayers(for game: Game) throws
	func stopGatheringPlayers(for game: Game)
	func welcome(player: Player, to game: Game)
	func set(status: GameStatus, for game: Game)
	func requestAnswer(for question: Question, with id: String, in game: Game)
	
	var playerPublisher: AnyPublisher<Player,Error> { get }
	var answerPublisher: AnyPublisher<PlayerAnswer,Error> { get }
	var players: [Player] { get }
	
}

public protocol PlayerManager {
	
	var questionPublisher: AnyPublisher<Question,Error> { get }
	var gameStatusPublisher: AnyPublisher<GameState,Error> { get }
	var playerStatusPublisher: AnyPublisher<PlayerState,Error> { get }
	func register(player: Player, for gameID: String)
	func send(answer: String, for player: Player, in gameID: String, questionID: String)
}

public protocol GameCategory {
	var id: Int {get}
	var name: String {get}
}

public protocol Question {
	var question: String {get}
	var category: String {get}
	var type: QuestionType {get}
	var difficulty: Difficulty {get}
	var answers: [String] {get}
	var correctAnswerIndex: Int {get}
	var id: String { get }
}

public protocol GameControllerDelegate {
	func receivedAnswer(correct: Bool, from player: Player, for question:Question, lastAnswer: Bool)
	func asked(question: Question, index: Int)
	func gameOver()
}

public enum Difficulty: String {
	case any = "any"
	case easy = "easy"
	case medium = "medium"
	case hard = "hard"
}

public enum QuestionType: String {
	case multipleChoice = "multiple"
	case boolean = "boolean"
}

public enum GameStatus: String {
	case initialised = "initialised"
	case ready = "ready"
	case inProgress = "inProgress"
	case over = "over"
	case failed = "failed"
}

public enum GameFrameworkError: Error {
	case networkError(Error)
	case gameParametersRequired
	case noQuestionsAvailable
	case invalidState
	case unknown
}
