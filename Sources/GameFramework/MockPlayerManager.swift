//
//  MockPlayerManager.swift
//  QuizzleTV
//
//  Created by Paul Wilkinson on 2/2/19.
//  Copyright © 2019 Paul Wilkinson. All rights reserved.
//

import Foundation

public class MockPlayerManager: NSObject, PlayerManager {
    
    private var mockPlayers = [Player]()
    
    private var answerHandler: AnswerHandler?
    
    public override init() {
        super.init()
        mockPlayers.append(Player(id: "1", name: "Bob"))
        mockPlayers.append(Player(id: "2", name: "Mary"))
        mockPlayers.append(Player(id: "3", name: "Alice"))
    }
    
    public func gatherPlayers(for game: Game, newPlayerHandler: @escaping NewPlayerHandler) throws {
        for player in self.mockPlayers {
            newPlayerHandler(player)
        }
    }
    
    public func stopGatheringPlayers(for game: Game) {
        
    }
    
    public func welcome(player: Player, to game: Game) {
        
    }
    
    public func listenForAnswers(in game: Game, answerHandler: @escaping AnswerHandler) throws {
        self.answerHandler = answerHandler
    }
    
    public func stopListeningForAnswers(in game: Game) {
        self.answerHandler = nil
    }
    
    public func notifyGameStart(for game: Game) {
        
    }
    
    public func requestAnswer(for question: Question, with id: String, in game: Game) {
        for player in self.mockPlayers {
            if let answer = question.answers.randomElement() {
                let randomTime = DispatchTime.now() + Double.random(in: 1...5)
                DispatchQueue.main.asyncAfter(deadline: randomTime, execute: {
                    print("\(player.name) answers \(answer)")
                    self.answerHandler?(player.id,answer)
                })
            }
        }
    }

public func adviseGameOver(for game: Game) {
    
}

public func listenForQuestions(for gameID: String, questionHandler: @escaping QuestionHandler) throws {
    
}

public func listenForGameStatus(for gameID: String, statusHandler: @escaping GameStatusHandler) throws {
    
}

public func stopListeningForQuestions(for gameID: String) {
    
}

public func stopListeningForGameStatus(for gameID: String) {
    
}

public func register(player: Player, for gameID: String) {
    
}

public func send(answer: String, for playerID: String, in gameID: String, questionID: String) {
    
}


}
