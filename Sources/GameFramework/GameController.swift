//
//  GameController.swift
//  QuizzleTV
//
//  Created by Paul Wilkinson on 24/12/18.
//  Copyright © 2018 Paul Wilkinson. All rights reserved.
//

import Foundation


public class GameController  {
    
    public private (set) var currentGame: Game? 
    public let provider: GameProvider?
    public let playerManager: PlayerManager
    public private (set) var players = [Player]()
    
    public var delegate: GameControllerDelegate?
    
    private var currentQuestionIndex: Int? = nil
    private var answerCount = 0
    
    private var playerScores = [Player:Int]()
    
    public init(playerManager: PlayerManager, provider: GameProvider? = nil) {
        self.provider = provider
        self.playerManager = playerManager
    }
    
    public func newGame(gameSize: Int, difficulty: Difficulty?, category: GameCategory?) throws {
        guard let provider = self.provider else {
            throw GameError("No provider")
        }
        self.currentGame = Game(gameSize: gameSize, difficulty: difficulty, category: category)
        self.players = [Player]()
        self.currentGame?.fetchQuestions(from: provider)
    }
    
    public func gatherPlayers(callback: @escaping NewPlayerHandler) throws {
        guard let game = self.currentGame else {
            return
        }
        
        try self.playerManager.gatherPlayers(for: game) { (player) in
            self.players.append(player)
            callback(player)
        }
    }
    
    public func stopGatheringPlayers() {
        guard let game = self.currentGame else {
            return
        }
        
        self.playerManager.stopGatheringPlayers(for: game)
    }
    
    public func playGame() {
        guard let game = currentGame else {
            return
        }
        self.currentQuestionIndex = nil
        do {
            try self.playerManager.listenForAnswers(in: game) { (playerID, answer) in
                
                guard let player = self.playerWith(id: playerID),
                    let questionIndex = self.currentQuestionIndex,
                    let question = self.currentGame?.questions?[questionIndex] else {
                        return
                }
                
                let correct = (answer == question.answers[question.correctAnswerIndex])
                
                if correct {
                    self.add(score: 10, to: player)
                }
                
               
                self.answerCount += 1
                let lastAnswer = self.answerCount == self.players.count
                if lastAnswer {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                        self.askQuestion()
                    })
                }
                
                self.delegate?.receivedAnswer(correct: correct, from: player, for: question, lastAnswer:lastAnswer)
            }
            self.askQuestion()
        }
        catch {
            
        }
    }
    
    public func endGame() {
        guard let game = currentGame else {
            return
        }
        playerManager.stopListeningForAnswers(in: game)
        playerManager.adviseGameOver(for: game)
        self.delegate?.gameOver()
        self.currentGame = nil
        
    }
    
    public func score(for player:Player) -> Int {
        return self.playerScores[player, default:0]
    }
    
    
    private func askQuestion() {
        
        self.answerCount = 0
        
        let questionIndex = (self.currentQuestionIndex ?? -1) + 1
        
        if questionIndex < (self.currentGame?.questions?.count ?? 0) {
        
        guard let question = currentGame?.questions?[questionIndex], let game=self.currentGame else {
            return
        }
        self.currentQuestionIndex = questionIndex
        self.delegate?.asked(question: question, index: questionIndex)
        self.playerManager.requestAnswer(for: question, with: String(questionIndex), in: game)
        } else {
            self.endGame()
        }
        
    }
    
    private func add(score: Int, to player: Player) {
        self.playerScores[player] = self.playerScores[player, default:0] + score
    }
    
    private func playerWith(id: String) -> Player? {
        
        return self.players.first(where: { (player) -> Bool in
            return player.id == id
        })
    }
    
}

