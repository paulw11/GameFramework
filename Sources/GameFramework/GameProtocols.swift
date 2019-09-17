//
//  GameProtocols.swift
//  GameFramework
//
//  Created by Paul Wilkinson on 5/1/19.
//  Copyright © 2019 Paul Wilkinson. All rights reserved.
//

import Foundation
import Combine

public typealias CategoriesResponse = ([GameCategory]?,Error?) -> Void
public typealias QuestionsResponse = ([Question]?,Error?) -> Void
public typealias NewPlayerHandler = (Player) -> Void
public typealias AnswerHandler = (String, String) -> Void
public typealias QuestionHandler = (Question, Int) -> Void
public typealias GameStatusHandler = (String, Bool) -> Void

public protocol GameProvider {
	
	var categoryPublisher: AnyPublisher<[GameCategory],Error> { get }
	var questionPublisher: AnyPublisher<[Question],Error> { get }
	
  //  func getCategories(completion: @escaping CategoriesResponse)
  //  func getQuestions(for game: Game, completion: @escaping QuestionsResponse)
	var difficulties:[Difficulty] { get }
	var durations:[Int] { get }
}

public protocol PlayerManager {
    func gatherPlayers(for game: Game, newPlayerHandler: @escaping NewPlayerHandler) throws
    func stopGatheringPlayers(for game: Game)
    func welcome(player: Player, to game: Game)
    func listenForAnswers(in game: Game, answerHandler: @escaping AnswerHandler) throws
    func stopListeningForAnswers(in game: Game)
    func notifyGameStart(for game: Game)
    func requestAnswer(for question: Question, with id: String, in game: Game)
    func adviseGameOver(for game: Game)
    
    func listenForQuestions(for gameID: String, questionHandler: @escaping QuestionHandler) throws
    func listenForGameStatus(for gameID: String, statusHandler: @escaping GameStatusHandler) throws
    func stopListeningForQuestions(for gameID: String)
    func stopListeningForGameStatus(for gameID: String)
    func register(player: Player, for gameID: String)
    func send(answer: String, for playerID: String, in gameID: String, questionID: String)
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

public enum GameStatus {
	case initialised
	case ready
	case inProgress
	case over 
	case failed(Error)
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
}

public protocol GameControllerDelegate {
    func receivedAnswer(correct: Bool, from player: Player, for question:Question, lastAnswer: Bool)
    func asked(question: Question, index: Int)
    func gameOver()
}

public struct Player:Codable, Hashable {
    public let id: String
    public let name: String
    
    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }
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
